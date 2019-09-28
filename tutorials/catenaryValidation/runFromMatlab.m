% Run T=1.25 s simulation 
% get this location.
p=fileparts(mfilename('fullpath'));

run([p '/../../API/matlab/addMoodyPath']);

moody('lindahl125.m');

% Run period time T=3.5 s simulation
moody('lindahl35.m');

% plot
plotResults;

%% position movie: 
% moodyMovie('p',d125,d125.t(1:5:end));

