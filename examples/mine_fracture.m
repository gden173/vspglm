
%% MINE FRACTURE DATSET from Myers et. al. (2010)
x1 = [50,230,125,75,70,65,65,350,350,160,145,145,180,43,42,42,45,83,300,...
    190,145,510,65,470,300,275,420,65,40,900,95,40,140,150,80,80,145,100,...
    150,150,210,11,100,50]' ;
x2 = [70,65,70,65,65,70,60,60,90,80,65,85,70,80,85,85,85,85,65,90,90,80,75,...
    90,80,90,50,80,75,90,88,85,90,50,60,85,65,65,80,80,75,75,65,88]' ;
x4 = [1,6,1,0.5,0.5,3,1,0.5,0.5,0,10,0,2,0,12,0,0,10,10,6,12,10,5,9,9,4,17,...
    15,15,35,20,10,7,5,5,5,9,9,3,0,2,0,25,20]' ;
y = [2,1,0,4,1,2,0,0,4,4,1,4,1,5,2,5,5,5,0,5,1,1,3,3,2,2,0,1,5,2,3,3,3,...
    0,0,2,0,0,3,2,3,5,0,3]' ;
X = table(x1, x2, x4, y);
links = {'log'};
min_model = fit_vspglm("y ~ (x1, x2, x4)", X, links);
min_model.coefficients