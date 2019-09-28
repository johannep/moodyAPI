/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           | Copyright (C) 2016 OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

\*---------------------------------------------------------------------------*/

#include "moodyR.H"
#include "rigidBodyModel.H"
#include "addToRunTimeSelectionTable.H"
#include "moodyWrapper.h"
#include <vector>
#include "Time.H"


// * * * * * * * * * * * * * * Static Data Members * * * * * * * * * * * * * //

namespace Foam
{
namespace RBD
{
namespace restraints
{
    defineTypeNameAndDebug(moodyR, 0);

    addToRunTimeSelectionTable
    (
        restraint,
        moodyR,
        dictionary
    );
}
}
}


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

Foam::RBD::restraints::moodyR::moodyR
(
    const word& name,
    const dictionary& dict,
    const rigidBodyModel& model
)
:
	restraint(name, dict, model),
	attachPts_(),
	bodyIDs_(),
	bodyIndices_(),
	mooringSystemFilename_(),
	noOfAttachments_(),
	mooringRampTime_(),
	startTime_(0.0),
	moored_(false),
	moodyStarted_(false)
{
    read(dict);

    Info << "body ID is: " << bodyID_ << endl;
    Info << "body IDs are: " << bodyIDs_ << endl; 
}

//- Compute a linear mooringRamp based on current time value.
Foam::scalar Foam::RBD::restraints::moodyR::mooringRamp() const
{
	scalar moorRamp = 1.0;

	if ( mooringRampTime_>0.0 )
	{
		moorRamp = max(
						0.0, 
						min(
							(model_.time().value()-startTime_)/(mooringRampTime_), 
							1.0
							) 
						);
	}
	Info << "moorRamp is : " << moorRamp << endl;
	return moorRamp;
}		


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

Foam::RBD::restraints::moodyR::~moodyR()
{
    if ( moodyStarted_ )
    {    
	moodyClose();
	moodyStarted_=false;
    }
}


// * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * * //

void Foam::RBD::restraints::moodyR::restrain
(
    scalarField& tau,
    Field<spatialVector>& fx
)
{
	Info << "Restraining body" << endl;

	double t = model_.time().value();
	double tPrev = t - model_.time().deltaTValue();
		
	// Do the first time: Open up a moody API object //
	if ( !moodyStarted_ && moored_ )
	{
		std::vector<std::string> inputFlags;
		// Add the input and output file name to the flags
		inputFlags.push_back("-f");
		inputFlags.push_back(mooringSystemFilename_);
		
		// Generate and fill the formated inputs std::vector<double> attachInfo for moody.h	
		std::vector<double> attachInfo(3*noOfAttachments_); // Always 3D!
		point startAttachPoint;
		for ( int ii = 0; ii<noOfAttachments_; ++ii)
		{
			// Transform the starting points to last motion state
			startAttachPoint = bodyPoint(attachPts_[ii],bodyIDs_[ii]);

			// Fill attachInfo with values //
			attachInfo[ii*3] = startAttachPoint[0];
			attachInfo[ii*3+1] = startAttachPoint[1];
			attachInfo[ii*3+2] = startAttachPoint[2];
		}

		Info << "Initialising mooring software MOODY" << endl;

		moodyInit(mooringSystemFilename_.c_str(), 3*noOfAttachments_ , &(attachInfo[0]) , tPrev);
			
		moodyStarted_ = true;		
	}

	if ( moored_ )
	{	
		// Compute values at present motion state
		std::vector<double> attachInfo(3*noOfAttachments_); // Allways 3D!
		List<point> currentPositions(attachPts_);

		for ( int ii = 0; ii<noOfAttachments_; ++ii)
		{
			// Transform the starting points to present motion state
			currentPositions[ii] = bodyPoint(attachPts_[ii],bodyIDs_[ii]);

			// Fill attachInfo with transformed values
			attachInfo[ii*3] =   currentPositions[ii].x();
			attachInfo[ii*3+1] = currentPositions[ii].y();
			attachInfo[ii*3+2] = currentPositions[ii].z();
		}

		// Send info to moody
		// Info << "Computing mooring forces..." << endl;
		
		std::vector<double> allForces(3*noOfAttachments_);
		Info << "Solving mooring system for time interval: [" << tPrev  << " , " << t << "]" << endl;
		moodySolve(&(attachInfo[0]) , &(allForces[0]) ,tPrev , t);
		
		Info << "Mooring forces computed!" << endl;
	
		//- Compute the mooring ramping factor \in [0,1]
		scalar moorRamp = mooringRamp();

		// Extract info from allForces and compute moment and total force
		vector force(vector::zero);		
		vector moment(vector::zero);	
			
		for ( int ii = 0; ii<noOfAttachments_; ++ii)
		{
			// Negative sign to account for outward pointing normal direction of forces
			force[0] = -moorRamp*allForces[ii*3];
			force[1] = -moorRamp*allForces[ii*3+1];
			force[2] = -moorRamp*allForces[ii*3+2];
	
			// Note: This is identical to what happens in linearSpring. But what of the rotation point? Currentpositions are in global coordinates. 
			moment = currentPositions[ii]^force;
	
		    // Accumulate the force for the restrained body
		    Info << "attachment point " << ii << 
			    ": (force, N) " << force << " (moment, Nm) " << moment << endl; 
		    fx[bodyIndices_[ii]] += spatialVector(moment, force);
		}
		
		/*
	    if (model_.debug)
    	{
    	    Info<< " attachmentPts " << attachmentPts_
    	        << " attachmentPt - anchor " << r*magR
    	        << " spring length " << magR
    	        << " force " << force
    	        << " moment " << moment
    	        << endl;
    	}    
    	*/
    }
}


bool Foam::RBD::restraints::moodyR::read
(
    const dictionary& dict
)
{
    restraint::read(dict);

	attachPts_=coeffs_.lookupOrDefault< List<point> >("attachmentPoints", List<point>());	
	noOfAttachments_ = int(attachPts_.size());
	
	if( noOfAttachments_ > 0 )
	{		
		// Allow for different bodies (subbodies) to be attached to the same moody restraint:
		
		// Initialise the sizes of bodyIDs, and bodyIndices
		bodyIDs_ = List<label>(noOfAttachments_,bodyID_);
		bodyIndices_ = List<label>(noOfAttachments_,bodyIndex_);
		 
		// If different bodies are attached to moody moorings:
		if (coeffs_.found("bodies") )
		{
			
			coeffs_.lookup("bodies") >> bodies_;
		
			for( int ii=0; ii<noOfAttachments_; ii++) 			
			{
				bodyIDs_[ii] = model_.bodyID(bodies_[ii]);
				bodyIndices_[ii] = model_.master(bodyIDs_[ii]);
			}
		}

		coeffs_.lookup("mooringSystemFilename") >> mooringSystemFilename_;
				
		mooringRampTime_=coeffs_.lookupOrDefault<scalar>("mooringRampTime",0.0);
               
		moored_ = true;
	 	Info << "moored?  : " << moored_ << endl;
 	}

	return true;
}


void Foam::RBD::restraints::moodyR::write
(
    Ostream& os
) const
{
    restraint::write(os);
    
   	os.writeEntry("attachmentPoints",attachPts_);
   	if (int(bodies_.size())>0)
	   	os.writeEntry("bodies",bodies_);   	
	   	
	os.writeEntry("mooringSystemFilename",mooringSystemFilename_);
	os.writeEntry("mooringRampTime",mooringRampTime_);
	os.writeEntry("startTime",startTime_);

}


// ************************************************************************* //
