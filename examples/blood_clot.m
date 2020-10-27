%BLOOD CLOT DATASET from McCullagh and Nelder (1989)
% blood-clot example from MN1989
u = [5,10,15,20,30,40,60,80,100,5,10,15,20,30,40,60,80,100]';
time = [118,58,42,35,27,25,21,19,18,69,35,26,21,18,16,13,12,12]';
lot = [zeros(1,9),ones(1,9)]';
X = {[ones(18,1),lot,log(u),lot.*log(u)]} ;
links = {'inv'};
[betas, maxLogLike, phat, iter] = vspglm({time}, X, links);