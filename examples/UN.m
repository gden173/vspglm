%% Fitted Model Using UN data
%% Import data
un = readtable('UN2.txt');

%%
% Create Design matrices
links = {'id', 'id'};
un_model = fit_vspglm(["logPPgdp ~ Purban", "logFertility ~ Purban"], un, links);
un_model.coefficients

%%