#  vspglm
This repository contains `MATLAB` Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver.
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
once the `src` directory has been added to path. 



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
* @gdenn173
