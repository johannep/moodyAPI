
%% Plot results:
close all;
N=cell(1,1);
d = readCase('lindahl125');

% load experimental data
ed=load('expData.dat');

% constant phaseshifts between exp. and numerical sim.
phaseShift125 = -0.649; % s
phaseShift35 = -2.945; % s


%% Plot lindahl 1.25 s:
% Extract end point tension force
T = zeros(size(d.t));
    
for jj=1:length(T)
    T(jj) = d.T{jj}(end);
end

figure
plot(ed(:,1),ed(:,2),'r','Linewidth',1.2);
hold on;
plot(d.t+phaseShift125,T,'k','Linewidth',1.2)

legend('exp','moody','Location','northOutside','Orientation','Horizontal');
axis([0 15 0 75])
grid on
ax=gca;
ax.FontSize=17;

xlabel('Time (s)')
ylabel('Force (N)')

%print(gcf,'-dpng','lindahl125.png');
print('lindahl125','-depsc');

d125=d;

%% Plot lindahl 3.5 s:
d = readCase('lindahl35');

% Extract end point tension force
T = zeros(size(d.t));

for jj=1:length(T)
    T(jj) = d.T{jj}(end);
end

figure;
plot(ed(:,1),ed(:,3),'r','Linewidth',1.2);
hold on;
plot(d.t+phaseShift35,T,'k','Linewidth',1.2)

legend('exp','moody','Location','northOutside','Orientation','Horizontal');

axis([0 15 0 55])
grid on
set(gca,'fontsi',17);
xlabel('Time (s)','fontsi',17)
ylabel('Force (N)','fontsi',17)
print('lindahl35','-depsc');

d35=d;
clear d;
