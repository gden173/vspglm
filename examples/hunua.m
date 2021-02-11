%% Fitted Model Using Rossner  data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%% Data 
hunu = readtable('hunua.txt');

%%
links = {'logit','logit','logit'};
hunu_model = fit_vspglm("(cyadea,beitaw,kniexc) ~ altitude", hunu, links);
hunu_model.coefficients
hunu_model.covariance


