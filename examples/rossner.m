%% Fitted Model Using Rossner  data
clc;clear;rehash;
% Add the function to path
addpath(genpath('C:\Users\gabri\Dropbox\sem2_2020\honours\code\vspglm\src'))
%% Data 
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
