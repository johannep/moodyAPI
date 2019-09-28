/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           | Copyright (C) 2018 OpenCFD ltd.
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

#include "prescribedRotation.H"
#include "rigidBodyModel.H"
#include "addToRunTimeSelectionTable.H"
#include "Time.H"

// * * * * * * * * * * * * * * Static Data Members * * * * * * * * * * * * * //

namespace Foam
{
namespace RBD
{
namespace restraints
{
    defineTypeNameAndDebug(prescribedRotation, 0);

    addToRunTimeSelectionTable
    (
        restraint,
        prescribedRotation,
        dictionary
    );
}
}
}


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

Foam::RBD::restraints::prescribedRotation::prescribedRotation
(
    const word& name,
    const dictionary& dict,
    const rigidBodyModel& model
)
:
    restraint(name, dict, model),
    omegaSet_(model_.time(), "omega")
{
    read(dict);
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

Foam::RBD::restraints::prescribedRotation::~prescribedRotation()
{}


// * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * * //

void Foam::RBD::restraints::prescribedRotation::restrain
(
    scalarField& tau,
    Field<spatialVector>& fx
) const
{
    vector refDir = rotationTensor(vector(1, 0, 0), axis_) & vector(0, 1, 0);

    vector oldDir = refQ_ & refDir;
    vector newDir = model_.X0(bodyID_).E() & refDir;

    if (mag(oldDir & axis_) > 0.95 || mag(newDir & axis_) > 0.95)
    {
        // Directions close to the axis, changing reference
        refDir = rotationTensor(vector(1, 0, 0), axis_) & vector(0, 0, 1);
        oldDir = refQ_ & refDir;
        newDir = model_.X0(bodyID_).E() & refDir;
    }

    // Removing axis component from oldDir and newDir and normalising
    oldDir -= (axis_ & oldDir)*axis_;
    oldDir /= (mag(oldDir) + VSMALL);

    newDir -= (axis_ & newDir)*axis_;
    newDir /= (mag(newDir) + VSMALL);

    scalar theta = mag(acos(min(oldDir & newDir, 1.0)));

    // Temporary axis with sign information
    vector a = (oldDir ^ newDir);

    // Ensure a is in direction of axis
    a = (a & axis_)*axis_;

    scalar magA = mag(a);

    if (magA > VSMALL)
    {
        a /= magA;
    }
    else
    {
        a = Zero;
    }

    // Adding rotation to a given body
    vector omega = model_.v(model_.master(bodyID_)).w();
    scalar Inertia = mag(model_.I(model_.master(bodyID_)).Ic());

    // from the definition of the angular momentum:
    //  moment = Inertia*ddt(omega)
    const scalar relax = 0.5;

    vector moment
    (
        (
            relax
          * Inertia
          * (omegaSet_.value(model_.time().value()) - omega)
          / model_.time().deltaTValue()
          & a
        )
      * a
    );

    if (model_.debug)
    {
        Info<< " angle  " << theta*sign(a & axis_) << endl
            << " omega  " << omega << endl
            << " wanted " << omegaSet_.value(model_.time().value()) << endl
            << " moment " << moment << endl
            << " oldDir " << oldDir << endl
            << " newDir " << newDir << endl
            << " refDir " << refDir
            << endl;
    }

    // Accumulate the force for the restrained body
    fx[bodyIndex_] += spatialVector(moment, Zero);
}


bool Foam::RBD::restraints::prescribedRotation::read
(
    const dictionary& dict
)
{
    restraint::read(dict);

    refQ_ = coeffs_.lookupOrDefault<tensor>("referenceOrientation", I);

    if (mag(mag(refQ_) - sqrt(3.0)) > ROOTSMALL)
    {
        FatalErrorInFunction
            << "referenceOrientation " << refQ_ << " is not a rotation tensor. "
            << "mag(referenceOrientation) - sqrt(3) = "
            << mag(refQ_) - sqrt(3.0) << nl
            << exit(FatalError);
    }

    axis_ = coeffs_.lookup("axis");

    scalar magAxis(mag(axis_));

    if (magAxis > VSMALL)
    {
        axis_ /= magAxis;
    }
    else
    {
        FatalErrorInFunction
            << "axis has zero length"
            << abort(FatalError);
    }

    // Read the actual entry
    omegaSet_.reset(coeffs_);

    return true;
}


void Foam::RBD::restraints::prescribedRotation::write
(
    Ostream& os
) const
{
    restraint::write(os);

    os.writeEntry("referenceOrientation", refQ_);
    os.writeEntry("axis", axis_);
    omegaSet_.writeData(os);
}


// ************************************************************************* //
