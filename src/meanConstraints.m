function[meanConstraint, meanConstraintGrad]= meanConstraints(Y,X,param,dims, links)
    %[meanConstraint, meanConstraintGrad]= meanConstraints(Y,X,param,links)
    % Computes the mean constraints for the given response variables
    %                 Y = {y1, ..., yd}
    % and design matrices
    %                 X = {x1, ..., xd};    
    
    % Number of data points
    [N,~] = cellfun(@size, X);    
    [N, K] = deal(N(1), length(X)); 
    % Extract the parameters 
    [logp, b, thetas, betas]= extractParam(param, N,K,  dims);
    
    % Beta derivatives
    [betaGradient] = betaDerivatives(betas, X, links,dims);
    
    % Current fitted mean values
    mus = meanValues(X, betas, links);    
       
    % Compute p_i * exp(theta_j * Y_i + b_j)j = 1, ..., N
    % These are stored across the rows of pexp
    
    % Compute the products and sum the results
    thetaY = cellfun(@(x,y) x.*y.', thetas, Y, 'UniformOutput', false);
    thetaYSum = sum(reshape(cell2mat(thetaY), [N,N,K]), 3);
    pexp = -exp(logp.' + b + thetaYSum); % N x N
           
    % Multiplication is done across the rows
    ypexp = cellfun(@(y) (y.').* pexp, Y,'UniformOutput', false);
    
    % Get the cross multiplication terms
    y2pexp = cell(K, K);
    for i = 1:K
        for j = 1:K
            y2pexp{i,j} = (Y{i}.').*ypexp{j};
        end
    end
   
    % Mean constraints
    meanConstraint = cell2mat(cellfun(@(mu, yp) mu + sum(yp,2),...
        mus, ypexp,'UniformOutput', false).');     
    
    
    % Partial derivatives 
    partial_p = cell2mat(ypexp.');
    
    partial_b = cell2mat(cellfun(@(yp) diag(sum(yp, 2)), ypexp.', ...
        'UniformOutput', false));
    
    % theta partial derivatives
    partial_theta = cell(1, K);
    
    for i = 1:K
        partial_i = cell(K,1);
        for j=1:K
            partial_i{j} = diag(sum(y2pexp{i,j}, 2));
        end
        partial_theta{i} = cell2mat(partial_i);
    end    
    
    % Set the gradient matrix
    meanConstraintGrad = [betaGradient,...
                         partial_p,...
                          partial_b,...
                          cell2mat(partial_theta)];
        
    
end

%% Helper Functions 

function [betaGradient] = betaDerivatives(betas, X, links,dims)
    % [betaGradient] = betaDerivatives(betas, X, links)
    % Takes as arguments  a 1 X K cell array of the linear predictors 
    %                 betas = {beta_1,.., beta_k}
    % each with dimension P X 1. X is also a 1 X K cell array of design
    % matrices.
    %                 X = {x_1, ..., x_k}
    % where size(x_i) = [N, length(beta_i)] and a 1 X K cell array of
    % strings links which denotes the ith link function used 
    %                 links = {link1, link2, ..., link_K}
    % Possible links are {'id', 'inv', 'log', 'logit'}
    % betaDerivatives(betas, X, links) then outputs betaGradient which is 
    % a (KN)(Number of mean constraints) X sum(length(beta_i), i =1,
    % ..K) (Number of beta parameters)
    
    
    % Data points
    N = size(X{1}, 1);   
    K = length(X);
    
    % Loop through links
    vals = cell(1,K);    
    for j = 1:K
        
        link  = links{j};
        b = betas{j};
        
        switch link
            case 'id'
                vals{j} = X{j};
            case 'inv'
                vals{j} = -(1./(X{j}*b)).^2.* X{j};
            case 'log'
                mu = exp(X{j}* b);
                vals{j} = mu.* X{j};
            case 'logit'
                eXB = exp(X{j}*b);
                mu = eXB./(1 + eXB);
                vals{j} = (mu.*(1 - mu)).*X{j};
        end
    end
    % Set row 
    betaGradient = blkdiag(vals{1:end});
    

    
end

function [mus] = meanValues(X, betas, links)
% [mus] = meanValues(X, betas, links) computes the current 
% fitted mean values for using the given design matrices X  = {x_1, ..,
% x_k}, linear predictors betas = {beta_1, ..., beta_k}
% and links = {'id', 'inv', 'log', 'logit}

K = length(X);
mus = cell(1, K);

for i=1:K
    
    link = links{i};
    XB = X{i}* betas{i};
    
    switch link
        case 'id'
            mus{i} = XB;
        case 'inv'
            mus{i} = 1./XB;
        case 'log'
            mus{i} = exp(XB);
        case 'logit'
            mus{i} = exp(XB)./(1 +  exp(XB));
    end
end
end