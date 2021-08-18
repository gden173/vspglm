#  vspglm
All MATLAB Code and examples related to a Semi-Parametric Vector Generalized Linear Model Solver.
 The univariate case of this method was first proposed by Huang (2014) 
in Joint Estimation of the Mean and Error Distribution in Generalized Linear Models https://doi.org/10.1080/01621459.2013.824892

## Usage

This function requires `MATLABs` Optimization toolbox.  

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

	/path/to/vspglm
```

To run the scripts in the examples directory,  while in the same directory run 

```matlab
>> addpath('examples', '-end')
```

from the command  window.


## Examples

Examples usages can be found in `examples`.



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
