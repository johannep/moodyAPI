function [ t,N,els] = readMesh( objName ,folderName)
%READMESH Reads mesh parameters from output file 
%   Detailed explanation goes here
if nargin<1
    objName = 'cable1';
end
if nargin<2
    folderName = '.';
end

fName = strcat(folderName,'/',objName,'_mesh.dat');
fid=fopen(fName,'r');

% Load time vector
t = load(strcat(folderName,'/time.dat'));

N = zeros(length(t),3);
els = cell(size(t));

setupFile = strcat(folderName,'/','setup.txt');
nQuads = findKey(setupFile,'numLib.qPointsAdded',2); % default is 2.

nLines = length(t); % total number of timesteps
nn=0; % cntr of loops.
val = extractNextLine(fid);

while (val(1) ~= -1 && nn<nLines)
    
    nn=nn+1;    
    val=val(2:end); % skip time value
    N(nn,:) = [val(1:2) val(2)+val(1)*(nQuads-1)]; % N , nModes , nNodes
    els{nn} = [val(4:3:end)'    val(4:3:end)'+nQuads    val(3)*0.5.^val(5:3:end)']; % [P Q h]   
    
    % read next line
    val = extractNextLine(fid);
end

fclose(fid);

% If static mesh, return only first value of N,P,h
if ( nn == 1 )
   
    N = N(1,:);
    els = els{1};
    
end

% Note: when nn==1, t is still returned as the complete time vector.


%% --- END OF FILE --- %%
