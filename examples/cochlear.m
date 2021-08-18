clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%% 12-D Cochlear Example

% Import the data

data = readtable("cochlear.xlsx", "Sheet", 13);
formulas = strings(1, 12);
links = cell(1, 12);
for i = 1:12
    xMatrix = readtable("cochlear.xlsx", "Sheet", i);
    xMatrix = xMatrix(:, 2:end);
    sums = sum(table2array(xMatrix), 1) > 0;
    xMatrix = xMatrix(:, sums);
    xName = "x" + num2str(i);
    xMatrix.Properties.VariableNames = strcat(xName, xMatrix.Properties.VariableNames);
    formulas(i) = sprintf("%s ~ (%s)", xName,strjoin(string(xMatrix.Properties.VariableNames), ',')); 
    data = [data, xMatrix];
    links{i} = 'id';
end



%% Run VSPGLM- Unconstrained
cochlear_model_un = fit_vspglm(formulas, data, links);
save('cochlear_model_unconstrained', 'cochlear_model_un')
cochlear_model_un.coefficients

%% Run VSPGLM- Constrained
% Import the data

data = readtable("cochlear.xlsx", "Sheet", 13);
responses = strings(1, 12);
variables = strings(5, 12);
links = cell(1, 12);
for i = 1:12
    xMatrix = readtable("cochlear.xlsx", "Sheet", i);
    xMatrix = xMatrix(:, 2:end);    
    xName = "x" + num2str(i);
    responses(i) = xName;
    xMatrix.Properties.VariableNames = strcat(xName, xMatrix.Properties.VariableNames);
    variables(:, i) = xMatrix.Properties.VariableNames;
    data = [data, xMatrix];
    links{i} = 'id';
end
%%
% Create the formula
covariates = strings(1, 5);
for i = 1:5
    covariates(i) = "(" + strjoin(variables(i, :), '&') + ")";
end
covariates = "(" + strjoin(covariates, ',') + ")";
formula = sprintf("(%s) ~ %s", strjoin(responses, ','), covariates);
%% 
cochlear_model_sym = fit_vspglm(formula, data, links);
save('cochlear_model_equal', 'cochlear_model_sym')
cochlear_model_sym.coefficients

%% 6 and 6 measurements

%%
% Create the formula
covariates = strings(2, 5);
for i = 1:5
    covariates(1, i) = "(" + strjoin(variables(i, 1:6), '&') + ")";
    covariates(2, i) = "(" + strjoin(variables(i, 7:end), '&') + ")";
end
covariates1 = "(" + strjoin(covariates(1, :), ',') + ")";
covariates2 = "(" + strjoin(covariates(2, :), ',') + ")";
formula1 = sprintf("(%s) ~ %s", strjoin(responses(1:6), ','), covariates1);
formula2 = sprintf("(%s) ~ %s", strjoin(responses(7:12), ','), covariates2);
%%
%% 
cochlear_model66 = fit_vspglm([formula1, formula2], data, links);
save('cochlear_model_6_and_6', 'cochlear_model66')
cochlear_model66.coefficients















