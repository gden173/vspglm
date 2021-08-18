%% Fitted Model Using Rossner  data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%%
% Two way drug trial data
responseOne = [ones(1, 22  + 18), zeros(1,4), ones(1, 8), zeros(1, 15)].';
responseTwo = [ones(1, 22  +18), ones(1,4), zeros(1, 8), zeros(1, 15)].';
treatment = [ones(1, 22), zeros(1, 22),ones(1, 6),...
    zeros(1, 2), ones(1, 6), zeros(1, 9) ].';
treatmentTwo = [zeros(1, 22), ones(1, 22),zeros(1, 6),...
    ones(1, 2), zeros(1, 6), ones(1, 9) ].';

Y = {table(responseOne), table(responseTwo)};
X = {table(treatment), table(treatmentTwo)};
tbl = [table(responseOne), table(responseTwo), table(treatment), table(treatmentTwo)];
%%
links = {'logit','logit'};
formula = ["responseOne ~ treatment ", "responseTwo ~ treatmentTwo"];
model = fit_vspglm(formula, tbl,  links);
save('twoway', 'model')
model.coefficients
%%
% links = {'logit','logit'};
% tbl = [tbl, array2table([zeros(67, 1), ones(67, 1), zeros(67, 1), treatmentTwo], 'VariableNames', {'period', 'periodTwo', 'interaction', 'int2'})];
% formula = ["(responseOne, responseTwo) ~ ((treatment&treatmentTwo), (period & periodTwo), (interaction & int2))"];
% model = fit_vspglm(formula, tbl,  links);
% %save('twoway', 'model')
% model.coefficients



