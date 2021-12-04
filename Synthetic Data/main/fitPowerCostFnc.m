function [c_optimal, offset_optimal, minMSE] = fitPowerCostFnc(estimatedControlSignals, estimatedCostFunction, c_searchSpace, offset_searchSpace, excludeZeroValues)

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
    
    % minimize MSE between fit & data
    for i = 1:length(c_searchSpace)
        
        % set current c
        c  = c_searchSpace(i);
        
        for j = 1:length(offset_searchSpace)
            
            % set current offset
            offset = offset_searchSpace(j);
            
            % compute MSE
            predictedCostFunction = (1 + estimatedControlSignals).^c + offset;
            MSE_log(i, j) = mean((predictedCostFunction - estimatedCostFunction).^2);
        end
        
        
    end
    
    % find optimal fit
    [minMSE, minIndex] = min(MSE_log(:));
    [row, col] = ind2sub(size(MSE_log), minIndex);
    
    c_optimal = c_searchSpace(row);
    offset_optimal = offset_searchSpace(col);
    
    if(c_optimal == min(c_searchSpace) || c_optimal == max(c_searchSpace))
        warning(['Reached limit of search space for c parameter: ' num2str(c_optimal)]);
    end
    
    if(enableOffsetWarning && (offset_optimal == min(offset_searchSpace) || offset_optimal == max(offset_searchSpace)))
        warning(['Reached limit of search space for offset parameter: ' num2str(offset_optimal)]);
    end

end