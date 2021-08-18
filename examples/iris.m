
%% Load the Iris data set
x = load('fisheriris.mat');
%%
% Format the data
X = array2table(x.meas, ...
    'VariableNames',...
    {'Sepal.Length', 'Sepal.Width', 'Petal.Length', 'Petal.Width'});
sp = ones(50, 1);
species = array2table(blkdiag(zeros(size(sp)), sp, sp),...
    'VariableNames',...
    {'setosa', 'versicolor', 'virginica'});

data = [X species];
%%
links = {'log'};
iris_model = fit_vspglm(["(Sepal.Length) ~ (Sepal.Width,Petal.Length,Petal.Width, versicolor, virginica)"], data, links);
iris_model.coefficients
  





