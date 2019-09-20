%% Moody model file for 3 catenary chains
% The experimental setup is that of Paredes et al. (2016)
% which was later used for numerical validated of Moodys coupling to
% OpenFOAM in Palm et al. (2016)
%
% 
% G. Paredes, J. Palm, and C. Eskilsson, L. Bergdahl and F. Taveira-Pinto,
% Experimental investigation of mooring configurations for wave energy converters
% Int. J. of Marine Energy 15. 56-67 (2016)
% 
% J. Palm, C. Eskilsson, G. Paredes and L. Bergdahl,
% Coupled mooring analysis for floating wave energy converters using CFD: Formulation and validation,
% Int. J. of Marine Energy, 16. 83-99 (2016)

% script for case setup %
dimensionNumber = 3;
waterLevel = 0;         % [m]       z-coordinate of mean water level
waterDensity = 1000.0;     % [kg/m??]   Density of water
airDensity = 1.0;         % [kg/m??]   Density of air
gravity = 1;

time.start  = 0;
time.end = 10;
time.cfl = 0.9;
time.scheme = 'RK3';

print.dt = 0.02; % output interval.

%% extra quadpoints used for increased ground contact performance.
% it makes the difference between stable and non-stable results. 
numLib.qPointsAdded = 10;

%-------------------------------------------------------------------------%
%--------------------------- Ground model input  -------------------------%
%-------------------------------------------------------------------------%
ground.type = 'springDampGround';
ground.level = -0.9;
ground.dampingCoeff = 1.0;
ground.frictionCoeff = 0.1;
ground.vc = 0.01;
ground.stiffness = 300.0e6;

%-------------------------------------------------------------------------%
%---------------------------- Type definition ----------------------------%
%-------------------------------------------------------------------------%
cableType1.diameter = 0.005;
cableType1.gamma0 = 0.15;
cableType1.CDn = 1.5;
cableType1.CDt = 0.5;
cableType1.CMn = 1.5;
cableType1.materialModel.type = 'biLinear';
cableType1.materialModel.EA =  1.0e4;
        
%-------------------------------------------------------------------------%
%------------------------------- Geometry --------------------------------%

vertexLocations = {
                       1    [-3.4587   5.9907  -0.9];
                       2    [-0.1362   0.2360   0.0];
                       3    [-3.4587  -5.9907  -0.9];
                       4    [-0.1362  -0.2360   0.0];
                       5    [ 6.9175   0.0      -0.9];
                       6    [ 0.2725   0.0      0.0];                       
                  };
                   
                         
%----- Object definitions -----%
cable1.typeNumber = 1;
cable1.startVertex = 1; %
cable1.endVertex = 2; %
cable1.length = 6.95; % 
cable1.IC.type = 'CatenaryStatic';
cable1.mesh.N = 10; % 
% 
% Copy remaining info from cable1. short hand
cable2=cable1;
cable2.startVertex = 3; 
cable2.endVertex = 4; 
%
cable3=cable1;
cable3.startVertex = 5; 
cable3.endVertex = 6; 

%-------------------------------------------------------------------------%
%                           Boundary conditions                           %
%-------------------------------------------------------------------------%

% Three anchors defined by vertexLocations
bc1.vertexNumber = 1;
bc1.type = 'dirichlet';
bc1.mode = 'fixed';
%
bc2=bc1;
bc2.vertexNumber = 3;
% 
bc3=bc1;
bc3.vertexNumber = 5;


% Same sinusoidal motion on all three fairleads. 
bc4.vertexNumber = 2;
bc4.type = 'dirichlet';
bc4.mode = 'sine';
bc4.amplitude = [0.025 0 0.025];
bc4.frequency = 1;
bc4.phase = [0;0;-90];
bc4.rampTime = 1;

bc5=bc4;
bc5.vertexNumber = 4;

bc6=bc4;
bc6.vertexNumber = 6;

% To remove initial fluctuations due to very stiff ground
staticSolver.relax = 1;
staticSolver.relaxFactor = 0.9;

% ===== END OF FILE ===== %
