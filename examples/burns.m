% Song (2007) Burns Injury data set example

%% Import Data 
% Song Burns Data set
data = readtable('burns.txt');

% Rename the data
data.Properties.VariableNames = {'age', 'gender',...
                                'burn_severity', 'death'};
% Transform the variables 
data.death = abs(data.death - 2);

data.burn_severity  = log(data.burn_severity + 1);

%%  Run the model
links = {'logit', 'id'};
burns_model= fit_vspglm("(death, burn_severity) ~ age",data,links);

%% Print the results
burns_model.coefficients
burns_model.varbeta











