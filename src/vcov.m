function [se, co] = vcov(X, Y, param, links)
    % Calculates the standard errors 
    
    % Extract the parameters
    K  = length(Y);
    q = sum(cellfun(@(x) size(x, 2), X));
    N = length(Y{1});
    [~, dims]  = cellfun(@size, X);       
    [logp, b, thetas, betas] = extractParam(param, N,K,  dims);
    %thetas = reshape(cell2mat(thetas), [N, K]);    
    
    % Create empty covariance matrix
    co = zeros(sum(dims));
    %----------------------------------------------------------------------
    % Compute the tilted mean vectors  for every observation
    %----------------------------------------------------------------------
    % Compute the products and sum the results
    thetaY = cellfun(@(x,y) x.*y.', thetas, Y, 'UniformOutput', false);
    thetaYSum = sum(reshape(cell2mat(thetaY), [N,N,K]), 3);
    pexp = exp(logp.' + b + thetaYSum); % N x N
           
    % Multiplication is done across the rows
    ypexp = cellfun(@(y) (y.').* pexp, Y,'UniformOutput', false);
    
    % Means   
    means = cell2mat(cellfun(@(yp) sum(yp,2),...
        ypexp,'UniformOutput', false));  
    
    % Y covariance matrices 
    outerY = cell(1, N);
    y = cell2mat(Y);
    for i = 1:N
        outerY{i} = (y(i,:).' - means(i, :).')*(y(i,:).' - means(i, :).').';
    end
    Ycovs = cell(1,N);
    for i = 1:N        
        t = zeros(size(outerY{1}));
        for j = 1:N
            t = t + pexp(i,j)*outerY{j};
        end
        Ycovs{i} = inv(t);
    end
   
   % Create T matrix for every observation 
   T = cell(1,N);
   for i = 1:N
       blocks = cell(1, K);
       for j = 1:K
           x = X{j};
           x = x(i, :);
           switch links{j}
               case 'id'
                   blocks{j} = x;
               case 'inv'
                   blocks{j} = -(1/(x*betas{j}))^2*x;
               case 'log'
                   mu = exp(x*betas{j});
                   blocks{j} = mu*x;
               case 'logit'
                   mu = exp(x*betas{j})/(1 +exp(x*betas{j})) ;
                   blocks{j} = mu*(1-mu)*x;
           end
       end
       T{i} = blkdiag(blocks{1:end});
   end
   
   for i = 1:N
       co = co + (T{i}.')*Ycovs{i}*T{i};
   end
   
   co = inv(co);  
   
   se = sqrt(diag(co));
    
    
    
end