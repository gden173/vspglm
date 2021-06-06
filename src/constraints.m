function [c, ceq, gradc, gradceq] = constraints(param,X,Y,dims, links, minMax)
%[c, ceq, gradc, gradceq] = constraints(param,X,Y,links) 
% computes and returns the equality and inequality constraints
% for fmincons optimization. The gradients of each constraint 
% are also computed and returned.
% The arguments to this function are 
% param = [betas, logp, b, thetas] which is of dimension
% 1 x (4 * N + sum(dims))

% Normalization constraints
[normConstraint, normConstraintGrad] = normConstraints(Y,X, param,dims);

% Mean Constraints
[meanConstraint, meanConstraintGrad]= meanConstraints(Y,X,param,dims,links, minMax);

% Augment both vectors and return them 
c = [];
gradc = [];
ceq = [meanConstraint;normConstraint].';
gradceq = [meanConstraintGrad;normConstraintGrad].';    

end