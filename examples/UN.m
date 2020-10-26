%% Fitted Model Using UN data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))

%% Import data
un = readtable('UN2.txt');

% Create Design matrices
N = size(un, 1);
X = {[ones(N, 1), un.Purban],[ones(N, 1), un.Purban]};
Y = {un.logPPgdp, un.logFertility};
links = {'id', 'id'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);

