function [maxD,minD] = meshDensity(mesh)

maxD = -1e32;
minD = 1e32;

if iscell(mesh)
    % mesh{tt} = [p q h] 
    
    % for each time: 
    for tt = 1:size(mesh,1)
        
        maxD = max( [max(mesh{tt}(:,2)./mesh{tt}(:,3))  maxD]);
        minD = min( [min(mesh{tt}(:,2)./mesh{tt}(:,3))  minD]);
        
    end
    
end

end % of function

% * * * * * END OF FILE * * * * * %
