%% Testing vspglm on Butterfly Data Set
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%%  
% Import the data
x = readtable("butterfly_X.xlsx");
y = readtable("butterfly_Y.xlsx");

% Get the largest
Y = table2array(y);
sums = sum(Y, 1);
[~, ids] = sort(sums, 'descend');
N = 3;
y = y(:,ids(1:N));
%%
% Paste the data together in a table
tbl = [x, y];
%% Extract the names to use
names_X = convertStringsToChars(sprintf("%s,", string(string(x.Properties.VariableNames))));
names_X = names_X(1:end-1);
names_Y = convertStringsToChars(sprintf("%s,", string(string(y.Properties.VariableNames))));
names_Y = names_Y(1:end-1);
formula = sprintf("(%s) ~ (%s)", names_Y, names_X);
%% Run VSPGLM
links = cell(1, N);
links(:) = {"log"};
%% Converges for 5 in under 10 seconds.
% Converges for 6, but have to fix the numeric stability of vcov
% Check if converges for 8
butterfly_model = fit_vspglm(formula, tbl, links);

%%  Print out the model
butterfly_model.coefficients

%%
% Test plot 
X = [ones(66, 1), table2array(x)];
for i = 1:N
    subplot(3, 1, i)
    e = exp(X*(butterfly_model(i).coefficients.estimates));
    [out, idx] = sort(table2array(y(:, i)));
    plot(1:66,e(idx), 'ro');
    hold on 
    plot(1:66, out, 'go')
    hold off
end
