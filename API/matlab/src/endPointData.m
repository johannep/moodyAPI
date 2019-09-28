function [ep,colHdrs] = endPointData(d,willPlot)
%% [ep,colHdrs] = endPointData(d,willPlot) get values of cable endpoints 
% for cable structure d.
% Input:
%   d        : cable data structure as returned by readCase.m
%   willPlot : switch to plot time history of tension T(:,end)
%
% Output:
%   ep       : nTimesteps by 1+2*(3*dim+2) matrix of endpointvalues.
%   colHdrs  : headers of each column in the output


if nargin <2
    willPlot = 1;
end

% Collect values:
ep= zeros(length(d.t),1+d.dim*2*2 + 2);
ep(:,1) = d.t;
for ii=1:length(d.t)
    
    ep(ii,2:end) = [d.p{ii}(1,:) d.p{ii}(end,:) ...
                    d.v{ii}(1,:) d.v{ii}(end,:) ...
                    d.T{ii}(1) d.T{ii}(end)];
    
end


colHdrs = {'t' ,'px(0)', 'py(0)', 'pz(0)', ...
    'px(L)',  'py(L)',  'pz(L)', ...
    'vx(0)', 'vy(0)', 'vz(0)', ...
    'vx(L)', 'vy(L)', 'vz(L)', ...
    'T(0)', 'T(L)' };
% Format hdrs acc to dim.
if d.dim < 3
    colHdrs(3:3:12) = [];
end
if d.dim <2
    colHdrs(3:2:9) = [];
end

if willPlot
    plot(ep(:,1),ep(:,end-1:end),'-')
end
