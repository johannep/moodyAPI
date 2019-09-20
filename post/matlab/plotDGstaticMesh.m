function [hp] = plotDGstaticMesh(X,Y,N,varargin)
% PLOTDGSTATICMESH plots X vs Y as N discontinuous elements 
% varargin is a list of plot commands forwarded to native MATLAB plot.m
% INPUT :   X numeric 1D array, 
%           Y numeric 1D array 
%           N number of elements. 
%           varargin, plot input commands.
% OUTPUT : hp is a handle to the plot line style. In case of legend, use
% this with 'DisplayName','name' feature of plot as a varargin to set data
% name only once in legend. 
% Make into col. vectors. 
X = X(:);
Y=Y(:);

Q = length(X);
q = Q/N;

for nn=1:N
    inds = (nn-1)*q+(1:q);
    hp = plot(X(inds),Y(inds),varargin{:});
    hold on;
end



end