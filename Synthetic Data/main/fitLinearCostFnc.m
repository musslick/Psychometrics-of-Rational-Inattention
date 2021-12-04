function [c_optimal, offset_optimal, minMSE] = fitLinearCostFnc(estimatedControlSignals, estimatedCostFunction, c_searchSpace, offset_searchSpace, excludeZeroValues)

    % return of no valid samples could be obtained
    if(~any(estimatedControlSignals ~= 0))
        c_optimal = NaN;
        offset_optimal = NaN;
        minMSE = NaN;
        return;
    end
    
    % initial cost offset parameter
    if (~exist('offset_searchSpace', 'var'))
        offset_searchSpace = -1;
        enableOffsetWarning = 0;
    else
        enableOffsetWarning = 1;
    end
    
    % exclude conditions in which the control signal intensity 
    % was estimated to be 0 (this will avoid distortions due to offset)
    if (~exist('excludeZeroValues', 'var'))
        excludeZeroValues = 1;
    end
    
    if(excludeZeroValues) 
        removeIdx = find(estimatedControlSignals == 0);
        estimatedControlSignals(removeIdx) = [];
        estimatedCostFunction(removeIdx) = [];
    end
    
    X = estimatedControlSignals;
    Y = estimatedCostFunction;
    lm = fitlm(X,Y,'linear');
    offset_optimal = lm.Coefficients.Estimate(1);
    c_optimal= lm.Coefficients.Estimate(2);
    

end