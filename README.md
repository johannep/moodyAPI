# moodyAPI
The API of Moody: A dynamic mooring library used for coupled station-keeping simulations in OpenFOAM and other hydrodynamic codes.

The current version of moody is aimed at coupled simulations. The mooring code itself is precompiled, however the coupling functionality is here released opend source. The primary aim is to release the OpenFOAM-Moody restraint which enables dynamic mooring restraints in OpenFOAM. It requires some changes to the native rirgid body motion framework, and therefore a modified src-code of the v1712+ rigid body library is also included in this release. Other interfaces are to matlab and to fortran (with a road-map to FAST-v7 coupling).

There are two tutorials for stand-alone mooring simulations (under directory tutorials, who would have guessed...), and two tutorials for coupled simulations,  

Please see the user manual for an extensive explanation of the installation and the usage of the code in stand alone as well as in coupled mode. Appended to the user manual is a theory manual which describes the discretisation procedure used in Moody. 

This is the first release of the code for public use.
Please contact johannes.palm@chalmers.se for any questions or feedback on the code performance. 

Johannes Palm
2018-05-21
Gothenburg
