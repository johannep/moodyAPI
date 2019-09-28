function [h,x] = plotDG(Q,plotVals,dims,h,frmts,colorVect)
%% PLOTDG plots discontinuous elements.
% Input: 
%   Q:          (N by 1) vector of N elements, with their respective sizes 
%               in plotVals. 
%
%   plotVals:   (cumsum(Q) by dim) x,y values to plot. Dim is 2 or 3.
%
%   dims:       (1 by 2) if dim is 3, then specify which cols to plot
%               default: [1 2]
%
%   h:          axis handle
%
%   frmts:      cell array of plot format commands. 
%               default: {'b','Linewidth',1.2}
%
%   colorVect:  cell array of colors to use for each element. Can be used
%               to colorcode each element based on a given property. 
%
% Output:
%   h:          axis handle
%
%   x:          plot handle
if nargin<3 || isempty(dims)
    dims = [1 2];
    dim = 2;    
else
    dim = 3;   
end

if nargin < 4
    figure;
    h = gca;
    
end

if nargin < 5 || isempty(frmts)
    frmts= {'b','Linewidth',1.2};
end

if nargin < 6 
    colFlag = 0;
else
    colFlag = 1;
end
% remove first time value if present
if length(plotVals) == dim*sum(Q) +1 
    plotVals = plotVals(2:end); 
end

nQ =  sum(Q);

qx = nQ*(dims(1)-1);
qz = nQ*(dims(2)-1);
if colFlag
    x = plot(h,plotVals(qx+ (1:Q(1) )),plotVals(qz+(1:Q(1)) ),frmts{:},'Color',colorVect(1,:));
else        
    x = plot(h,plotVals(qx+ (1:Q(1))),plotVals(qz+(1:Q(1))),frmts{:});
end
% hold(h,'on');
hold on

qx = nQ*(dims(1)-1)+Q(1);
qz = nQ*(dims(2)-1)+Q(1);
if colFlag % do if each element has a color attached through colorVect
    for ii=2:length(Q)
    
        plot(h,plotVals(qx+ (1:Q(ii) )),plotVals( qz+(1:Q(ii)) ),frmts{:},'Color',colorVect(ii,:));
        qx = qx + Q(ii);
        qz = qz + Q(ii);
    
    end
else
    
    for ii=2:length(Q)
    
        plot(h,plotVals(qx+ (1:Q(ii) )),plotVals( qz+(1:Q(ii)) ),frmts{:});
        qx = qx + Q(ii);
        qz = qz + Q(ii);
    
    end
end
