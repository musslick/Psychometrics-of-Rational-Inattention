% EVC Model Data Generation
%
%
%

clear all;
clc;

addpath('main');

%%% META PARAMETERS
logFolderName = 'logfiles';

numSubj = 100;                      % number of subjects
numFncFormConditions = 1;       % number of standard deviation conditions
numReps = 1;                     % number of simulation repetitions per standard deviation conditions

std_range = [0 0];                  % range of tested standard deviations
control_cost_range = [1 4];    % range of tested control cost values

functionalForms = [1];  % 1 - exponential, 2 - quadratic, 3 -  linear
functionalForm_labels = {'exponential', 'quadratic', 'linear'};
control_cost_values = linspace(control_cost_range(1), control_cost_range(2), numSubj);

%%% DEFINE DEFAULT AGENT

% parameters
default_controlCost = 1;
default_taskAutomaticity = -7.5;
default_controlEfficacy = 15;
default_accuracyBias = 0;
default_rewardSensitivity = 1;

% define space of control signals
agent.controlSignalSpace = 0:0.01:1;

% define cost functions for all subjects
agent.costFnc = @(u) exp(default_controlCost * u) - 1;

% define outcome probability function for both subjects
agent.outcomeProbabilityFnc = @(u) 1./(1+exp(-default_controlEfficacy*u - default_taskAutomaticity));

% define value function
agent.valueFnc = @(u) default_rewardSensitivity * u + default_accuracyBias;

%%% EXPERIMENT & FIT PROCEDURE

% set up reward manipulations
experiment.rewards = 0:1:10;

%% Simulation Loop

overwrite = 1;

% generate log file name
logfileName = ['EVC_Model_Data_' ...
                        num2str(control_cost_range(1)*100) '_' num2str(control_cost_range(end)*100) '_'...
                        num2str(numReps) '_' ...
                        num2str(numSubj)];
                    
filePath = [logFolderName '/' logfileName '.mat'];

if exist(filePath, 'file') == 2  && ~overwrite   % if log file exists load it
    load(filePath);
else                                         % if log file doesn't exist, generate it 

    % for each standard_deviation condition
    for ff_cond_idx = 1:length(functionalForms) 

        functionalForm = functionalForms(ff_cond_idx);

        % for each repetition
        for rep = 1:numReps
            
            outcomeProbabilities_Log = nan(numSubj, length(experiment.rewards));

            % for each subject
            for subj = 1:numSubj

                % pick control cost value
                c = control_cost_values(subj);
                
                switch functionalForm
                    
                    case 1 % expnential
                        agent.costFnc = @(u) exp(c * u) - 1;
                    case 2 % quadratic
                        agent.costFnc = @(u) c * u.^2;
                    case 3 % linear
                        agent.costFnc = @(u) c * u;
                end

                % define space of control signals
                controlSignalSpace = agent.controlSignalSpace;

                % define cost functions for subject
                costFnc = agent.costFnc;

                % define outcome probability function for subject
                outcomeProbabilityFnc = agent.outcomeProbabilityFnc;

                % define value function
                valueFnc = agent.valueFnc;

                %%% EXPERIMENT

                % set up reward manipulations
                rewards = experiment.rewards;

                % submit EVC agent to experiment (generate outcome probabilities from reward manipulations)
                [outcomeProbabilities] = runEVCAgent(controlSignalSpace, outcomeProbabilityFnc, valueFnc, costFnc, rewards);
                outcomeProbabilities_Log(subj, :) = outcomeProbabilities;
            end

        end

        disp(['progress: ' num2str(ff_cond_idx) '/' num2str(length(functionalForms) )]);

    end
    
    save(filePath);
    
end

% Write CSV File
    
accuracies = mean(outcomeProbabilities_Log)';
data = [accuracies (1-accuracies) experiment.rewards'];
T = array2table(data);
T.Properties.VariableNames(1:3) = {'a_correct','a_incorrect','reward'};
csv_filename = [logFolderName '/' logfileName '.csv'];
writetable(T,csv_filename);

