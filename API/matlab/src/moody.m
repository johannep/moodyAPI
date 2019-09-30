function moody( inputName, varargin )
%%MOODY Matlab interface to run moody stand alone, instead of in a terminal. 
%
% Input: 
%   inputName : name of the input file. (including any '.m', '.txt' if applicable)
%   varargin :  a comma-separated list of (key ,value) input options matching the terminal format. 
% For further information on usage, please see the moody manual. 
% Collect the file path of moody: 
run(fullfile(fileparts(mfilename('fullpath')),'..','addMoodyPath'));

% Put separator space between all inputs in varargin
strVarargin=string(varargin);       % make into string array.
moreInput = strjoin(strVarargin);   % join all into element 1. (adds whitespace in between)
if ( ~ispc )
    % Source the environment variables: 
    srcCall = ['source ' fullfile(moodyPath,'etc','bashrcMoody') '; '];
    system([srcCall 'moody.x -f ' inputName ' ' moreInput{1}]); % compute moody simulation.
else
    % NB: There is no bash-script with environment variables provided with
    % Moody for Windows. A brute force solution, if it does not work is to
    % copy all dll-files and executables to the same directory. 
    system([fullfile(moodyPath,'bin','moodywindows.exe') ' -f ' inputName ' ' moreInput{1}]); % compute moody simulation.
end

