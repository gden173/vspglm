function [normConstraint, normConstraintGrad] = normConstraints(Y,X, param,dims)
    % [normConstraint, normConstraintGrad] = normConstraints(X, param)
    % takes as input Y = {y1, y2, .., yp} a cell array of response
    % variables and 
    % param = [p, b, theta, beta] a vector of parameters  and computes the 
    % normalizing constraint 
    %      1 - \sum_{i = 1}^{N} p_i * exp(theta_j * Y_i + b_j)
    %                      j = 1, ..., N
    % Which is output as the the 1 x N column vector normConstraint
    % Also computes the gradient of the normalising constraints 
    % \partial_{log p_i} => - p_i * exp(theta_j * Y_i + b_j), i = 1,.., N
    % \partial_{log b_j} =>
    %  - \sum_{i = 1}^{N} p_i * exp(theta_j * Y_i + b_j), j = 1,..N
    % \partial_{log theta_j} =>
    %       - \sum_{i = 1}^{N}Y_i *  p_i * exp(theta_j * Y_i + b_j)
    % \partial_{log beta_j} = 0
    % and outputs them in the array normConstraintsGrad which of dimension
    % length(param) x N (One column for every constraint)
    
    % Data
    N = length(Y{1});
    K = length(Y);
    % Extract the parameters
    [logp, b, thetas,~] = extractParam(param, N,K, dims);
      
      
    % Compute p_i * exp(theta_j * Y_i + b_j)j = 1, ..., N
    % These are stored across the rows of pexp
    
    % Compute the products and sum the results
    thetaY = cellfun(@(x,y) x.*y.', thetas, Y, 'UniformOutput', false);
    thetaYSum = sum(reshape(cell2mat(thetaY), [N,N,K]), 3);
    pexp = -exp(logp.' + b + thetaYSum); % N x N % N x N
    
    % Precompute this vector
    pexpSum = sum(pexp, 2);
    
    % The normalising constraint 
    %     1 - \sum_{i = 1}^{N} p_i * exp(theta_j * Y_i + b_j)
    %  is now just 1 - sum(pexp, 2)  (Sum along rows)
    normConstraint = 1 + pexpSum;
    
    % p partial derivative 
    partial_p = pexp;
    
    % b partial derivatives
    partial_b = diag(pexpSum);
    
    partial_theta = cellfun(@(y)diag(sum((y.').* pexp, 2)), Y, ...
        'UniformOutput', false);   
    
    
    % beta partial derivatives 
    %[~, vals] = cellfun(@size, X);
    partial_beta = zeros(N, sum(dims));
    
    % Assign to a matrix 
    normConstraintGrad = [partial_beta,...
                          partial_p,...
                          partial_b,...
                          cell2mat(partial_theta)];    
%     assert(isequaln(size(normConstraintGrad), [N, length(param)]), ...
%         'gradient is of improper size')
     
end