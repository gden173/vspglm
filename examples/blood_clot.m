%BLOOD CLOT DATASET from McCullagh and Nelder (1989)
% blood-clot example from MN1989
u = [5,10,15,20,30,40,60,80,100,5,10,15,20,30,40,60,80,100]';
time = [118,58,42,35,27,25,21,19,18,69,35,26,21,18,16,13,12,12]';
lot = [zeros(1,9),ones(1,9)]';
X = table(lot,log(u),lot.*log(u), time) ;
%%
links = {'inv'};
clot_model = fit_vspglm("(time, time) ~ (lot, Var2, Var3)", X, links);