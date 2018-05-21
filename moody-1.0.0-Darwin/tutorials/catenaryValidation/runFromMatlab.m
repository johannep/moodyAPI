% Run T=1.25 s simulation 
moody('lindahl125.m');

% Run period time T=3.5 s simulation
moody('lindahl35.m');

% plot
plotResults;

%% position movie: 
% moodyMovie('p',d125,d125.t(1:5:end));

