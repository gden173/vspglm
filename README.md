#  vspglm
All MATLAB Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver. The univariate case of this method was first proposed by Huang (2014) in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892

This method rewrites the density of each observation $\vec{y}_{i} \in \mathbb{R}^{K}$ using its exponential tilt form 
$$
dF_i(\vec{y}) = \exp\Big\{b_i + \langle \vec{\theta}_i, \vec{y}\rangle\Big\}dF(\vec{y})
$$


In this model we maximize the empirical  log likelihood 
$$
\ell = \sum_{i = 1}^{n} \ln p_i + b_i + \langle \vec{\theta}_i, \vec{y}_i\rangle
$$
Subject to $n$ normalizing constraints
$$
1 = \sum_{i = 1}^{n} \exp \Big\{ \ln p_i + b_j + \langle \vec{\theta}_j, \vec{y}_i\rangle \Big\} \  \ j = 1,2,\dots, n
$$
And $n \times k$ mean constraints, for $y_i \in \mathbb{R}^K$ 
$$
\eta_j(\vec{x}_{kj}^T\beta_j) = \sum_{i = 1}^{n} y_{ij}\exp \Big\{ \ln p_i + b_i + \langle \vec{\theta}_i, \vec{y}_i\rangle \Big\}  \  \ \forall  \ k = 1, \dots, n, \  \ j = 1,\dots, K
$$




### Usage 

Current usage examples

### Univariate Response

#### Mine Fracture Data Set

```matlab
%% MINE FRACTURE DATSET from Myers et. al. (2010)
x1 = [50,230,125,75,70,65,65,350,350,160,145,145,180,43,42,42,45,83,300,...
    190,145,510,65,470,300,275,420,65,40,900,95,40,140,150,80,80,145,100,...
    150,150,210,11,100,50]' ;
x2 = [70,65,70,65,65,70,60,60,90,80,65,85,70,80,85,85,85,85,65,90,90,80,75,...
    90,80,90,50,80,75,90,88,85,90,50,60,85,65,65,80,80,75,75,65,88]' ;
x4 = [1,6,1,0.5,0.5,3,1,0.5,0.5,0,10,0,2,0,12,0,0,10,10,6,12,10,5,9,9,4,17,...
    15,15,35,20,10,7,5,5,5,9,9,3,0,2,0,25,20]' ;
xx = [x1, x2, x4] ;
y = [2,1,0,4,1,2,0,0,4,4,1,4,1,5,2,5,5,5,0,5,1,1,3,3,2,2,0,1,5,2,3,3,3,...
    0,0,2,0,0,3,2,3,5,0,3]' ;
% Data for model
X = {xx};
Y = {y};
links = {'log'};
min_model = fit_vspglm(Y, X, links);
```

```matlab
Running VSPGLM: 
VSPGLM converged in 0.578 seconds 



 Semi-Parametric Vector Generalized Linear Regression Model: 
 
         fmincon converged in 48 iterations. 
         Linear Predictors are unconstrained. 
 
         Model 1: 
               log(y) ~ 1 + x1 + x2 + x3  
               Link = log 
 
Estimated Coefficients: 
         Model 1:  Response: y 
                   Estimates 
                   __________

    (intercept)       -3.1096
    x1             -0.0018214
    x2               0.056418
    x3               -0.04164


Number of Observations: 44 
Degrees of Freedom: 40 
Log-Likelihood: -149.526613 
F-Statistic vs constant model: 0.959100 , P-value:0.551646

```

#### Leukemia Survival Times

```matlab
%% LEUKEMIA SURVIVAL TIMES from Davison and Hinkley (1997)
x1 =[1 0 3.36 0;
     1 0 2.88 0;
     1 0 3.63 0;
     1 0 3.41 0;
     1 0 3.78 0;
     1 0 4.02 0;
     1 0 4.00 0;
     1 0 4.23 0;
     1 0 3.73 0;
     1 0 3.85 0;
     1 0 3.97 0;
     1 0 4.51 0;
     1 0 4.54 0;
     1 0 5.00 0;
     1 0 5.00 0;
     1 0 4.72 0;
     1 0 5.00 0;
     1 1 3.64 3.64;
     1 1 3.48 3.48;
     1 1 3.60 3.60;
     1 1 3.18 3.18;
     1 1 3.95 3.95;
     1 1 3.72 3.72;
     1 1 4.00 4.00;
     1 1 4.28 4.28;
     1 1 4.43 4.43;
     1 1 4.45 4.45;
     1 1 4.49 4.49;
     1 1 4.41 4.41;
     1 1 4.32 4.32;
     1 1 4.90 4.90;
     1 1 5.00 5.00;
     1 1 5.00 5.00] ;
 
 y = [65; 156; 100; 134; 16; 108; 121; 4; 39; 143; 56; 26; 22; 1; 1; 5;
     65; 56; 65; 17; 7; 16; 22; 3; 4; 2; 3; 8; 4;3; 30; 4; 43];
leuk_model = fit_vspglm({y}, {x1(:, 2:end)}, {'log'});
```

```matlab
Running VSPGLM: 
VSPGLM converged in 0.342 seconds 



 Semi-Parametric Vector Generalized Linear Regression Model: 
 
         fmincon converged in 37 iterations. 
         Linear Predictors are unconstrained. 
 
         Model 1: 
               log(y) ~ 1 + x1 + x2 + x3  
               Link = log 
 
Estimated Coefficients: 
         Model 1:  Response: y 
                   Estimates
                   _________

    (intercept)      7.6466 
    x1              -3.1368 
    x2             -0.90163 
    x3              0.50813 


Number of Observations: 33 
Degrees of Freedom: 29 
Log-Likelihood: -103.234539 
F-Statistic vs constant model: 1.095928 , P-value:0.398709

```

