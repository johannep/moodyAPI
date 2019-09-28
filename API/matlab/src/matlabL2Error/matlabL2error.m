function L2err = matlabL2error(num,ana,b,d)
%% Compute the L2 error from 
% num - numerical solution,
% ana - analytical solution
% b - base to use for integration
% d - cable data structure

% transpose to column vectors for each quantity.
if size(num,1)==1
    num=num';
end
if size(ana,1)==1
    ana=ana';
end

% Switch to allow for adaptive mesh style.
if iscell(d.N)
    N=d.N{ind};
    el = d.elements{ind};
else
    N=d.N;
    el=d.elements;
end

% Compute error difference squared
delta=(num-ana).^2;
anaSqr=ana.^2;

% Integrate over all elements
L2err = zeros(size(num,2));
L2ana = L2err;
sTotal = 0;
for nn=1:N(1)
    jac=0.5*el(nn,3);
    sTotal = sTotal + el(nn,3);
    inds = (nn-1)*b.Q+(1:b.Q);
    L2ana = L2ana + jac*b.wis'*anaSqr( inds,: );    
    L2err = L2err + jac*b.wis'*delta( inds,: );    
end
    
L2err = sqrt(L2err/L2ana); % /sTotal; 

