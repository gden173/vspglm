classdef VSPGLMFormula
    % Creates a VSPGLMFormula object to be used in
    % the fit_vspglm function.
    %
    % Usage:
    %        VSPGLMFormula(formulas)
    % Where formulas is a cell array containing strings 
    % containing the formulas and constraints
    % for each marginal VSGPLM model.
    %
    % The structure of formula is as follows:
    % For independent models y1, ..., yk
    %   ["y1 ~(covariates)",  ... ,  "yk ~(covariates)"]
    % Where covariates is a comma separated list e.g. (x1,x2,x3,.., xq)
    % For shared regression coefficients
    %   ["(y1, y2) ~ (covariates), ..., "yk ~(covariates)"]
    % For some shared regression coefficients but different covariate names
    %   ["(y1, y2) ~ ((x1 & x2), ...)",  ... "yk ~(covariates)"]
    % For shared regression coefficients and different and a different
    % number of covariates put a zero
    %   ["(y1, y2) ~ (x1, x2, (x3&x4), (0 & x5))",..., "yk ~(covariates)" ]  
    
    properties
        formulas string
    end
    
    methods
        function obj = VSPGLMFormula(formulas)
            obj.formulas = formulas;
        end
        function vals = getFormulas(obj)
            % vals = GETFORMULA(obj)
            % class method which take in the formula object and 
            % Returns a structure containing all response variables
            % covariates and constraints for the VSPGLM formual
            % Structure of the vals will be 
            %
            % For non independent models
            % vals(i).responses = {"y1", ..."yk"};
            % vals(i).covariates = {["x1",.."xp"],... }
            % vals(i).constraints 
            % 
             
            
            % Struct to place all formulas into
            vals = struct([]);
            
            % Loop through the string array
            for i = 1:length(obj.formulas)
                
                % Extract the formula 
                str = obj.formulas(i); 
                
                % Extract the string formula
                % Split the formula on ~. xy_split should now be a 
                % string array of length 2, which has the y variables in 
                % the first location and the x variables in the second
                % location
                xy_split = split(str, '~'); 
                ys = regexprep(split(xy_split(1), ','), '\s', '');
                ys = regexprep(ys, '[()]', '');
                xs = regexprep(split(xy_split(2), ','), '\s', ''); 
                
                % Get the number of response variables K
                K = length(ys);
                
                % Break apart the x variables and creat the constraint
                % matrix
                if K > 1
                    
                    % Cell array of constrained pairs
                    constrainedPairs = {};
                    
                    % Save response variables
                    vals(i).response = ys;
                    
                    % Add intercepts to the covariates and 
                    % remove all parenthisis 
                    xs = ["Intercept", regexprep(xs, '[()]', '').'];
                    
                    % Create a covariates cell array
                    covariates = cell(1, K);                   
                   
                    
                    % Loop through the covariates and allocate to the
                    % apropriate array
                    % Empty string array for preallocation
                    str = strings(K, length(xs));       
                    
                                    
                
                    % Loop through the covariates
                    for j = 1:length(xs)
                        x = regexp(xs(j) , '[&]', 'split');
                        str(:, j) = regexprep(x, '\s', '');
                        id = ~strcmp(str(:, j), "0");
                        constrainedNames = strcat(ys(id), str(id, j));
                        for l = 1:(length(constrainedNames)-1)
                            constrainedPairs{end + 1} = [constrainedNames(l), constrainedNames(l+1)];                           
                        end
                    end
                    
                    
                    % Beta constraints
                    betaConstraints = str;
%                     for k = 1:K
%                         strcopy = str;
%                         names = str(k, :);
%                         strcopy(:, strcmp(names, "0")) = "0";
%                         betaConstraints(k, :) = reshape(strcopy.', [1, numel(strcopy)]);
%                     end
                    
                    % Loop through covariates and assign non 0 covariates
                    % to the cell array 
                    for k = 1:K
                        nonZero = ~strcmp(str(k, :), "0");
                        covariates{k} = str(k, nonZero);
                    end                
                    
                    % Assign the covariates output
                    vals(i).covariates = covariates;                    
                    
                    % Create constraint matrices                    
                    names = strcat(ys(1), vals(i).covariates{1});
                    for j = 2:length(ys)
                        names = [names, strcat(ys(j),  vals(i).covariates{j})];
                    end
                    
                    constraintMatrix = array2table(zeros(length(names)),...
                                              'VariableNames', names,...
                                                 'RowNames',names.');
                    for j = 1:length(constrainedPairs)     
                        pair = constrainedPairs{j};
                        constraintMatrix(pair,pair) = array2table([1, -1;0, 0]);
                    end
                    vals(i).constraint = table2array(constraintMatrix);
                    vals(i).betaConstraints = betaConstraints;
                else
                    % Independent model:
                    % Only one response variable
                    xs = regexprep(xs, '[()]', '');
                    vals(i).response = ys;
                    vals(i).covariates = {["Intercept", xs.']};
                    % Zero matrix
                    vals(i).constraint = zeros(length(xs) + 1);
                    vals(i).betaConstraints = ["Intercept", xs.'];
                end                             
            end                              
        end
    end
end










