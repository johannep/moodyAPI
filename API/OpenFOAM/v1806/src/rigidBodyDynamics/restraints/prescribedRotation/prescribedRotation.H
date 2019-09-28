/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           | Copyright (C) 2018 OpenCFD Ltd.
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
    Foam::RBD::restraints::prescribedRotation

Group
    grpRigidBodyDynamicsRestraints

Description
    Restraint setting angular velocity of the rigid body.
    Developed from the linear axial angular spring restraint.

    Adds a rotation along given axis to the body.
    Used for a combination of 6DOF bodies where one is driven by 6DOF and
    the other attached to it using specified rotation
    in the local reference frame.

Usage
    \table
        Property     | Description                  | Required | Default value
        referenceOrientation | Orientation          | no       | I
        axis         | Rotation axis (in reference) | yes      |
        omega        | Angular velocity (rad/s)     | yes      |
    \endtable

SourceFiles
    prescribedRotation.C

\*---------------------------------------------------------------------------*/

#ifndef prescribedRotation_H
#define prescribedRotation_H

#include "rigidBodyRestraint.H"
#include "TimeFunction1.H"

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{
namespace RBD
{
namespace restraints
{

/*---------------------------------------------------------------------------*\
                   Class prescribedRotation Declaration
\*---------------------------------------------------------------------------*/

class prescribedRotation
:
    public restraint
{
    // Private data

        //- Reference orientation where there is no moment
        tensor refQ_;

        //- Global unit axis around which the motion is sprung
        vector axis_;

        //- Rotational velocity [rad/sec]
        TimeFunction1<vector> omegaSet_;


public:

    //- Runtime type information
    TypeName("prescribedRotation");


    // Constructors

        //- Construct from components
        prescribedRotation
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
                new prescribedRotation(*this)
            );
        }


    //- Destructor
    virtual ~prescribedRotation();


    // Member Functions

        //- Accumulate the retraint internal joint forces into the tau field and
        //  external forces into the fx field
        virtual void restrain
        (
            scalarField& tau,
            Field<spatialVector>& fx
        ) const;

        //- Update properties from given dictionary
        virtual bool read(const dictionary& dict);

        //- Write
        virtual void write(Ostream&) const;
};


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace RBD
} // End namespace RBD
} // End namespace Foam

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

#endif

// ************************************************************************* //
