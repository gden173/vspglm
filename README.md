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
x1 = [50,230,125,75,70,65,65,350,350,160,145,145,180,43,42,42,45,83,300,...
    190,145,510,65,470,300,275,420,65,40,900,95,40,140,150,80,80,145,100,...
    150,150,210,11,100,50]' ;
x2 = [70,65,70,65,65,70,60,60,90,80,65,85,70,80,85,85,85,85,65,90,90,80,75,...
    90,80,90,50,80,75,90,88,85,90,50,60,85,65,65,80,80,75,75,65,88]' ;
x4 = [1,6,1,0.5,0.5,3,1,0.5,0.5,0,10,0,2,0,12,0,0,10,10,6,12,10,5,9,9,4,17,...
    15,15,35,20,10,7,5,5,5,9,9,3,0,2,0,25,20]' ;
intercept = ones(44,1) ;
xx = [intercept, x1, x2, x4] ;
y = [2,1,0,4,1,2,0,0,4,4,1,4,1,5,2,5,5,5,0,5,1,1,3,3,2,2,0,1,5,2,3,3,3,...
    0,0,2,0,0,3,2,3,5,0,3]' ;
% Data for model
X = {xx};
Y = {y};
links = {'log'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
```

```matlab
>> betas{1}

ans =

   -3.1096
   -0.0018
    0.0564
   -0.0416

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
 [betas, maxLogLike, phat, iter] = vspglm({y}, {x1}, {'log'});
```

```matlab
>> betas{1}

ans =

    7.6466
   -3.1368
   -0.9016
    0.5081

```

### Blood Clot

```matlab
 BLOOD CLOT DATASET from McCullagh and Nelder (1989)
% blood-clot example from MN1989
u = [5,10,15,20,30,40,60,80,100,5,10,15,20,30,40,60,80,100]';
time = [118,58,42,35,27,25,21,19,18,69,35,26,21,18,16,13,12,12]';
lot = [zeros(1,9),ones(1,9)]';
X = {[ones(18,1),lot,log(u),lot.*log(u)]} ;
links = {'inv'};
[betas, maxLogLike, phat, iter] = vspglm({time}, X, links);
```

```matlab
>> betas{1}

ans =

   -0.0168
   -0.0057
    0.0157
    0.0073

```



### Multivariate Response 

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

#### Hunua

```matlab
hunua = readtable('hunua.txt');
x = [ones(size(hunua, 1), 1), hunua.altitude];
X = {x,x,x};
Y = {hunua.cyadea, hunua.beitaw,hunua.kniexc};
links = {'logit', 'logit', 'logit'};
[betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
>> betas{1}

ans =

   -0.7547
    0.0003

>> betas{2}

ans =

   -1.0478
    0.0041

>> betas{3}

ans =

   -0.0686
    0.0027
```

The paper On generalized estimating equations for vector regression by Huang (2016) has these parameters  as

![](C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\hunua.PNG)