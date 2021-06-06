function [se, co, means, thetas, pexp, Yvar] = vcov(X, Y, param, links, tbl,formulas)
    % [se, co] = vcov(X, Y, param, links)
    % takes as arguments a 1 x K cell array of design matrices X
    % a 1 x K cell array of response variables Y, a 
    % (K + 2)N + Q length vector of parameters param and a 
    % 1 x K cell array of links
    % and outputs a 1 x Q length vector se of standard errors
    % and co a Q x Q estimated inverse fisher information matrix,
    %----------------------------------------------------------------------
    
    % Extract the parameters
    K  = length(Y);
    q = sum(cellfun(@(x) size(x, 2), X));
    N = length(Y{1});
    [~, dims]  = cellfun(@size, X);       
    [logp, b, thetas, betas] = extractParam(param, N,K,  dims);
    
    
    %----------------------------------------------------------------------
    % Rescale the ys
    minMax = cell(1, length(dims));    
    for i = 1:K
        m = min(Y{i});
        M = max(Y{i});
        Y{i} = (Y{i} - (m + M)/2)*(2/(M-m));
        minMax{i} = [m, M];
    end
    %----------------------------------------------------------------------
    
    
    
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
    Yvar = cell(1, N);
    lambdas  = zeros(K, N);
    for i = 1:N        
        t = zeros(size(outerY{1}));
        for j = 1:N
            t = t + pexp(i,j)*outerY{j};
        end
        Yvar{i} = t;  
        d = eig(t);
        assert(all(d >=0), "Not PSD");        
        lambdas(:, i) = d;        
    end
   
    % Add the regularisation to each Yvar and invert
    for i = 1:N              
        Ycovs{i} = pinv(Yvar{i});
    end
   
   tbl = [tbl,  array2table(zeros(N, 1), 'VariableNames', {'0'})];
   
   % Create T matrix for every observation 
   T = cell(1,N); 
   
    
   
   for i = 1:N
       blocks = cell(1, length(formulas));      
       iter = 1;
       for k = 1:length(formulas)
           betaConstraints = formulas(k).betaConstraints;
           Betas = {};
           for l = iter:(iter + size(betaConstraints, 1)-1)
               Betas{l - iter + 1} = betas{l};
           end           
           lengths = cellfun(@length, Betas);
           beta = Betas{lengths == max(lengths)};
           block = zeros(size(betaConstraints));
           for j = 1:size(betaConstraints, 1)
               row = table2array(tbl(i,betaConstraints(j,:)));
               minmax = minMax{iter};
               [m, M] = deal(minmax(1),minmax(2));
               
               switch links{j}
                   case 'id'
                       block(j, :) = row;
                   case 'inv'
                       block(j, :)  = -(1/(row*beta))^2*row;
                   case 'log'
                       mu = exp(row*beta);
                       block(j, :)  = mu*row;
                   case 'logit'
                       mu = exp(row*beta)/(1 +exp(row*beta)) ;
                       block(j, :)  = mu*(1-mu)*row;
               end
               block(j, :) = block(j,  :)*2/(M-m);
               iter = iter+1;
           end
           blocks{k} = block;
       end
       
       T{i} = blkdiag(blocks{1:end});
   end
   
   % Create empty covariance matrix
   co = zeros(size((T{1}.')*T{1}));
   for i = 1:N
       co = co + (T{i}.')*Ycovs{i}*T{i};
   end
   
   co = pinv(co);  
   
   se = sqrt(diag(co));
   if length(formulas) ~= length(links)
        se = se;
   end
   
   for k = 1:K
       minmax = minMax{k};
       [m, M] = deal(minmax(1),minmax(2));
       thetas{k} = thetas{k}*(2/(M - m));
       means(:, k) = means(:, k)*((M - m)/2) + (M  +m)/2;
   end    
end