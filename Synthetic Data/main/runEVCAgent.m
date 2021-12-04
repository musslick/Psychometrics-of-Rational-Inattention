function [outcomeProbabilities, optimalControlSignals, EVCMap, maxEVC] = runEVCAgent(controlSignalSpace, outcomeProbabilityFnc, valueFnc, costFnc, rewards)
% RUNEVCAGENT Simulates an EVC agent that generates data (outcome
% probabilities) for a set of rewards in a two-alternative choice experiment. 
% 
%
% Required arguments:
% 
%   assumedControlSignalSpace           ... 1xM vector lists all possible control signal intensities in order
%   outcomeProbabilityFnc                   ...a function handle that computes the outcome probability for a given control signal intensity
%   valueFnc                                          ... a function handle that computes the (subjective) value for a given reward condition
%   costFnc                                         ... a function handle that computes the cost of control for a given control signal intensity
%   rewards                                           ... 1xN vector that lists the rewards for all N experiment conditions
%   
% Return values:
%   outcomeProbabilities                      ... 1xN vector that stores the mean outcome probailities for all N experiment conditions 
%   optimalControlSignals                    ... 1xN vector that stores the optimal control signals for all N experiment conditions 
% 
% Author: Sebastian Musslick

    % define EVC function
    EVCFnc = @(u,v) outcomeProbabilityFnc(u).*valueFnc(v) - costFnc(u);

    % initialize estimation
    EVCMap = nan(length(rewards), length(controlSignalSpace));          % stores outcome probability for a given reward condition
    maxEVC = nan(1, length(rewards));                                                 % maximum EVC fr a given reward condition
    optimalControlSignals = nan(1, length(rewards));                           % stores optimal control values for a given reward condition
    outcomeProbabilities = nan(1, length(rewards));                              % stores outcome probability for a given reward condition

    % iterate over all reward condiitons
    for condition = 1:length(rewards)
        
        reward = rewards(condition);
        
        % compute optimal control signal according to EVC
        optimalControlSignals(condition) = controlSignalSpace(EVCFnc(controlSignalSpace, reward) == max(EVCFnc(controlSignalSpace, reward)));
        
        % log EVC landscape and maximal EVC
        EVCMap(condition, :) = EVCFnc(controlSignalSpace, reward);
        maxEVC(condition) = max(EVCFnc(controlSignalSpace, reward));
        
        % compute performance for optimal control signal
        outcomeProbabilities(condition) = outcomeProbabilityFnc(optimalControlSignals(condition));
        
    end
    
end