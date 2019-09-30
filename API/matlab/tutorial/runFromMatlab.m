%% Tutorial script to use API-mode via matlab 
% Same result as in tutorial mooringSystem_modelScale is to be expected. 
close all;
% get file path here and execute addPath script
run(fullfile(fileparts(mfilename('fullpath')),'..','addMoodyPath'));


%% External circular motion
t=linspace(0,5,250)'; 
omega = 2*pi;
amp=0.025; % corr. to 5 cm wave 
rampT = 2;
P0 = [0 0 0];
rmp = 0.5*(sin(pi*(t/rampT-0.5))+1)*[1 1 1]; % ramp function
rmp(t>rampT,:) = 1; % stop at max 1.
A = amp*[cos(omega*t) 0*t sin(omega*t)].*rmp;
X = ones(length(t),1)*P0 + A; 
X = [X 0*X]; % no rotations used. 

%% Use if testing in command line 
% positions.txt may be used for input to test_API.x:
% test_API.x mooringSystem.m positions.txt

A=[t X];
save('positions.txt','-ascii','-tabs','A');

%% Plot input motion:
figure
plot(t,X,'Linewidth',1.2)
ax=gca;
ax.FontSize=17;
grid on;
xlabel('time (s)')
ylabel('position (m)');
legend('x','y','z','Location','NorthOutside','Orientation','Horizontal');

outF=zeros(size(X));

%% Startup moody and collect first force
moodyAPI('init','mooringSystem.m',X(1,:),t(1));
F = moodyAPI('solve',X(1,:),t(1),t(2));
outF(1,:)=F;

%% Loop through time
for tt=2:length(t)    
    F = moodyAPI('solve',X(tt,:),t(tt-1),t(tt));    
    outF(tt,:)=F;      
    disp([num2str(100*t(tt)/t(end),'%.1f') '%'])
end

%% Close moody session
moodyAPI('close');

%% Plot output force
figure
plot(t,outF,'Linewidth',1.2)
ax=gca;
ax.FontSize=17;
grid on;
xlabel('time (s)')
ylabel('Force (N) or (Nm)');
legend('$F_x$','$F_y$','$F_z$','$M_x$','$M_y$','$M_z$','Location','NorthOutside','Orientation','Horizontal');
