function [goodnessOfFit, c_diff] = computeGoodnessOfFit(c_data, offset_data, sample_data, measureOfFit)
% RUNESTIMATIONEXPERIMENT  Runs an experiment to estimate the control cost
% function for two simulated agents
%
% Required arguments:
% 
%  c_data                          ...structure that contains information about true and estimated c parameters for both subjects
%  offset_data                   ...structure that contains information about true and estimated offset parameters for both subjects
%  sample_data                 ...structure that contains information about estimated cost samples for both subjects
% measureOfFit                ...the measure used to quantify the fit. Options are:
%                                          'c_difference'            ...difference between the difference of the c parameters for both subjects
%                                          'offset_difference'     ...difference between the difference of the offset parameters for both subjects
%                                          'AUC'                        ...difference between the difference of the area under the cost curve for both subjects
%
% Outputs:
%
%  c1_hat, c2_hat                                                               ... c parameter estimates for the two subjects
%  offset1_hat, offset2_hat                                                ... offset paremter estimates for the two subjects
%  estimatedCostFunction1, estimatedCostFunction2       ... cost function estimates for the two subjects (samples from reward experiment)
%  estimatedControlSignals1. estimatedControlSignals2   ... control signal samples that correspond to the cost function estimates for the two subjects
%
% Author: Sebastian Musslick

c1 = c_data.c1;
c2 = c_data.c2;
c1_hat = c_data.c1_hat;
c2_hat = c_data.c2_hat;

offset1 = offset_data.offset1;
offset2 = offset_data.offset2;
offset1_hat = offset_data.offset1_hat;
offset2_hat = offset_data.offset2_hat;


estimatedCostFunction1 = sample_data.estimatedCostFunction1;
estimatedCostFunction2 = sample_data.estimatedCostFunction2;
estimatedControlSignals1 = sample_data.estimatedControlSignals1;
estimatedControlSignals2 = sample_data.estimatedControlSignals2;

c_diff = c2_hat - c1_hat;

goodnessOfFit = NaN;

switch measureOfFit
    
    case 'c_difference'
        
        goodnessOfFit = (c2-c1) - (c2_hat-c1_hat);
        
    case 'offset_difference'
        
        goodnessOfFit = (offset2-offset1) - (offset2_hat-offset1_hat);
        
    case 'AUC'
        
        goodnessOfFit = cumsum(exp(c2.* controlSignalSpace) - exp(c1.*controlSignalSpace) + offset2 - offset1) ...
                - cumsum(exp(c2_hat.* controlSignalSpace) - exp(c1_hat.*controlSignalSpace) + offset2_hat - offset1_hat);
            
    case 'MSE'
        
        goodnessOfFit = ((c1-c1_hat)^2 + (c2-c2_hat)^2)/2;
        
    case 'delta_c_hat'
        
        goodnessOfFit = c_diff;
            
    otherwise
        warning('Selected measureOfFit is not supported. Variable goodnessOfFit will be assigned to NaN.');
        
end
    
end