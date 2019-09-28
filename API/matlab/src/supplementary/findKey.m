function value = findKey(fname,key,defaultVal)
% findKey opens file fname and looks for key.
% if not found it is returned as -1.
if nargin<3
    defaultVal = -1;
end

% Look for key in f. 
f = fopen(fname);
value=defaultVal;
while ~feof(f)
    s= fgetl(f);     
    N = min(length(s),length(key));
    % Check for key    
    if ischar(s) && ~isempty(s) && strcmp(s(1:N),key)        
       eval(s); % eval this line
       value=eval(key); % set as dim
       break; % and return 
    end     
end

% close setup file
fclose(f);