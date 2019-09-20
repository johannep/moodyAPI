time.start = 0;      %   [s]     Start time
time.end = 20;        %   [s]     End time of simulation
time.dt = 1e-4;     %   [s]     Time step size
time.cfl = 0.6; % use adaptive time step based on max courant number

print.dt = 1e-2;    % save results every xx time interval

gravity = 1;            % [-]       Gravity is 1=on, 0=off
waterLevel = 3;         % [m]       z-coordinate of mean water level
waterDensity = 1e3;     % [kg/m??]   Density of water
airDensity = 0.0;         % [kg/m??]   Density of air
dimensionNumber = 2;    % [-]       1D, 2D or 3D : 1, 2 or 3

%-------------------------------------------------------------------------%
%--------------------------- Ground model input  -------------------------%
%-------------------------------------------------------------------------%
ground.type = 'springDampGround';
ground.level = 0;
ground.dampingCoeff = 1;
ground.frictionCoeff = 0.3;
ground.vc = 0.01;
ground.stiffness = 3e9;
                    
%-------------------------------------------------------------------------%
%---------------------------- Type definition ----------------------------%
%-------------------------------------------------------------------------%

cableType1.diameter = 0.0022;
cableType1.rho = 7800;
cableType1.gamma0 = 0.0818;
cableType1.CDn = 2.5;
cableType1.CDt = 0.5;
cableType1.CMn = 3.8;
cableType1.materialModel.type = 'bilinear';
cableType1.materialModel.EA = 1e4; % specific input to material model.


%----- List of vertices -----%
%                       no.     x       y       z                     
vertexLocations =       {   
                        1     [ 0       0      0 ];
                        2     [ 32.554      0    3.3]
                        };
                    
%----- Object definitions -----%
cable1.typeNumber = 1;
cable1.startVertex = 1; %
cable1.endVertex = 2; %
cable1.length = 33; %
cable1.IC.type = 'CatenaryStatic'; 
cable1.N =   20; %

%-------------------------------------------------------------------------%
%                           Boundary conditions                           %
%-------------------------------------------------------------------------%

bc1.vertexNumber = 1;
bc1.type = 'dirichlet'; % 'dirichlet, neumann or mixed.
bc1.mode = 'fixed';

% 
bc2.vertexNumber = 2;
bc2.type = 'dirichlet';
bc2.mode = 'sine';

bc2.amplitude = [0.2;0;-0.2];   % if scalar it is applied to all dimensions.
bc2.frequency = 0.285714285714286;
bc2.phase = [90;0;0];  % if scalar it is applied to all dimensions. [deg]
bc2.centerValue = [32.554;0;3.3]; % if scalar it is applied to all dimensions.
bc2.rampTime = 3.5;        



