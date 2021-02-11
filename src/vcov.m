function [se, r, co] = vcov(X, Y, param, links)
    % Calculates the standard errors 
    
    % Extract the parameters
    K  = length(Y);
    N = length(Y{1});
    [~, dims]  = cellfun(@size, X);       
    [logp, b, thetas, ~] = extractParam(param, N,K,  dims);
    thetas = reshape(cell2mat(thetas), [N, K]);        
   
    % Just create the diagonal matrix for the moment
    diagCov = cell(length(links));
    y = cell2mat(Y);
    for i = 1:K
        
        x = X{i};
        % Loop through observastions 
        bprime = zeros(N, 1);
        bprime2 = zeros(N, 1);
        g = zeros(N, 1);
        for j = 1:N
            pexp = exp(logp).*exp(sum(thetas(j,:).*y, 2));            
            bprime(j) = sum(y(:, i).*pexp)/sum(pexp);
            bprime2(j) = sum((y(:, i) - bprime(j)).^2.*exp(logp).*exp(sum(thetas(j,:).*y + b(j), 2)));
            switch links{i}
                case 'id'
                    g(j) = 1;
                case 'log'
                    g(j) = 1/bprime(j);
                case 'inv'
                    g(j) = -1/bprime(j)^2;
                case 'logit'
                    g(j) = 1/(bprime(j) * (1-bprime(j)));
            end
        end
        diagCov{i} = (x.')*diag(1./(g.^2.*bprime2))*x;
        
    end
    fish = blkdiag(diagCov{1:end});
    
    if any(isnan(fish(:))) || any(isinf(fish(:)))
        co = zeros(size(fish));
        r = rank(co);
        se = sqrt((diag(co)));
        disp("Variance Covariance Matrix has not been calculated")
    else
        co = pinv(fish);
        r = rank(co);
        se = sqrt((diag(co)));
    end
    
end