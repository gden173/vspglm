function vspglm_model = fit_vspglm(formula, tbl, links)
    % vspglm_model = fit_vspglm(formula, tbl, links) 
    % fits a vector generalized semi-parametric linear model and stores
    % the model output in vspglm_model
    % the function currently takes 3 arguments,
    % formula, a string formula which has the format 
    %       One Response: "y ~ (x1, x2, ..., xp)"
    %       Multiple Responses: "(y1,y2) ~ (x1, x3) | y3 ~ x2"
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
    
    % Create the design matrices
    intercept = ones(height(tbl), 1);
    int = table(intercept);
    X = cell(1, length(formulas));
    Y = cell(1, length(formulas));
    
    for i = 1:length(formulas)
        X{i} = table2array([int tbl(:,formulas(i).variables)]);
        Y{i} = table2array(tbl(:,formulas(i).response));
    end
    
    % Run vspglm initially
    [maxloglike, params, converged] = vspglm(Y, X, links);
    vspglm_model = struct([]);
    if converged == 1
        vspglm_model(1).converged = 1;
        % Extract the parameters
        [~, dims] = cellfun(@size, X);
        [~, ~, ~, betas] = extractParam(params, length(Y{1}),length(X), dims);
        
        % Create the model        
        vspglm_model(1).loglike = maxloglike;
        [se, r, co] = vcov(X, Y, params, links);
        
        for i = 1:length(betas)
            estimates = betas{i};
            if i == 1
                StdError = se(1:dims(1));
            else
                cdims = cumsum(dims);
                StdError = se((cdims(i-1) + 1):cdims(i));
            end
            tValue = abs(estimates./StdError);
            pValue = 2*(1 - tcdf(tValue ,length(Y{1})*length(betas) - r));
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
            
            
            vspglm_model(i).link = links{i};
            vspglm_model(i).coefficients = table(estimates, StdError,tValue, pValue ,signif, ...
                'RowNames',cellstr(["intercept", formulas(i).variables]));
            
        end
        vspglm_model(1).varbeta = co;
    else
        vspglm_model(1).converged = 0;
    end
    
   
end
    
    
    