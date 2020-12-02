function model = fit_vspglm(Y,X,links,cons)
    % TODO: Add documentation
    
    
    %----------------------------------------------------------------------
    % Fit models
    %----------------------------------------------------------------------
     fprintf("Running VSPGLM: \n")
     tic
     
     % Unconstrained model
     % Add intercept and create simple model
     K = length(X);
     
     x0 = cell(1, K);   
     tableNames = cell(1, K);
     responseNames = cell(1, K);
     for i  = 1:K 
         if istable(X{i})
             x = X{i};
             tableNames{i} = char(x.Properties.VariableNames);
             X{i} = table2array(X{i});             
         end
         if istable(Y{i})
             y = Y{i};
             responseNames{i} = char(y.Properties.VariableNames);
             Y{i} = table2array(Y{i});
         end
         x0{i} = ones(size(X{i}, 1), 1);
         X{i} = [ones(size(X{i}, 1), 1), X{i}];
     end
     if exist('cons', 'var')
         [betas, maxLogLike, phat, iter] = vspglm(Y, X, links, cons);
     
         % Constant model
         [betas0, maxLogLike0, phat0, iter0] = vspglm(Y, x0, links, cons);  
     else
           cons = " ";
          [betas, maxLogLike, phat, iter] = vspglm(Y, X, links);
     
         % Constant model
         [betas0, maxLogLike0, phat0, iter0] = vspglm(Y, x0, links);  
     end        
         
    
     fprintf("VSPGLM converged in %.3f seconds \n", toc) 
     
    
     N = length(Y{1});
     pm = sum(arrayfun(@(i) length(betas{i}), 1:length(betas)));
     pc = sum(arrayfun(@(i) length(betas0{i}), 1:length(betas0)));
     lstat = 2*(maxLogLike - maxLogLike0);
     pval = fcdf(lstat, pm-pc, N-pm, 'upper');
    
    
    
    %----------------------------------------------------------------------
    % Print Summary
    %----------------------------------------------------------------------
    
    printVSPGLM(N,K,iter, links, betas, maxLogLike, cons, lstat, pval, tableNames,responseNames)
    
    %----------------------------------------------------------------------
    % Return model object
    %----------------------------------------------------------------------
    for i = 1:length(betas)
        model(i).model = i;
        model(i).covariateNames = tableNames{i};
        model(i).betas = betas{i};
        model(i).link = links{i};   
       
    end
    
    
end

%--------------------------------------------------------------------------
function printVSPGLM(N,K,iter, links, betas, maxLogLike, cons, fstat, pval, tableNames, responseNames)
    fprintf("\n\n\n Semi-Parametric Vector Generalized Linear Regression Model: \n \n");
    fprintf("         fmincon converged in %d iterations. \n", iter);
    switch cons
        case "equal"
            fprintf("         Linear Predictors are constrained to be equal. \n \n");
        case "symmetric" 
            fprintf("         Linear Predictors are constrained to be symmetric.\n \n");
        otherwise
            fprintf("         Linear Predictors are unconstrained. \n \n");
    end
    
    for i  = 1:length(links)
        names = tableNames{i};
        switch cons
            case "symmetric"
                if i == 1
                    ynames = responseNames{i};
                else
                    ynames = responseNames{end};
                end
            otherwise
                ynames = responseNames{i};
        end
        if isempty(ynames)
            ynames = "y";
        end
        fprintf("         Model %d: \n", i)
        switch links{i}
            case "id"
                l = sprintf("%s ~ ", ynames);
            case "inv"
                l = sprintf("1/%s ~ ", ynames);
            case "log"
                l = sprintf("log(%s) ~ ", ynames);
            case "logit"
                l = sprintf("log(%s) - log(1-%s) ~ ", ynames,ynames);
        end
        for j = 1:length(betas{i})            
            
            if j > 1
                if ~isempty(names)
                    l = l + sprintf("+ %s", names(j-1, :));
                else
                    l = l + sprintf("+ x%d ", j-1);
                end
            else
                l = l + sprintf("%d ", j);
            end          
                
        end
        fprintf("               %s \n ", l);
        fprintf("              Link = %s \n ", links{i});
    end
    fprintf("\n");   
    
    
    fprintf("Estimated Coefficients: \n")
    for i  = 1:length(links)
        switch cons
            case "symmetric"
                if i == 1
                    ynames = responseNames{i};
                else
                    ynames = responseNames{end};
                end
            otherwise
                ynames = responseNames{i};
        end
        if isempty(ynames)
            ynames = "y";
        end
        fprintf("         Model %d:  Response: %s \n", i, ynames)
        % Create a table
        Estimates = betas{i};
        
        names = tableNames{i};
        if ~isempty(names)
            rowNames = ["(intercept)"; names];
        else
            rowNames = ["(intercept)"; arrayfun(@(i) sprintf("x%d", i),...
                (1:(length(Estimates)-1)).')];
        end
        etable = table(Estimates, 'RowNames', rowNames);
        disp(etable)
        fprintf("\n");  
    end
    fprintf("Number of Observations: %d \n", N*K)
    fprintf("Degrees of Freedom: %d \n",...
        N*K - sum(arrayfun(@(i) length(betas{i}), 1:length(betas))));
    fprintf("Log-Likelihood: %f \n", maxLogLike);
    fprintf("GLRT-Statistic vs constant model: %f , P-value:%f", fstat, pval);
    
    
    
    fprintf("\n\n");
    
    
end