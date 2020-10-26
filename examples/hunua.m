%% Fitted Model Using Rossner  data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%% Data 
hunua = readtable('hunua.txt');
x = [ones(size(hunua, 1), 1), hunua.altitude];
X = {x,x,x};
Y = {hunua.cyadea, hunua.beitaw,hunua.kniexc};
links = {'logit', 'logit', 'logit'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);