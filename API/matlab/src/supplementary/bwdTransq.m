function d = bwdTransq(d)
addpath('/Users/Johannes/Desktop/work/moody/moodyOld/moody++/matlab/src');
% data structure d, 
% updated with field q = bwdTrans(qM)

% Assign all sizes of q.
d.q = d.p;


if iscell(d.s)
        % Do for adaptive meshes:
    % to be continued...
    disp('FATAL ERROR: NOT MADE FOR ADAPTIVE MESHES YET! bwdTransq.m')
else
% loop through time.    
    p=d.elements(1,1);
    q=d.elements(1,2);
    Q=0;
    [Phis]=elementalSetup(p,q,'Legendre');
    for tt= 1:length(d.t)
        for nn=1:d.N(1)
            d.q{tt}(Q+(1:q),:) = Phis'*d.m{tt}((nn-1)*(p+1)+(1:p+1),d.dim+(1:d.dim));
            Q = Q+q;
        end
    end
rmpath('/Users/Johannes/Desktop/work/moody/moodyOld/moody++/matlab/src')
end