### Blood Clot

```matlab
%BLOOD CLOT DATASET from McCullagh and Nelder (1989)
% blood-clot example from MN1989
u = [5,10,15,20,30,40,60,80,100,5,10,15,20,30,40,60,80,100]';
time = [118,58,42,35,27,25,21,19,18,69,35,26,21,18,16,13,12,12]';
lot = [zeros(1,9),ones(1,9)]';
X = {[lot,log(u),lot.*log(u)]} ;
links = {'inv'};
clot_model = fit_vspglm({time}, X, links);
```

```matlab
Running VSPGLM: 
VSPGLM converged in 0.434 seconds 



 Semi-Parametric Vector Generalized Linear Regression Model: 
 
         fmincon converged in 60 iterations. 
         Linear Predictors are unconstrained.
 
         Model 1: 
               1/y ~ 1 + x1 + x2 + x3  
               Link = inv 
 
Estimated Coefficients: 
         Model 1:  Response: y 
                   Estimates
                   _________

    (intercept)    -0.016819
    x1             -0.005672
    x2              0.015716
    x3             0.0072635


Number of Observations: 18 
Degrees of Freedom: 14 
Log-Likelihood: -11.128060 

```



### Multivariate Response 

#### Burns

```matlab
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


```

The resulting models are

```matlab
Running VSPGLM: 
VSPGLM converged in 239.035 seconds 



 Semi-Parametric Vector Generalized Linear Regression Model: 
 
         fmincon converged in 21 iterations. 
         Linear Predictors are unconstrained. 
 
         Model 1: 
               log(death) - log(1-death) ~ 1 + age 
               Link = logit 
          Model 2: 
               burn_severity ~ 1 + age 
               Link = id 
 
Estimated Coefficients: 
         Model 1:  Response: death 
                   Estimates
                   _________

    (intercept)       3.657 
    age            -0.05009 


         Model 2:  Response: burn_severity 
                   Estimates
                   _________

    (intercept)      6.7318 
    age            0.002664 


Number of Observations: 1962 
Degrees of Freedom: 1958 
Log-Likelihood: -6668.436075 
F-Statistic vs constant model: 1.742574 , P-value:0.000000
```

#### UN

```matlab
un = readtable('UN2.txt');

% Create Design matrices
X = {un(:,3),un(:,3)};
Y = {un(:,1), un(:,2)};
links = {'id', 'id'};
un_model = fit_vspglm(Y, X, links);

```

```matlab
Running VSPGLM: 
VSPGLM converged in 6.646 seconds 



 Semi-Parametric Vector Generalized Linear Regression Model: 
 
         fmincon converged in 42 iterations. 
         Linear Predictors are unconstrained. 
 
         Model 1: 
               logPPgdp ~ 1 + Purban 
               Link = id 
          Model 2: 
               logFertility ~ 1 + Purban 
               Link = id 
 
Estimated Coefficients: 
         Model 1:  Response: logPPgdp 
                   Estimates
                   _________

    (intercept)      6.9924 
    Purban          0.07303 


         Model 2:  Response: logFertility 
                   Estimates
                   _________

    (intercept)       1.7219
    Purban         -0.012512


Number of Observations: 386 
Degrees of Freedom: 382 
Log-Likelihood: -933.224765 
F-Statistic vs constant model: 0.409191 , P-value:1.000000
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
Running VSPGLM: 
Fitted Model Found: 
Y_1 ~ 2.195763x_0-0.202929x_1
Y_2 ~ 2.400669x_0-0.667040x_1
```

#### Hunua

```matlab
hunu = readtable('hunua.txt');
x = [ones(size(hunu, 1), 1), hunu.altitude];
X = {x,x,x};
Y = {hunu.cyadea, hunu.beitaw,hunu.kniexc};
links = {'log', 'log', 'log'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);

```

```matlab
Running VSPGLM: 
VSPGLM converged in 82.901 seconds 
Fitted Model Found: 
log((Y_1)/(1 - Y_1)) ~ -0.755x_0+0.000253x_1
log((Y_2)/(1 - Y_2)) ~ -1.048x_0+0.004084x_1
log((Y_3)/(1 - Y_3)) ~ -0.069x_0+0.002654x_1
```

#### 8 Dimensional Test

8 Dimensional test run. Every second model should be identical, as they each use the same data and link function.

The data used here is just replications of the data found in the Burns example.

```matlab
N = 100;
x = [ones(N, 1), data.age(1:N)];
X = {x,x,x,x,x,x,x,x};
y1 = data.death(1:N);
y2 = data.burn_severity(1:N);
Y = {y1,y2,y1,y2,y1,y2,y1,y2};
links = {'logit', 'id','logit', 'id','logit', 'id','logit', 'id'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
```

```matlab
Running VSPGLM: 
VSPGLM converged in 16.716 seconds 
Fitted Model Found: 
log((Y_1)/(1 - Y_1)) ~ 3.031x_0-0.027330x_1
Y_2 ~ 6.574x_0-0.000400x_1
log((Y_3)/(1 - Y_3)) ~ 3.031x_0-0.027330x_1
Y_4 ~ 6.574x_0-0.000400x_1
log((Y_5)/(1 - Y_5)) ~ 3.031x_0-0.027330x_1
Y_6 ~ 6.574x_0-0.000400x_1
log((Y_7)/(1 - Y_7)) ~ 3.031x_0-0.027330x_1
Y_8 ~ 6.574x_0-0.000400x_1
```





![](C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\hunua.PNG)