function [c, ceq, gradc, gradceq] = constraints(param,X,Y,links)
%[c, ceq, gradc, gradceq] = constraints(param,X,Y,links) 
% computes and returns the equality and inequality constraints
% for fmincons optimization. The gradients of each constraint 
% are also computed and returned.
% The arguments to this function are 
% param = [betas, logp, b, thetas] which is of dimension
% 1 x (4 * N + sum(dims))

% Extract the parameters
[~, dims] = cellfun(@size, X);

% Normalization constraints
[normConstraint, normConstraintGrad] = normConstraints(Y, param,dims);

% Mean Constraints
[meanConstraint, meanConstraintGrad]= meanConstraints(Y,X,param,links);

% Augment both vectors and return them 
c = [];
gradc = [];
ceq = [meanConstraint;normConstraint].';
gradceq = [meanConstraintGrad;normConstraintGrad].';    

end