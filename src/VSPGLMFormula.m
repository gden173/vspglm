classdef VSPGLMFormula
    % Creates a Formula object to be used in 
    % the fit_vspglm function 
    properties
        formulas string
    end    
    
    methods
        function obj = VSPGLMFormula(formulas)
            obj.formulas = formulas;
        end
        function vals = getFormulas(obj)
            
            % Struct to place all formulas into 
            vals = struct([]);
            
            % Split the formulas on | bars
            str = obj.formulas;
            str = regexprep(str, '[()]', '');
            split_str = split(str, "|");           
           
            
            for j = 1:length(split_str)
                strs = strtrim(split(split_str(j), "~"));
                % Loop through
                ys = strtrim(split(strs(1), ","));
                for i = 1:length(ys)
                    vals(i + j -1).response = ys(i);
                    vals(i  +j - 1).variables = cellstr(strtrim(split(strs(2), ",")).');
                end                
            end         
          
            
        end
    end
end
