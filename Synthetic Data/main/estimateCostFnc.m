function [estimatedCostFunction, optimalControlSignal] = estimateCostFnc(assumedControlSignalSpace, assumedOutcomeProbabilityFnc, assumedValueFnc, outcomeProbabilities, rewards)
% ESTIMATECOSTFNC  Estimates the cost function for a given agent based on
% EVC theory. 
%
% Required arguments:
% 
%   assumedControlSignalSpace           ... 1xM vector lists all possible control signal intensities in order
%   assumedOutcomeProbabilityFnc     ...a function handle that computes the outcome probability for a given control signal intensity
%   assumedValueFnc                           ... a function handle that computes the (subjective) value for a given reward condition
%   outcomeProbabilities                      ... 1xN vector that lists the mean outcome probailities for all N experiment conditions 
%   rewards                                           ... 1xN vector that lists the rewards for all N experiment conditions
%   
% Return values:
%   estimatedCostFunction                   ...an estimate of the cost function defined over assumedControlSignalSpace
% 
% Author: Sebastian Musslick

    % compute derivative of assumed outcome probability function
    d_assumedOutcomeProbabilityFnc_tmp = diff(assumedOutcomeProbabilityFnc(assumedControlSignalSpace));
    
    % interpolate derivatives to map onto original scale
    d_assumedOutcomeProbabilityFnc = nan(1, length(assumedControlSignalSpace));
    d_assumedOutcomeProbabilityFnc(1) = d_assumedOutcomeProbabilityFnc_tmp(1);
    d_assumedOutcomeProbabilityFnc(end) = d_assumedOutcomeProbabilityFnc_tmp(end);
    for i = 2:(length(d_assumedOutcomeProbabilityFnc)-1)
        d_assumedOutcomeProbabilityFnc(i) = mean([d_assumedOutcomeProbabilityFnc_tmp(i-1) ...
                                                                                d_assumedOutcomeProbabilityFnc_tmp(i)]);
    end
    
    % compute values for each reward condition
    values = assumedValueFnc(rewards);

    % initialize estimation
    optimalControlSignal = nan(1, length(values));          % stores assumed optimal control values for a given condition

    % iterate over all reward condiitons
    for condition = 1:length(values)
        
        value = values(condition);

        % retrieve the control signal that matches the performance for a given condition
        p_diff = abs(assumedOutcomeProbabilityFnc(assumedControlSignalSpace) - outcomeProbabilities(condition));
        optimalControlSignal(condition) = assumedControlSignalSpace(p_diff == min(p_diff));

    end
    
    % get control signal spacing
    [~,optimalControlSignalSteps] = ismember(optimalControlSignal,assumedControlSignalSpace); 
    
    % compute derivative of cost function based on derivative of outcome
    % probability for a given condition and corresponding value
    d_estimatedCostFunction = d_assumedOutcomeProbabilityFnc(optimalControlSignalSteps) .* values;

    % integrate cost function
    estimatedCostFunction = cumtrapz(optimalControlSignalSteps, d_estimatedCostFunction);
    
end