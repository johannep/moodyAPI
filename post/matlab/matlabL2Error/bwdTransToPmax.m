function [X, s, b, d] = bwdTransToPmax(d,ind)
%% bwdTransToPmax computes the physical solution from the modal values of 
% cable structure d at time index ind (default is end of simulation). 
% It uses poly order 15 with 100 quad-points to project the physical values.
% the base structure is returned as base out argument..

% Read case if needed.
if ischar(d)
    d=readCase(d);
end

% Use end of simulation by default.
if nargin < 2
    ind=length(d.t);
end

% Load basis values
b = load('P15Q100.mat');

%% d is cable data.
modes = d.m{ind}; % modes = [rM qM vM qDotM], i.e. 4*d.dim

% Switch to allow for adaptive mesh style.
if iscell(d.N)
    N=d.N{ind};
    el = d.elements{ind};
else
    N=d.N;
    el=d.elements;
end

% Allocate output
X=zeros(N(1)*b.Q,size(modes,2));
s=zeros(N(1)*b.Q,1);
locModes = zeros(b.Pmax+1,size(modes,2));
localModeNo = 0;
s0=0;

for nn=1:N(1)
    % collect poly order
    p = el(nn,1);
    % fill modal pmax from below
    locModes(1:(p+1),:)=modes(localModeNo+(1:p+1),:);
    % compute at all 100 quadpoints.
    X((nn-1)*b.Q+(1:b.Q),:) = b.Phis'*locModes;
    % Reset local modes and update local mode no. 
    locModes = 0*locModes; 
    localModeNo=localModeNo+p+1;
    
    s((nn-1)*b.Q+(1:b.Q)) = (1+b.xis)*0.5*el(nn,3)+s0;
    s0 = s0+el(nn,3);
end


