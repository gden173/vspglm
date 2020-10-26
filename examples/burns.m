%% Testing vspglm on Burns Data set from Song
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))

%% Import Data 

% Song Burns Data set
data = readtable('burns.txt');

% Rename the data
data.Properties.VariableNames = {'age', 'gender',...
                                'burn_severity', 'death'};
% Transform the variables 
data.death = data.death - 1;
data.burn_severity  = log(data.burn_severity  + 1);

% Subset of the data  (Can't be too large)
N = 300;
X = {[ones(N, 1), data.age(1:N)], [ones(N, 1), data.age(1:N)]};
Y = {data.death(1:N), data.burn_severity(1:N)};
links = {'logit', 'id'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);



