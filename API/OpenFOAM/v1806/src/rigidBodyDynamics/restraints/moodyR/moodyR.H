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

Class
    Foam::RBD::restraints::moodyR

Group
    grpRigidBodyDynamicsRestraints

Description
    Linear spring restraint.

SourceFiles
    moodyR.C

\*---------------------------------------------------------------------------*/

#ifndef RBD_restraints_moodyR_H
#define RBD_restraints_moodyR_H

#include "rigidBodyRestraint.H"

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{
namespace RBD
{
namespace restraints
{

/*---------------------------------------------------------------------------*\
                          Class moodyR Declaration
\*---------------------------------------------------------------------------*/

class moodyR
:
    public restraint
{
    // Private data

		// Reference points of attachment to the solid body //
		List<point> attachPts_;

		// List of body names for each attachment point. Default is empty list. //
		List<word> bodies_;		
				
		// List of body IDs for each attachment point. Default is bodyID_ for all. //
		List<label> bodyIDs_;		
		
		// List of body indices for each attachment point. Default is bodyID_ for all. //
		List<label> bodyIndices_;	
		
		// Word containing the filename of the input file for the mooring system //
		string mooringSystemFilename_;		

		// The number of attachment points //
		int noOfAttachments_;

		// The ramp time of the mooring force (not invoked in moody, but before force is returned to motion_ //
		scalar mooringRampTime_;

		// Last call time of function //
		scalar startTime_;
		
		// If moored or not
		bool moored_;
		
		// Switch to ensure that moody is only intialised once
		bool moodyStarted_;

		
		// Private member function
		scalar mooringRamp() const;
		
public:

    //- Runtime type information
    TypeName("moodyR");


    // Constructors

        //- Construct from components
        moodyR
        (
            const word& name,
            const dictionary& dict,
            const rigidBodyModel& model
        );

        //- Construct and return a clone
        virtual autoPtr<restraint> clone() const
        {
            return autoPtr<restraint>
            (
                new moodyR(*this)
            );
        }


    //- Destructor
    virtual ~moodyR();


    // Member Functions

        //- Accumulate the restraint internal joint forces into the tau field and
        //  external forces into the fx field
        virtual void restrain
        (
            scalarField& tau,
            Field<spatialVector>& fx
        );

        //- Update properties from given dictionary
        virtual bool read(const dictionary& dict);

        //- Write
        virtual void write(Ostream&) const;
        /*
        // Transform of the previous state body point 
		inline point bodyPoint0(const point& p) const
		{
			return (model_.prevX0(bodyID_).inv() && spatialVector(Zero, p)).l();
		}

		//- The two transform functions are needed if different attach-pts have different bodies
		
        // Transform of the previous state body point for a given bodyID
		inline point bodyPoint0(const point& p,const label bodyID) const
		{
			return (model_.prevX0(bodyID).inv() && spatialVector(Zero, p)).l();
		}
	*/	
		// Transform of the previous state body point for a given bodyID
		inline point bodyPoint(const point& p,const label bodyID) const
		{
			return (model_.X0(bodyID).inv() && spatialVector(Zero, p)).l();
		}

};


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace restraints
} // End namespace RBD
} // End namespace Foam

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

#endif

// ************************************************************************* //
