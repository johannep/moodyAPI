function [maxVal,minVal] = globalMaxMin(vals)
% Loop through a 1D cell array and extract max and min values for each column of input.
% no. of columns must be consistent throughout all cells of vals
maxVal = -1e32*ones(1,size(vals{1},2));
minVal = 1e32*ones(1,size(vals{1},2));

if iscell(vals)
    
    % for each time: 
    for tt = 1:size(vals,1)
        
        maxVal = max( [max(vals{tt});  maxVal]);
        minVal = min( [min(vals{tt});  minVal]);
        
    end
    
else
    maxVal = max(vals);
    minVal = min(vals); 

end % of function

% * * * * * END OF FILE * * * * * %
