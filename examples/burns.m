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

data.burn_severity  = rescale(data.burn_severity, -1, 1);

%%
links = {'logit'};
burns_model= fit_vspglm("death ~ age",data,links);













