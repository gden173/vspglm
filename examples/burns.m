% Song (2007) Burns Injury data set example
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
data.death = abs(data.death - 2);

data.burn_severity  = log(data.burn_severity + 1);


data = data(1:500, :);


%%  Run the model
links = {'logit', 'id'};

burns_model= fit_vspglm(["death ~ age", "burn_severity ~ age"],data,links);

save('burns', 'burns_model')
% %% Print the results
burns_model.coefficients












