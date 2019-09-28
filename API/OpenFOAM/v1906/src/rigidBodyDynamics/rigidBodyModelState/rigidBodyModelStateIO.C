/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           |
     \\/     M anipulation  |
-------------------------------------------------------------------------------
                            | Copyright (C) 2016-2017 OpenFOAM Foundation
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

#include "rigidBodyModelState.H"
#include "IOstreams.H"

// * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * * //

void Foam::RBD::rigidBodyModelState::write(dictionary& dict) const
{
    dict.add("q", q_);
    dict.add("qDot", qDot_);
    dict.add("qDdot", qDdot_);
    dict.add("t", t_);
    dict.add("deltaT", deltaT_);
}


void Foam::RBD::rigidBodyModelState::write(Ostream& os) const
{
    os.writeEntry("q", q_);
    os.writeEntry("qDot", qDot_);
    os.writeEntry("qDdot", qDdot_);
    os.writeEntry("t", t_);
    os.writeEntry("deltaT", deltaT_);
}


// * * * * * * * * * * * * * * * IOstream Operators  * * * * * * * * * * * * //

Foam::Istream& Foam::RBD::operator>>
(
    Istream& is,
    rigidBodyModelState& state
)
{
    is  >> state.q_
        >> state.qDot_
        >> state.qDdot_
        >> state.t_
        >> state.deltaT_;

    is.check(FUNCTION_NAME);
    return is;
}


Foam::Ostream& Foam::RBD::operator<<
(
    Ostream& os,
    const rigidBodyModelState& state
)
{
    os  << state.q_
        << token::SPACE << state.qDot_
        << token::SPACE << state.qDdot_
        << token::SPACE << state.t_
        << token::SPACE << state.deltaT_;

    os.check(FUNCTION_NAME);
    return os;
}


// ************************************************************************* //
