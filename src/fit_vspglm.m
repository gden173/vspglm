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
    [maxloglike, params] = vspglm(Y, X, links);
    
    % Extract the parameters
    [~, dims] = cellfun(@size, X);
    [~, ~, ~, betas] = extractParam(params, length(Y{1}),length(X), dims);
    
    % Create the model
    vspglm_model = struct([]);
    vspglm_model(1).loglike = maxloglike;
    for i = 1:length(betas)
        estimates = betas{i};     
        glrts = zeros(length(estimates), 1);
        pval = glrts;
        for j = 2:length(estimates)
            x = X; d = X{i};
            x{i} = d(:, [(1:(j-1)) (j  +1):end]);      
            if j == 1
                [maxloglikeT, paramsT] = vspglm(Y, x, links, 'param', []); 
            else
                [maxloglikeT, paramsT] = vspglm(Y, x, links); 
            end              
            glrts(j) = 2*(maxloglike - maxloglikeT);
            pval(j) = chi2cdf(glrts(j), 1, 'upper');
            
        end
        %vspglm_model(i).formula = [formulas(i).response, "~ (",formulas(i).variables{:}, ")"];
        vspglm_model(i).link = links{i};
        vspglm_model(i).coefficients = table(estimates, glrts, pval,...
            'RowNames',cellstr(["intercept", formulas(i).variables]));
        
    end
    
    
   
end
    
    
    