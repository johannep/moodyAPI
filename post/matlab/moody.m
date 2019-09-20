function moody( inputName, varargin )
%%MOODY Matlab interface to run moody stand alone, instead of in a terminal. 
%
% Input: 
%   inputName : name of the input file. (including any '.m', '.txt' if applicable)
%   varargin :  a comma-separated list of (key ,value) input options matching the terminal format. 
% For further information on usage, please see the moody manual. 

srcCall = '';
% NOTE: For this to work moody needs to be installed on your systenm. 
% Below is a workaround if you need to source env. variables. 

moodyHome='~/work/proj/moody/repo/etc/bashLinux';
srcCall = ['source ' moodyHome '; '];


% Put separator space between all inputs in varargin
strVarargin=string(varargin);       % make into string array.
moreInput = strjoin(strVarargin);   % join all into element 1. (adds whitespace in between)
system([srcCall 'moody.x -f ' inputName ' ' moreInput{1}]); % compute moody simulation.

end

