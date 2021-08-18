
%%  
% Import the data
x = readtable("butterfly_X.xlsx");
y = readtable("butterfly_Y.xlsx");

% Get the largest
Y = table2array(y);
sums = sum(Y, 1);

[~, ids] = sort(sums, 'descend');
N = 8;
y = y(:,ids(1:N));
%%
% Paste the data together in a table
tbl = [x, y];
%% Extract the names to use
names_X = convertStringsToChars(sprintf("%s,", string(string(x.Properties.VariableNames(1:5)))));
names_X = names_X(1:end-1);
names_Y = convertStringsToChars(sprintf("%s,", string(string(y.Properties.VariableNames))));
names_Y = names_Y(1:end-1);
formula = sprintf("(%s) ~ (%s)", names_Y, names_X);
%% Run VSPGLM
links = cell(1, N);
links(:) = {"log"};
butterfly_model = fit_vspglm(formula, tbl, links);

%%  Print out the model
butterfly_model.coefficients


