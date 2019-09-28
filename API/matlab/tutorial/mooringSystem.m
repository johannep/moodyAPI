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

print.dt = 0.02;
%% extra quadpoints used for increased ground contact performance.
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
    7    [ 0 0 0];
    };
                   
                         
%----- Object definitions -----%
cable1.typeNumber = 1;
cable1.startVertex = 1; %
cable1.endVertex = 2; %
cable1.length = 6.95; % 
cable1.IC.type = 'CatenaryStatic';
cable1.mesh.N = 10; % 
% % 
cable2=cable1;
cable2.startVertex = 3; %
cable2.endVertex = 4; %
% %
cable3=cable1;
cable3.startVertex = 5; %
cable3.endVertex = 6; %

%-------------------------------------------------------------------------%
%                           Boundary conditions                           %
%-------------------------------------------------------------------------%

bc1.vertexNumber = 1;
bc1.type = 'dirichlet';
bc1.mode = 'fixed';
%
bc2=bc1;
bc2.vertexNumber = 3;
% 
bc3=bc1;
bc3.vertexNumber = 5;

bc4.vertexNumber = 7;
bc4.type = 'dirichlet';
bc4.mode = 'externalRigidBody';
bc4.inputDoFs = 6; % could be 7 as well
bc4.slaves = [2 4 6];
bc4.slavePositions = [
                        [-0.1362   0.2360   0.0]
                       [-0.1362   -0.2360   0.0];
                        [ 0.2725   0.0      0.0]
                      ];
               
% --- API conectivitity --- %
API.bcNames = {'bc4'};
API.reboot= 'no';
API.syncOutput = 0; 
API.staggerTimeFraction= 0.5;

% ===== END OF FILE ===== %
