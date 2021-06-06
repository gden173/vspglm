%% Fitted Model Using UN data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))

%% Import data
un = readtable('UN2.txt');

%%
% Create Design matrices
links = {'id', 'id'};
un_model = fit_vspglm(["logPPgdp ~ Purban", "logFertility ~ Purban"], un, links);
save('un_model', 'un_model')
un_model.coefficients

%%