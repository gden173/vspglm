function [logp, b, thetas, betas] = extractParam(params, N, dims)
    % [logp, b, thetas, betas] = extractParam(params, N, dims)
    % Extracts the current parameter values for the log probabilities
    % (logp), normalising constants (b), tilts (theta) and linear
    % predictors (beta) from the param vector.
    % 
    % Parameters:
    %            params, a (N + N + (K * N) + sum(dims)) x 1 array of 
    %                   the current parameter values.  The format of this 
    %                   array is 
    %                   [log(p), b, theta_1,.., theta_k, beta_1, .. beta_k]
    %            N, integer number of observations in each Y_i
    %            dims, 1 x K array containing the dimension q_i,
    %                 i = 1, 2, .., K of each design matrix X_i
    % Returns:
    %         logp, N x 1 array of log probabilities
    %            b, N x 1 array of normalising constants
    %       thetas, 1 x K cell array of N x 1 arrays of tilt values
    %        betas, 1 x K cell array of q_i x 1 arrays of linear predictors
    %               i = 1, .., K
    
    
    %  Extract the parameters
    K = length(dims);
    [betas, logp, b, thetas] = deal(params(1:sum(dims)),...
                                    params((sum(dims) + 1):(sum(dims)+ N)),...
                                    params((sum(dims)+1+N):(sum(dims)+2*N)),...
                                    params((sum(dims)+2*N + 1):end));
    
    % Reshape the data to be column vectors
    logp = reshape(logp, [N, 1]);
    b = reshape(b, [N,1]);
    
    % Convert theatas and betas to cell arrays
    thetas = num2cell(reshape(thetas, [N, K]), 1);
    betas = mat2cell(reshape(betas,[sum(dims), 1] ), dims, 1);                            
                                
end






