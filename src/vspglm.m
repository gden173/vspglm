function [ maxLogLike, param, converged] = vspglm(Y, X, links,Aeq)
    %[betas, maxLogLike, phat] = vspglm(Y, X, links)
    % Use the method proposed by Huang (2014) in 
    % Joint Estimation of the Mean and Error Distribution in 
    % Generalized Linear Models 
    % https://doi.org/10.1080/01621459.2013.824892
    % To fit a Generalized Linear Model to the given data.
    % 
    % Parameters:
    % Y, 1 x K cell array of n x 1 response variables
    % X, 1 x K cell array of n x q_i design matrices i = 1, 2, .., K
    % links, 1 x K cell array of link functions, possible choices 
    %                   'id' -> mu = XB
    %                   'inv' ->  1/mu = XB
    %                   'log' -> log(mu) = XB
    %                   'logit' -> log(mu/(1-mu)) = XB
    % cons, either the keyword "equal" meaning that linear
    % predictors should be shared among all response variables or
    % "symmetric" meaning that if 2N = K, then the first N responses should
    % share linear predictors, and the second N responses should share the
    % second set of linear predictors.  Errors will be thrown if different
    % link functions are specified for responses which are constrained to
    % have the same linear predictors
    % 
    % Returns:
    % betas, 1 x K cell array of q_i x  1 column vectors of linear
    %        predictors   i = 1, 2, .., K
    % maxLogLike, double value of the maximum log likelihood achieved under
    %             these values for beta
    % phat, n x 1 column vector of estimates for p_i. The empirical 
    %      probability masses of the error distribution
    arguments
        Y (1,:) cell
        X (1,:) cell
        links (1,:) cell       
        Aeq cell  
    end
    
    % Determine if this is a symmetric model or not 
    isSymmetric = length(Aeq) == 1;
    
    
    
    % Check the input data 
    if length(Y) == length(X)
        K = length(Y);
    else
        error('prog:input',...
              sprintf('Cell Arrays are of Incompatible Sizes \n'));                    
    end
   
    %----------------------------------------------------------------------
   
    [row, cols] = cellfun(@size, X);
    dims = cols;
    
    
        
    
    % Extract Y dimensions
    [y_rows, ~] = cellfun(@size, Y);
    
    % Check dimensions
    assert(isequal(row, y_rows), "Incorrect Data Dimensions")
      
    
    % Observations
    N = y_rows(1);  
    
    % Initial beta values
    beta0 = initialBetas(Y, links, dims);
    
    
    % Set the initial values of the parameters
    p0 = ones(N,1)/N;
    logp0 = log(p0);
    b0 = zeros(N,1);
    thetas = zeros(N * K,1);   
   
        
   
    param0 = [reshape(cell2mat(beta0), [sum(dims), 1]);logp0;b0;thetas];
    
    %----------------------------------------------------------------------
    % Normalise the response vector
    minMax = cell(1, K);
    y = cell(1, K);    
    for i = 1:K
        m = min(Y{i});
        M = max(Y{i});
        y{i} = (Y{i} - (m + M)/2)*(2/(M-m));
        minMax{i} = [m, M];
    end
    %----------------------------------------------------------------------
    
    % Functions to pass data to
    likelihood = @(params) logLikelihood(params,y,dims);
    constraint = @(params) constraints(params,X,y,dims,links, minMax);
    
    % Set options for FMINCON
    % 'interior-point'
    % 'active-set'
    options = optimset('MaxFunEvals',1e5, 'MaxIter', 1e5, 'TolFun', 1e-8,...
             'TolCon', 1e-6, 'TolX', 1e-10,...
             'Algorithm', 'sqp',...
             'Display', 'off', 'GradConstr', 'on', 'GradObj', 'on', ...
             'SubproblemAlgorithm', 'cg') ;

    
    
    upperBound = [Inf*ones(1, length(param0) - (N*K)),(500/K) * ones(1, N*K)];
    lowerBound = - upperBound;
    tic
    
    [param, fvalue, converged, output,...
        ~] = fmincon(likelihood, param0,...
                                [], [],blkdiag(blkdiag(Aeq{:}), zeros(length(param0) - sum(dims))),...
                                zeros(length(param0), 1),...
                                [],....
                                [] ,constraint, options);

    toc
    maxLogLike=-fvalue ;   
    fprintf("Convergence Flag:%d \n ", converged)
    assert(converged ~= -1 && converged ~= -2, 'No Optimal Point Was Found');
    
    
    
   

    
end

%% Helper Functions 


%--------------------------------------------------------------------------
%  Calculates the initial beta values
function [betas] = initialBetas(Y, links, dims)   
    % [betas] = initialBetas(Y, links, dims) 
    % Calculates the initial guess for each beta
    % This coincides to beta_0i = link(mean(y_i)), beta_ji = 0 forall j
    % Parameters:
    %            Y, a 1 x K cell array of n x 1 response variables
    %            links, 1 x K cell array of link functions, possible choices 
    %                   'id' -> mu = XB
    %                   'inv' ->  1/mu = XB
    %                   'log' -> log(mu) = XB
    %                   'logit' -> log(mu/(1-mu)) = XB
    %            dims, 1 x K array containing the dimension q_i,
    %                  i = 1, 2, .., K of each design matrix X_i
    % Returns:
    %         betas, 1 x K cell array of q_i x 1 arrays containing the
    %                initial beta values   
    arguments
        Y (1, :) cell
        links (1, :) cell
        dims         
    end
    
    
    
    % Cell array to store the initial values in 
    vals = cell(1,length(links));
    
    % Cell array to store betas in 
    betas = cell(length(links), 1);
    
    % Loop through and calculate initial value
    for i = 1:length(links)        
        mu = mean(Y{i});               
        switch links{i}
            case 'id'
                vals{i} = mu;
            case 'inv'
                vals{i} = 1/mu;
            case 'log'
                assert(mu > 0, "Log Link applied to negative mean")
                vals{i} = log(mu);
            case 'logit'
                assert(mu > 0 && mu < 1,...
                    "Logit  Link applied to incorrect mean")
                vals{i} = log(mu/(1-mu));
        end
               
        betas{i} = [vals{i}; zeros(dims(i) - 1, 1)];
        
    end
end
%--------------------------------------------------------------------------
