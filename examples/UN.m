%% Fitted Model Using UN data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))

%% Import data
un = readtable('UN2.txt');
un.logPPgdp = rescale(un.logPPgdp, -1, 1);
un.logPPgdp = rescale(un.logFertility, -1, 1);
%%
% Create Design matrices

links = {'id', 'id'};
un_model = fit_vspglm("(logPPgdp, logFertility) ~ Purban", un, links);
un_model.coefficients

