function [fns,dofs] = chooseFields(d)
%%CHOOSEFIELDS(d) checks structure d fieldnames for possible output values. 
% Returns a valid selection of parameters from d. 
% Input: 
%   d: cable data structure
% Output: 
%  fns  : cell array of fieldNames of nodal variables available in d
%  dofs : vector of degrees of freedom for each field 
%   (scalar fields ::> dofs=1, vectors dofs = dim) 

% All available fields: 
fns = {'p','v','tan','Tvec','T','eps','epsR'};
dofs  = [d.dim d.dim d.dim d.dim 1 1 1];

killInds = false(length(fns),1);
for ff=1:length(fns)
   if ~isfield(d,fns{ff})
       killInds(ff)=true; %  = [killInds ff];
   end
end

fns(killInds) = [];
dofs(killInds) = [];


end

