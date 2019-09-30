function runFromMatlab

% collect present dir. 
run(fullfile(fileparts(mfilename('fullpath')),'..','..','API','matlab','addMoodyPath'));

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
stys={'-','--','-'};
cols={'k','r','b'};
for ii =1:length(d)
    ep=endPointData(d{ii},0); % 0 means don't plot.                    
    plot(ep(:,1),ep(:,end),[stys{ii} cols{ii}],'Linewidth',2.0,'Displayname',d{ii}.name);
    hold on;
end
%% Format plot and save as eps
xlabel('Time (s)');
ylabel('Fairlead tension (N)');
frmtPlot([outp 'Tension']);

%% Plot 3D position envelope for each cable
figure;
stys={'-','-','-'};
cols={'k','r','b'};
deltaN = 10; % plot every 10th timestep
for ii =1:length(d)
    di=d{ii};
    nt = length(di.t); % legnth of time trace
    for tt=1:deltaN:nt        
        dip =di.p{tt}; % current position values. 
        ph(ii) = plot3(dip(:,1),dip(:,2),dip(:,3),[stys{ii} cols{ii}],'Linewidth',1.0,'Displayname',d{ii}.name);
        hold on;    
    end    
end

%% Format plot and save as eps
axis tight
plax=gca;
xlabel('$x$ (m)');
ylabel('$y$ (m)');
zlabel('$z$ (m)');
frmtPlot([outp 'Position'],ph);


%% Format plot
    function frmtPlot(fileName,ph)
        ax=gca;
        ax.FontSize=25;
        grid on;
        
        f=gcf;
        % make figure more rectangular.
        f.Position(3:4) = f.Position(3:4).*[1.2 1.1]*2;
        if nargin == 1
            legend('Location','NorthOutside','Orientation','Horizontal')
        else
            legend(ph,'Location','North','Orientation','Horizontal');
        end
        print(f,fileName,'-depsc')
    end

end
