% NOTE: This file is made with legacy variable names. 
% All of these can still be used but are not documented in the manual. 
%-------------------------------------------------------------------------%
%----------------------------- Time settings -----------------------------%
%-------------------------------------------------------------------------%
startTime = 0;      	%   [s]     Start time
endTime = 10;       %   [s]     End time of simulation
timeStep =1e-4;     	%   [s]     Time step size
saveInterval = 1e-2;    % save results every xx time interval
timeStepScheme='RK3';   % use 3rd order Runge-Kutta time stepping

courantNo = 0.9; 


gravity = 1;            % [-]       Gravity is 1=on, 0=off

waterLevel = 0.5;         % [m]       z-coordinate of mean water level

waterDensity = 1.000e3; % [kg/m3]   Density of water (1000)
airDensity = 0;         % [kg/m3]   Density of air (1)
dimensionNumber = 3;       % [-]       1D, 2D or 3D : 1, 2 or 3 

 

%ground.type = 'springDampGround';
%ground.level = 0;
%ground.dampingCoeff = 1;
%ground.frictionCoeff = 1;
%ground.vc = 0.1;
%ground.stiffness = 1e6;



% Cable type:  
cableType1.diameter = 0.025;
cableType1.rho = 5000;
cableType1.gamma0 = 0.5;

cableType1.materialModel.type = 'bilinear';
cableType1.materialModel.EA = 1e3; % specific input to material model.

% Optional input of hydrodynamic coefficients (default value)
cableType1.CDn = 1.6; % (0)
cableType1.CDt = 0.05; % (0) 
cableType1.CMn = 1.0; % (0) 
cableType1.CMt = 0; % (0)
        

% note that unconnected  vertices are ignored. 
% vertice 5-8 are externally controlled. No need to specifyi exact value.
vertexLocations = {
                      1    [-1 -1 0];
                      2    [-1 1.9 0];
                      3    [2 1.9 0];
                      4    [2 -1 0];
                      5    [0.35 0.35 0.1];
                      6    [0.35 0.55 0.1];
                      7    [0.65 0.55 0.1];                            
                      8    [0.65 0.35 0.1];
                  };
      
%----- Object definitions -----%
cableObject1.typeNumber = 1;
cableObject1.startVertex = 1; %
cableObject1.endVertex = 5; %
cableObject1.length = 0.5; % 
cableObject1.IC.type = 'Prestrain';
cableObject1.IC.eps0 = 0.10; 
cableObject1.mesh.N = 8; % 

cableObject2.typeNumber = 1;
cableObject2.startVertex = 2; %
cableObject2.endVertex = 6; %
cableObject2=cableObject1; % use remaining info from cable1

cableObject3.typeNumber = 1;
cableObject3.startVertex = 3; %
cableObject3.endVertex = 7; %
cableObject3=cableObject1; % use remaining info from cable1

cableObject4.typeNumber = 1;
cableObject4.startVertex = 4; %
cableObject4.endVertex = 8; %
cableObject4=cableObject1; % use remaining info from cable1

%-------------------------------------------------------------------------%
%                           Boundary conditions                           %
%-------------------------------------------------------------------------%


bc1.vertexNumber = 1;
bc1.type = 'dirichlet'; % 'dirichlet, neumann or mixed.
bc1.mode = 'fixed';

bc2=bc1;
bc2.vertexNumber = 2;

bc3=bc1;
bc3.vertexNumber = 3;

bc4=bc1;
bc4.vertexNumber = 4;

bc5.vertexNumber = 5;
bc5.mode = 'externalPoint';
bc5.type = 'dirichlet';

bc6=bc5; 
bc6.vertexNumber = 6;

bc7=bc5;
bc7.vertexNumber = 7;

bc8=bc5;
bc8.vertexNumber = 8;


% Externally controlled rigid body motion. Slaves specify which additional
% vertices that are connected to the body. 

% --- API conectivitity --- %
% the order of the API input vector in moodySolve and moodyInit. 
API.bcNames = {'bc5','bc6','bc7','bc8'}; 

% Optional parameters (default value):
API.syncOutput = 1; % (1)
API.staggerTimeFraction = 0.5; % (0) 
API.reboot = 'no'; % ('yes')
API.output = 'mooring/results'; % (inputFilename without ".extension")

% ===== END OF FILE ===== %
