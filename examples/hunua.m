%% Fitted Model Using Rossner  data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%% Data 
hunu = readtable('hunua.txt');
x = [ones(size(hunu, 1), 1), hunu.altitude];
X = {x,x,x};
Y = {hunu.cyadea, hunu.beitaw,hunu.kniexc};
links = {'log', 'log', 'log'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);