function [value,cellList,found] = getKeyValue(cellList,key,defaultVal)
% getKeyValue looks to find key (string) in cellList.
% it returns value as the next item in cellList.
% key and value are removed from the output cellList. 
% found is a boolean indicating if key was found (true) or not (false)
% if not found, value is returned as -1 if defaultVal is not specified.
if nargin<3
    defaultVal = -1;
end

ind = strcmp(cellList,key); % index as boolean. 
found = any(ind);

if found    
    N = 1:length(cellList); % vector of index numbers. 
    nn=N(ind); % index no. 
    value = cellList{nn+1};
    cellList(nn:nn+1) = []; % remove keyname and value.     
else
    value=defaultVal;
end
