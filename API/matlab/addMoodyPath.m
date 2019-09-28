
% Add path to matlab moody sources
p = [fileparts(mfilename('fullpath')) '/src'];
addpath(genpath(p));

% Create moodyPath variable. 
moodyVersion = '2.0.1';

% Select architecture:
if (ismac)
	arch='Darwin';
	libEnding = '.dylib';
elseif (ispc)
	arch='Windows';
	libEnding='dll';
else
	arch='Linux';
	libEnding = '.so';
end

moodyPath=fullfile([p '/../../..']);

% Set environment to moody directory (for moody.m): 
% NB: This is not always neccessary if moody executables are added to usr/bin
setenv('PATH',[getenv('PATH') moodyPath '/bin']);


