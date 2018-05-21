function runFromMatlab

%% File naming
inp='mooringSystem.m';
outp='moodyResults';

%% Run moody simulation
moody(inp,'-o',outp)

%% Load results
d=readCase(outp); 

% If only one cable, make into cell array
if ~iscell(d)
    d = {d};
end

%% Plot fairlead tension for each cable
figure;
for ii =1:length(d)
    ep=endPointData(d{ii},0); % 0 means don't plot.                    
    plot(ep(:,1),ep(:,end),'Linewidth',1.2,'Displayname',d{ii}.name);
    hold on;
end

% Format plot and save as png.
frmtPlot(outp)

%% Format plot
    function frmtPlot(fileName)
        ax=gca;
        ax.FontSize=17;
        grid on;
        xlabel('Time (s)');
        ylabel('Fairlead tension (N)');
        legend show        
        saveas(gcf,fileName,'png')
    end

end
