function vspglmmodel = fit_vspglm(formula, tbl, links)
    % vspglm_mmodel = FIT_VSPGLM(formula, tbl,  links)
    % fits a vector generalized semi-parametric linear model and stores
    % the model output in vspglmmodel
    % the function currently takes 3 arguments,
    % formula, a string array of string formulas 
    % In the formula argument:
    %            (y1, y2) ~ (x1, x3) -> y1 and y2 share all regression
    %            coefficients
    %            (y1, y2) ~ (x1, (x2&0), (0&x3)) 
    %            -> y1 ~ x1 + x2, y2 = x1 + x3
    % Responses can also  have a different number of covariates and still 
    % share regression coefficients. 
    %          (y1, y2, y3) ~ (x1,(x2&x2&0), (0&0&x3))
    % This means that 
    %                y1 ~ 1  + x1  + x2
    %                y2 ~ 1  + x1  + x2
    %                y3 ~ 1  + x1  + x3    
    %
    % Where each variable y1, .., yk, x1, .., xp are columns in 
    % the table argument tbl. 
    % The last argument is then links, a 1 x k cell array of the link
    % functions to be used for each model.
    
    
    %----------------------------------------------------------------------
    % Function Arguments 
    arguments
        formula string
        tbl table
        links (1,:) cell                
    end
    %----------------------------------------------------------------------
    
    % Parse the formulas
    formulas = getFormulas(VSPGLMFormula(formula));
    
    %----------------------------------------------------------------------
    
    
    % Create the design matrices
    Intercept = ones(height(tbl), 1);
    tbl = [table(Intercept), tbl];
    X = cell(1, length(links));
    Y = cell(1, length(links));
    Aeq = {};
    
    % Convert each design matrix to cell arrays
    iter = 1;
    for i = 1:length(formulas)
        for j = 1:length(formulas(i).response)            
            X{iter} = table2array(tbl(:,formulas(i).covariates{j}));
            Y{iter} = table2array(tbl(:,formulas(i).response(j)));  
            iter = iter + 1;
        end
        Aeq{i} = formulas(i).constraint;
    end
    
    % Run vspglm initially
    [maxloglike, params, converged] = vspglm(Y, X, links, Aeq);
    vspglmmodel = struct([]);   
    
    if converged ~= 100
        vspglmmodel(1).converged = 1;
        
        
        % Extract the parameters
        [~, dims] = cellfun(@size, X);
        [logp, b, thetas, betas] = extractParam(params, length(Y{1}),length(X), dims);
        
        % Create the model                
        vspglmmodel(1).loglike = maxloglike;
        [se, co, means, thetas, pexp, Yvar] = vcov(X, Y, params, links, tbl, formulas);
        
        count = 0;
        iter = 1;
        for i = 1:length(formulas)
            Betas = {};
            for j = (iter):( iter - 1 + length(formulas(i).betaConstraints(:, 1)))
                Betas{end + 1} = betas{j};
            end
            
            lengths = cellfun(@length, Betas);
            estimates = Betas{lengths == max(lengths)};            
            StdError = se((count+1):(count + max(lengths)));
            
            
            tValue = estimates./StdError;
            pValue = 2*(1 - tcdf(abs(tValue) ,length(Y{1}) - rank(X{iter})));
            signif = cell(length(pValue),1);
            
            for j = 1:length(signif)
                if pValue(j) > 0.1
                    signif{j} = '  ';
                elseif pValue(j) > 0.05 && pValue(j) <= 0.1
                    signif{j} = '.';
                elseif pValue(j) > 0.01 && pValue(j) <= 0.05
                    signif{j} = '*';
                elseif pValue(j) > 0.001 && pValue(j) <= 0.01
                    signif{j} = '**';
                else
                    signif{j} = '***';
                end
                
            end
            signif = cellstr(signif);           
            
            vspglmmodel(i).responses = formulas(i).response;
            %vspglmmodel(i).link = links{i};
            vspglmmodel(i).coefficients = table(estimates, StdError,tValue, pValue ,signif, ...
                'RowNames',formulas(i).covariates{1});
            count = count + length(estimates);
            iter = iter+ 1;
        end
        
        vspglmmodel(1).varbeta = co;
    else
        vspglmmodel(1).converged = 0;
    end
    vspglmmodel(1).X = X;
    vspglmmodel(1).Y = Y;
    vspglmmodel(1).params = params;
    vspglmmodel(1).means = means;
    vspglmmodel(1).thetas = thetas;
    vspglmmodel(1).pTilt = exp(logp);
    vspglmmodel(1).pTiltMatrix = pexp;
    vspglmmodel(1).yCovariance = Yvar;
   
    
   
end
    
    
    