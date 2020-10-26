#  vspglm
All MATLAB Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver. The univariate case of this method was first proposed by Huang (2014) in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892



### Usage 

Current usage example

```matlab
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
```

The resulting parameters are 

```matlab
>> betas{1}

ans =

    3.5102
   -0.0387

>> betas{2}

ans =

    6.7550
   -0.0019
```

