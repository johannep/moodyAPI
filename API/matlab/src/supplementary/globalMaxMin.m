function [maxVal,minVal] = globalMaxMin(vals)
% Loop through a 1D cell array and extract max and min values for each column of input.
% no. of columns must be consistent throughout all cells of vals
N=size(vals{1},2);
minVal = 1e32*ones(1,N);
maxVal = -minVal; 

if iscell(vals)
    
    % for each time: 
    for tt = 1:size(vals,1)
        
        maxVal = max( [max(vals{tt});  maxVal]);
        minVal = min( [min(vals{tt});  minVal]);
        
    end
    
else
    maxVal = max(vals);
    minVal = min(vals); 

end % of if


%% Check so that no 0-valued axis are required. 
printTol = 1e-10;
checks = abs(maxVal-minVal)< printTol;

maxVal(checks) = maxVal(checks)+printTol;
minVal(checks) = minVal(checks)-printTol;



% * * * * * END OF FILE * * * * * %
