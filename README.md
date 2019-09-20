# moodyAPI
The API of Moody: A dynamic mooring library used for coupled station-keeping simulations in OpenFOAM and other hydrodynamic codes.
VERSION 2.0

This is an updated version of Moody. Highlights of the updates are listed below: 

1. Submerged rigid bodies of Morison type. (Points and Cylinders)

2. New API-functions allowing the external flow to be passed to Moody. 
	Includes a size-function, a sample function and a setFlow function for an improved flow interaction.

3. A first step towards Windows compatibility. This is still untested but is released here as a beta version. More updates to come.  
	Please let me know if and how it does not work. 

4. Stability improvements, bug-fixes and improved error handling.

5. moodyPost.x has been extended with a cleaning option. 
	In case simulations crash or are aborted in API mode, this function ensures that the time trace and results of moody are causal and  viewable via readCase.m.
	Usage: moodyPost.x <yourMoodyOutput> -clean  

The current version of moody is aimed at coupled simulations. The mooring code itself is precompiled, however the coupling functionality is here released as open source. The primary aim is to release the OpenFOAM-Moody restraint which enables dynamic mooring restraints in OpenFOAM. It requires some changes to the native rirgid body motion framework, and therefore a modified src-code of the v1712+, v1806 and v1906 rigid body libraries are also included in this release. Other interfaces are to matlab and to fortran (with a road-map to FAST-v7 coupling. This has not been tested for moody-2.0.0).

There are two tutorials for stand-alone mooring simulations (under directory tutorials, who would have guessed...), and two tutorials for coupled simulations (matlab and OpenFOAM)  

Please see the user manual for an extensive explanation of the installation and the usage of the code in stand alone as well as in coupled mode. Appended to the user manual is a theory manual which describes the discretisation procedure used in Moody. 

This is the first update of the code since the first release for public use last year.
Please contact johannes.palm@chalmers.se for any questions or feedback on the code performance. 

Johannes Palm
2019-09-20
Gothenburg
