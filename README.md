#  vspglm
All MATLAB Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver. The univariate case of this method was first proposed by Huang (2014) in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892



### Usage 

Current usage examples

#### Burns

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

#### UN

```matlab
un = readtable('UN2.txt');

% Create Design matrices
N = size(un, 1);
X = {[ones(N, 1), un.Purban],[ones(N, 1), un.Purban]};
Y = {un.logPPgdp, un.logFertility};
links = {'id', 'id'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
```

```matlab
>> betas{1}

ans =

    6.9924
    0.0730

>> betas{2}

ans =

    1.7219
   -0.0125
```

#### Rossner

```matlab
yL = [2,1,0.5,2.5,3,2,1,2,3,2,3,2,3,0.5,3,3,3,1,1,1.5,2.5,2.5,3,2.5,1,2,3,...
    3,2,0.5,2.5,2,2.5,2.5,3,2,2.5,1,2,2,2]' ;
yR = [2,1,2,1,2.5,2.5,1.5,2.5,1,3,2.5,3,3,1.5,3,3,3,2,2,2.5,2,2.5,3,2,0.5,...
    0,2.5,1,1.5,0,1.5,2,2.5,2.5,3,3,2.5,3,2.5,1,2]';
xL = [ones(20,1); zeros(21,1)] ;
xR = [ones(6,1); zeros(14,1); ones(14,1); zeros(7,1)] ;
intercept = ones(41,1) ;
xxL1 = [intercept, xL] ;
xxR1 = [intercept, xR] ;
X = {xxL1, xxR1};
Y = {yL, yR};
links = {'id', 'id'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
```

```matlab
>> betas{1}

ans =

    2.1958
   -0.2029

>> betas{2}

ans =

    2.4007
   -0.6670
```