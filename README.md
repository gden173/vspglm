<<<<<<< HEAD
#  vspglm
All MATLAB Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver.
 The univariate case of this method was first proposed by Huang (2014) 
in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892



More information on this function can be found [here](https://github.com/gden173/vspglm/blob/main/docs/thesis.pdf)

## Usage

This function uses `MATLABs` Optimization toolbox and `MATLAB >= 2019b`.  

To use the function,  clone the repository  and add the function to your `MATLABPATH`

```bash
$ git clone https://github.com/gden173/vspglm.git
```

Then open this as your current working directory in `MATLAB` and run the following command in the command window

```matlab
>> addpath('src', '-end')
```

This should add the `vspglm` function to your `MATLABPATH` variable.  This can be checked by running

```
>> matlabpath

		MATLABPATH
		.
		.
		.

	/path/to/vspglm
```
Where the path to the cloned directory should be at the end of the `matlabpath` environment variable.  
This is only temporary, and will have to be rerun every `MATLAB` session.
To run the scripts in the examples directory,  while in the same directory run 

```matlab
>> addpath('examples', '-end')
```

from the command  window.


## Examples

Examples usages can be found in `examples`. The basic usage of the `fit_vspglm` function can be found by searching some of the documentation.
```matlab
>> help fit_vspglm
  vspglm_mmodel = fit_vspglm(formula, tbl,  links)
  fits a vector generalized semi-parametric linear model and stores
  the model output in vspglmmodel
  the function currently takes 3 arguments,
  formula, a string array of string formulas 
  In the formula argument:
             (y1, y2) ~ (x1, x3) -> y1 and y2 share all regression
             coefficients
             (y1, y2) ~ (x1, (x3|x4)) -> y1 and y2 share all 
             regression coefficients except for the coefficeint to x3 
             (y1) and x4 (y2)
  Responses can also  have a different number of covariates and still 
  share regression coefficients. To add another covariate use the
  notation (x2&x2|x3) and (0|0|x5), i.e
           (y1, y2, y3) ~ (x1,(x2&x2|x3), (0|0|x4))
  This means that 
                 y1 ~ 1  + x1  + x2
                 y2 ~ 1  + x1  + x2
                 y3 ~ 1  + x1  + x3  + x4
  Where the regression coefficients beta_0 and beta_1  
  shared amongst all three models, with beta_2 shared amongs y1 and y2
  and beta_3 and beta_4 unique to y3. For shared regression
  coefficients across different covariates use x1==x3
 
  Where each variable y1, .., yk, x1, .., xp are columns in 
  the table argument tbl. 
  The last argument is then links, a 1 x k cell array of the link
  functions to be used for each model.
```
once the `src` directory has been added to path. 



## Directory Structure

```
📦examples
 ┣ 📜blood_clot.m
 ┣ 📜burns.m
 ┣ 📜burns.txt
 ┣ 📜butterfly.m
 ┣ 📜butterfly_data.mat
 ┣ 📜butterfly_X.xlsx
 ┣ 📜butterfly_y.xlsx
 ┣ 📜cochlear.m
 ┣ 📜cochlear.xlsx 
 ┣ 📜hospital.csv
 ┣ 📜hospital.m
 ┣ 📜hunua.m
 ┣ 📜hunua.txt
 ┣ 📜iris.m
 ┣ 📜leukemia.m
 ┣ 📜mine_fracture.m
 ┣ 📜rossner.m
 ┣ 📜simulations.m
 ┣ 📜twoway.m
 ┣ 📜UN.m
 ┣ 📜UN2.txt
📦src 
 ┣ 📜constraints.m
 ┣ 📜extractParam.m
 ┣ 📜fit_vspglm.m
 ┣ 📜logLikelihood.m
 ┣ 📜meanConstraints.m
 ┣ 📜normConstraints.m
 ┣ 📜vcov.m
 ┣ 📜vspglm.m
 ┣ 📜VSPGLMFormula.m 
-📜.gitignore
-📜 README.md
```

## Author
* @gdenn173
=======
#  vspglm
This repository contains `MATLAB` Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver.
The univariate case of this method was first proposed by Huang (2014) 
in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892

More information on this function can be found [here](https://github.com/gden173/vspglm/blob/main/docs/thesis.pdf)

## Usage

This function uses `MATLABs` Optimization toolbox and `MATLAB >= 2019b`.  

To use the function,  first clone the repository 
```bash
$ git clone https://github.com/gden173/vspglm.git
```
Then open `MATLAB` and run the command `>> cd /path/to/vspglm`  and run the following command in the command window

```matlab 
>> addpath('src', '-end')
```

This should add the `vspglm` function to the end of  your `MATLABPATH` variable.  This can be checked by running

```matlab
>> matlabpath

		MATLABPATH
		.
		.
		.

	/path/to/vspglm
```
This is only temporary, and will have to be rerun every `MATLAB` session that you want to use this function.


## Examples

Examples usages can be found in `examples`. 

```matlab
% Two way drug trial data (Rossner 2006)

>>  responseOne = [ones(1, 22  + 18), zeros(1,4), ones(1, 8), zeros(1, 15)].';
responseTwo = [ones(1, 22  +18), ones(1,4), zeros(1, 8), zeros(1, 15)].';
treatment = [ones(1, 22), zeros(1, 22),ones(1, 6),...
    zeros(1, 2), ones(1, 6), zeros(1, 9) ].';
treatmentTwo = [zeros(1, 22), ones(1, 22),zeros(1, 6),...
    ones(1, 2), zeros(1, 6), ones(1, 9) ].';

Y = {table(responseOne), table(responseTwo)};
X = {table(treatment), table(treatmentTwo)};
tbl = [table(responseOne), table(responseTwo),...
    table(treatment), table(treatmentTwo)];

links = {'logit','logit'};
formula = ["responseOne ~ treatment ", "responseTwo ~ treatmentTwo"];
model = fit_vspglm(formula, tbl,  links);
model.coefficients % Extract the models


Elapsed time is 0.246267 seconds.
Convergence Flag:2 
 
ans =

  2×5 table

                     estimates            StdError              tValue               pValue          signif
                 _________________    _________________    ________________    __________________    ______

    Intercept    0.430782931903948    0.351328234396844    1.22615517265076     0.224563916326621    {'  '}
    treatment     1.10966216041655    0.578523718291602    1.91809276842342    0.0594940404964799    {'.' }


ans =

  2×5 table

                        estimates             StdError              tValue                pValue          signif
                    __________________    _________________    _________________    __________________    ______

    Intercept        0.606135746977055    0.358628710254868     1.69014841713674    0.0957904805233296    {'.' }
    treatmentTwo    0.0870114481169803    0.514949031091377    0.168970991036859     0.866344189568936    {'  '}

>> 
```


The basic usage of the `fit_vspglm` function can be found by searching some of the documentation
once the `src` directory has been added to path. 
```matlab
>> help fit_vspglm
  vspglm_mmodel = fit_vspglm(formula, tbl,  links)
  fits a vector generalized semi-parametric linear model and stores
  the model output in vspglmmodel
  the function currently takes 3 arguments,
  formula, a string array of string formulas 
  In the formula argument:
             (y1, y2) ~ (x1, x3) -> y1 and y2 share all regression
             coefficients
             (y1, y2) ~ (x1, x3|x4) -> y1 and y2 share all 
             regression coefficients except for the coefficeint to x3 
             (y1) and x4 (y2)
  Responses can also  have a different number of covariates and still 
  share regression coefficients. To add another covariate use the
  notation (x2&x2|x3) and (0|0|x5), i.e
           (y1, y2, y3) ~ (x1,(x2&x2|x3), (0|0|x4))
  This means that 
                 y1 ~ 1  + x1  + x2
                 y2 ~ 1  + x1  + x2
                 y3 ~ 1  + x1  + x3  + x4
  Where the regression coefficients beta_0 and beta_1  
  shared amongst all three models, with beta_2 shared amongs y1 and y2
  and beta_3 and beta_4 unique to y3. For shared regression
  coefficients across different covariates use x1==x3
 
  Where each variable y1, .., yk, x1, .., xp are columns in 
  the table argument tbl. 
  The last argument is then links, a 1 x k cell array of the link
  functions to be used for each model.
```




## Directory Structure

```
📦docs
 ┣ 📜thesis.pdf
📦examples
 ┣ 📜blood_clot.m
 ┣ 📜burns.m
 ┣ 📜burns.txt
 ┣ 📜butterfly.m
 ┣ 📜butterfly_data.mat
 ┣ 📜butterfly_X.xlsx
 ┣ 📜butterfly_y.xlsx
 ┣ 📜cochlear.m
 ┣ 📜cochlear.xlsx 
 ┣ 📜hospital.csv
 ┣ 📜hospital.m
 ┣ 📜hunua.m
 ┣ 📜hunua.txt
 ┣ 📜iris.m
 ┣ 📜leukemia.m
 ┣ 📜mine_fracture.m
 ┣ 📜rossner.m
 ┣ 📜simulations.m
 ┣ 📜twoway.m
 ┣ 📜UN.m
 ┣ 📜UN2.txt
📦src 
 ┣ 📜constraints.m
 ┣ 📜extractParam.m
 ┣ 📜fit_vspglm.m
 ┣ 📜logLikelihood.m
 ┣ 📜meanConstraints.m
 ┣ 📜normConstraints.m
 ┣ 📜vcov.m
 ┣ 📜vspglm.m
 ┣ 📜VSPGLMFormula.m 
-📜.gitignore
-📜 README.md
```

## Author
* @gden173
>>>>>>> 65407056ee4fd7c27478baeb72db8ba4b46dd1e5
