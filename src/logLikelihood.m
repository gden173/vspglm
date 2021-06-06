function [logLike, grad] = logLikelihood(params, Y, dims)
    % [logLike, grad] = logLikelihood(params, Y, dims)
    % Computes the empirical log likelihood using the observed data and 
    % the current parameter values
    % Parameters:
    %            params, a (N + N + (K * N) + sum(dims)) x 1 array of 
    %                   the current parameter values.  The format of this 
    %                   array is 
    %                   [log(p), b, theta_1,.., theta_k, beta_1, .. beta_k]
    %            Y, 1 x K cell array of n x 1 response variables
    %            dims, 1 x K array containing the dimension q_i,
    %                  i = 1, 2, .., K of each design matrix X_i
    % Returns:
    %         logLike, the current  negative log likelihood value
    %         grad, N + N + (K * N) + sum(dims)) x 1 array of partial
    %               derivatives \frac{partial logLik}{\partial param_i}
    
    % Number of Observations and design matrices
    N = length(Y{1});
    K  = length(Y);
    
    % Parameters
    [logp, b, thetas, ~] = extractParam(params, N,K, dims);
    
    % Calculate the Likelihood
    logLike = -sum(logp + b) - sum(cellfun(@(theta, y) dot(y, theta),...
                                thetas, Y, 'UniformOutput', true));
    
    % Calculate the gradient
    grad = [zeros(sum(dims), 1);...
             -ones(N,1);...
            -ones(N,1);...
            -reshape(cell2mat(Y), N * K, 1)];    
    
end