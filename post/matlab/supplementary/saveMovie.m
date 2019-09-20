function saveMovie(t,plotVals,movInfo)

% Example of movInfo:
% * * * Compulsory * * * %
% movInfo.name = 'position';
% movInfo.axis = [minX minY maxX maxY];
% movInfo.mesh = mesh;

% * * * Optional * * * %
% movInfo.title= 'Position'; ( default ' ' )
% movInfo.x = 'x [m]'; ( default ' ' )
% movInfo.y = 'z [m]'; ( default ' ' )
% movInfo.dims = [1 3]; ( default [1 2] )
% movInfo.meshDensity = [meshDensityMin meshDensityMax]; (not coloring)
% movInfo.fr = 5; % framerate (Hz) (default is from movieWriter) 

% 
hf = figure;
ha = gca; % plot all objects in the same axis

if isfield(movInfo,'dims')
    dims = movInfo.dims;
else
    dims = [1 2];
end



if length(t)>1
    movieTime= 1;
    if (ismac || ispc )
        aviObj = VideoWriter(movInfo.name,'MPEG-4');
    else
        aviObj = VideoWriter(movInfo.name);
    end
    % Include possible control of frame rate through movInfo.fr
    if isfield(movInfo,'fr')
        aviObj.FrameRate=movInfo.fr; % need to be done before open aviObj.
    % Include possible control of duration through movInfo.dur
    elseif isfield(movInfo,'dur')
        aviObj.FrameRate=length(t)/movInfo.dur; % need to be done before open aviObj.                
    end
    open(aviObj);
else
    movieTime = 0;
end

% In case of no change, scale axis window with 5 percent.
if movInfo.axis(1)==movInfo.axis(3)
    scaleX = [1/1.05 1.05];
else
    scaleX = [1 1];
end
if movInfo.axis(2)==movInfo.axis(4)
    scaleY = [1/1.05 1.05];
else
    scaleY = [1 1];
end

set(ha,'XLim',movInfo.axis([1 3]).*scaleX,'YLim',...
    movInfo.axis([2 4]).*scaleY);

set(ha,'FontSize',17);
set(ha,'NextPlot','replacechildren');
grid on; 

if isfield(movInfo,'x')
    xlabel(movInfo.x);
end

if isfield(movInfo,'y')
    ylabel(movInfo.y);
end

if isfield(movInfo,'title')
    mkTitle = 1;
else
    mkTitle = 0;
end



if isfield(movInfo,'meshDensity') && ~isfield(movInfo,'noColors')
    mkColors= 1;
else
    mkColors = 0;
end

% Check format size of time:
if movieTime
    t0=num2str(t(2)); % look for 2nd value in time history
else
    t0=num2str(t(1));
end
% use as format
ind=find(t0=='.');
nDecimals = length(t0)-ind;
timeFrmt = ['%.' num2str(nDecimals) 'f'];


% Do for adaptive meshes
if iscell(movInfo.mesh)
    mesh=movInfo.mesh;
    
    for ii=1:length(t)
        set(ha,'NextPlot','replacechildren');        
        Q=mesh{ii}(:,2);
        if mkColors
            % Set the colorscale of the movie
            cVals = (Q./mesh{ii}(:,3)-movInfo.meshDensity(1) ) / (movInfo.meshDensity(2) - movInfo.meshDensity(1));
            cVals = cVals(:);
        
            % Avoid problem with non-changing yet, adaptive meshes:
            if isnan(cVals(1))
                cVals = ones(size(cVals));
            end        
            colors = [cVals, 0*cVals, 1-cVals];
        else
            colors = zeros(length(Q),3);
        end
        
        % Plot DG values
        ha=plotDG(Q,plotVals{ii}(:,dims),[],ha,{'-x','MarkerSize',3,'Linewidth',1.2},colors);
        
        if mkTitle
            title([movInfo.title ' at t = ' num2str(t(ii),timeFrmt) ])
        end
        if movieTime
            F=getframe(hf);        
            writeVideo(aviObj,F);        
        end
    end
    
else
    % Plot if static mesh
    Q=movInfo.mesh(:,2);
    for ii=1:length(t)           
        set(ha,'NextPlot','replacechildren');        
        
        ha=plotDG(Q,plotVals{ii}(:,dims),[],ha,{'k-x','MarkerSize',3,'Linewidth',1.2});
        
        if mkTitle
            title([movInfo.title ' at t = ' num2str(t(ii),timeFrmt) ])
        end
        
        if movieTime
            F=getframe(hf);
            writeVideo(aviObj,F);
        end
    end
end

if ~movieTime
   print(hf,'-depsc',movInfo.name);
   print(hf,'-dpdf',movInfo.name); 
else
    close(aviObj);
end
