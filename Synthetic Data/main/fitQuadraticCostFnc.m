function [c_optimal, offset_optimal, minMSE] = fitQuadraticCostFnc(estimatedControlSignals, estimatedCostFunction, c_searchSpace, offset_searchSpace, excludeZeroValues)

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
    
    p = polyfit(estimatedControlSignals,estimatedCostFunction,2);
    
    offset_optimal = p(3);
    c_optimal = p(1);
   

end