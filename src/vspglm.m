function [betas, maxLogLike, phat, iter] = vspglm(Y, X, links)
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
    % Returns:
    % betas, 1 x K cell array of q_i x  1 column vectors of linear
    %        predictors   i = 1, 2, .., K
    % maxLogLike, double value of the maximum log likelihood achieved under
    %             these values for beta
    % phat, n x 1 column vector of estimates for p_i. The empirical 
    %      probability masses of the error distribution
    
    % Check the input data 
    if length(Y) == length(X)
        K = length(Y);
    else
        error('prog:input',...
              sprintf('Cell Arrays are of Incompatible Sizes \n'));                    
    end
    
    % Extract dimensions
    [x_rows, dims] = cellfun(@size, X);
    [y_rows, ~] = cellfun(@size, Y);
    
    % Check dimensions
    assert(isequal(x_rows, y_rows), "Incorrect Data Dimensions")
      
    
    % Observations
    N = y_rows(1);  
    
    
    % Get the initial beta values
    beta0 = initialBetas(Y, links, dims);
    
    % Set the initial values of the parameters    
    p0 = ones(N,1)/N;                 
    logp0 = log(p0);                   
    b0 = zeros(N,1);                  
    thetas = zeros(N * K,1);
    
    % Initial Parameter vector
    param0 = [ reshape(cell2mat(beta0), [sum(dims), 1]);logp0;b0;thetas];
    
    % Functions to pass data to
    likelihood = @(params) logLikelihood(params,Y,dims);
    constraint = @(params) constraints(params,X,Y,links);
    
        % Set options for FMINCON
    options = optimset('MaxFunEvals',1e5, 'MaxIter', 1e5, 'TolFun', 1e-8,...
             'TolCon', 1e-8, 'TolX', 1e-8, 'Algorithm', 'interior-point',...
             'Display', 'off', 'GradConstr', 'on', 'GradObj', 'on') ;

     % Optimize
    [param, fvalue, exitflag, output,...
        ~] = fmincon(likelihood, param0,...
                                [], [], [], [], [], [],constraint, options) ;

    % Fitted model properties
    [logp, ~, ~,betas]= extractParam(param, N, dims);
    phat = exp(logp);   
    maxLogLike= -fvalue ;    
    iter = output.iterations;
    

    
end

%% Helper Functions 
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
    
    
    % Cell array to store the initial values in 
    vals = cell(1,length(dims));
    
    % Cell array to store betas in 
    betas = cell(1,length(dims));
    
    % Loop through and calculate initial value
    for i = 1:length(dims)
        mu = mean(Y{i});
        switch(links{i})
            case 'id'
                vals{i} = mu;
            case 'inv'
                vals{i} = 1/mu;
            case 'log'
                assert(mu > 0, "Log Link applied to negative mean")
                vals{i} = log(mu);
            case 'logit'
                assert(mu > 0 && mu < 1, "Logit  Link applied to incorrect mean")
                vals{i} = log(mu/(1-mu));
        end
        betas{i} = [vals{i}; zeros(dims(i) - 1, 1)];
    end        
 end