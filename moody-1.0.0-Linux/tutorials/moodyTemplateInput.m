% --- General --- %
dimensionNumber = 3;

% Optional %
gravity = 1; 	% (0) default is off, and gravity is 9.81 m/s²
waterLevel = 10; 	% (1e32)
waterDensity = 1000; % (1000)
airDensity = 1; % (0)

% --- Print --- %
print.dt = 1e-2; % Not formally required, but practically needed. time.dt is generally too small to store each time step. 

% Optional % 
print.mode = 1 % print nodal values of each parameter
print.format = 'bin' % Options: 'bin', 'ascii'. Binary is default and highly recommended. 

% --- Time --- %
time.start = 0
time.end = 10
time.step = 1e-4

% Optional %
time.scheme = 'RK3'; % Options are: RK3 , eulerFwd
time.cfl = 0.9;

% --- Vertices --- %

% note that unconnected  vertices are ignored by the code. 
% In the case below, only 1,2,3,4 and 7 are used. 
vertexLocations = {
                      1    [-3 0 -10];
                      2    [-267  0 -70];
                       3    [1.5 2.598 -10];
                       4    [133.5 231.23 -70];
                       5    [1.5 -2.598 -10];
                       6    [133.5 -231.23  -70];
                       7    [0 0 0];                            
			}


% --- Ground model (optional) --- %

ground.type = 'springDampGround'; % Bulk modulus of ground (Pa/m)
ground.stiffness = 1e6;   	% stiffness of the ground
ground.level = -70; 		% vertical coordinate of ground

% Optional %
ground.dampingCoeff = 1;  % fraction of critical damping of each cable
ground.frictionCoeff = 1; % tangential friction coefficient
ground.vc = 0.01;	  % cut off velocity for dynamic friction (after which friction force is maximum) 


% --- Cable types --- % 

% A minimum of two of diameter, rho and gamma0 must be specified. 
% In such cases, the missing parameter is computed based on a 
% solid, circular cross-section of the cable material. When all three are specified, 
% the actual values are used with no questions asked. 
% rho and gamma0 are used to compute the wet weight, as well as the cable area in the added mass formula. 
% diameter is used for drag forces and ground interaction.
%  

cableType1.diameter = 0.144;
cableType1.rho = 7800;
cableType1.gamma0 = 126;

% Optional input of hydrodynamic coefficients (default value)
cableType1.CDn = 1.6; % (0)
cableType1.CDt = 0.05; % (0) 
cableType1.CMn = 1.0; % (0) 
cableType1.CMt = 0; % (0)

% --- Cable types / Material models --- %

cableType1.materialModel.EA = 1e8; % [N] mean stiffness of the elongation-force curve.

% Optional %
cableType1.materialModel.xi = 0; % (0) [Ns] linear viscous model for internal damping. xi is linear coefficient.

% e = strain
% --- Bilinear cable: 
%	F = EA e + xi de/dt 	 

cableType1.materialModel.type = 'biLinear';
	
% --- Exponential cable: 
%	F = K (exp(a e)-1) + xi de/dt 	 

% cableType1.materialModel.type = 'exponential'
% cableType1.materialModel.K = 1e4; % base stiffness
% cableType1.materialModel.a = 2; % growth rate'

% --- Polynomial cable: 
%	F = sum_i  C_i e^i , for i \in [1,P] + xi de/dt  

% cableType1.materialModel.type = 'polynomial'
% cableType1.materialModel.C = [1e2 1e3 1e4 10] % 4th order polynomial (note: No zero coefficient, hence  


      
%----- Cable objects  -----%
cable1.typeNumber = 1;
cable1.startVertex = 2; %
cable1.endVertex = 1; %
cable1.length = 280; % 

cable1.N = 20; % 
cable1.P = 4;  

cable2 = cable1; % inherit all non-specified parameters from cable1
cable2.startVertex = 4; %
cable2.endVertex = 3; %



% --- Objects / Initial conditions --- % 

% --- Static catenary
cable1.IC.type = 'CatenaryStatic';

% --- Prestrain
% 	Cable is a straight line with strain eps0 in optionally different parts of the cable. 
% 	Overrides .length input.

% cable1.IC.type = 'Prestrain';
% cable1.IC.eps0 = [0.01 0.015]; % if scalar, applies to the whole cable.
% cable1.IC.parts = [0.5 0.5] % must match length of eps0, needed if eps0 is NOT scalar. Sum of parts must be 1.0


% --- Half-sine
%	 Sinusoidal variation of vertical cable position from a prestrained straight line. 

% cable1.IC.type = 'Halfsine'
% cable1.IC.eps0 = 0.01;
% cable1.IC.amplitude = '1'; % amplitude of displacement
% cable1.IC.periods = 0.5; % (0.5) default is a single arch over the cable length.


% --- Boundary conditions --- %
bc1.vertexNumber = 2;
bc1.type = 'dirichlet'; % 'dirichlet' or 'neumann', or ['dirichlet','neumann','dirichlet'] for each coordinate direction. 

bc2 = bc1; % inherit from bc1. 
bc2.vertexNumber = 4;


% --- fixed
bc1.mode = 'fixed';

% --- sine 
% bc1.mode = 'sine';
% bc1.amplitude = 1;
% bc1.phase = [0 0 90]
% bc1.frequency = [0.125 0 -0.125]
% bc1.rampTime = 2.5; % sine-ramp.


% --- externalRigidBody
% 	Externally controlled rigid body motion. Slaves specify which additional
% 	vertices that are connected to the body. 
bc3.vertexNumber = 7;
bc3.type = 'dirichlet'; % always dirichelt for external bcs.
bc3.mode = 'externalRigidBody';
bc3.inputDoFs = 6; % API input is [x y z roll pitch yaw] in m and rad. Could also be 7 for septernion input.
bc3.slaves = 1; % list of slave vertex numbers (excluding the cog at bc3.vertexNumber ) 
bc3.slavePositions = [-3 0 -10]; % relative to vertexNumber position 

% Externally controlled point motion (input dofs= 3 required)
bc4.mode = 'externalPoint';
bc4.type = 'dirichlet'; % always dirichlet for external bcs. 
bc4.vertexNumber = 3; 


% --- API conectivitity --- %
% the order of the API input vector in moodySolve and moodyInit. 
API.bcNames = {'bc3','bc4'}; 

% Optional parameters (default value):
API.syncOutput = 0; % (1)
API.staggerTimeFraction = 0.5; % (0) 0.5 highly recommended in coupled simulations.
API.reboot = 'no'; % ('yes')
API.output = 'moodyOutput'; % (inputFilename without ".extension")

% ===== END OF FILE ===== %
