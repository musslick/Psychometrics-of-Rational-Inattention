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

controlEfficacy_conditions = repmat(15, 10, 10);
taskAutomaticity_conditions = [-3.0:-0.5:-7.5];
experiment_conditions = 1:length(controlEfficacy_conditions);

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

% Simulation Loop

overwrite = 1;

% generate log file name
logfileName = ['Task_Automaticity_Simulation_'];
                    
filePath = [logFolderName '/' logfileName '.mat'];

if exist(filePath, 'file') == 2  && ~overwrite   % if log file exists load it
    load(filePath);
else                                         % if log file doesn't exist, generate it 

    % for each standard_deviation condition
    for exp_condition = 1:length(experiment_conditions) 

        functionalForm = functionalForms(1);
        
        % set current experiment condition
        controlEfficacy = controlEfficacy_conditions(exp_condition);
        taskAutomaticity = taskAutomaticity_conditions(exp_condition);
        agent.outcomeProbabilityFnc = @(u) 1./(1+exp(-controlEfficacy*u - taskAutomaticity));
        
        experiment_log{exp_condition}.outcome_probabilities = nan(numSubj, length(experiment.rewards));
        experiment_log{exp_condition}.controlEfficacy = controlEfficacy;
        experiment_log{exp_condition}.taskAutomaticity = taskAutomaticity;
        experiment_log{exp_condition}.rewards = experiment.rewards;

        % for each repetition
        for rep = 1:numReps

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
                experiment_log{exp_condition}.outcome_probabilities(subj, :) = outcomeProbabilities;
            end

        end

        disp(['progress: ' num2str(exp_condition) '/' num2str(length(experiment_conditions) )]);

    end
    
    save(filePath);
    
end

% Write CSV File
    
for exp_condition = 1:length(experiment_conditions)
    
    accuracies = mean(experiment_log{exp_condition}.outcome_probabilities);
    rewards = experiment_log{exp_condition}.rewards;
    controlEfficacy = experiment_log{exp_condition}.controlEfficacy;
    taskAutomaticity = experiment_log{exp_condition}.taskAutomaticity;
    
    n_rewards = length(rewards);
    
    data = [accuracies' (1-accuracies)' experiment.rewards' repmat(controlEfficacy, n_rewards, 1) repmat(taskAutomaticity, n_rewards, 1)];
    T = array2table(data);
    T.Properties.VariableNames(1:5) = {'a_correct','a_incorrect','reward','control_efficacy', 'task_automaticity'};
    csv_filename = [logFolderName '/' logfileName  '_' num2str(exp_condition) '.csv'];
    writetable(T,csv_filename);
end

% PLOT

cmap = jet(length(experiment_conditions));

figure(1);
for exp_condition = 1:length(experiment_conditions)
    
    accuracies = mean(experiment_log{exp_condition}.outcome_probabilities);
    rewards = experiment_log{exp_condition}.rewards;
    
    plot(rewards, accuracies, 'Color', cmap(exp_condition, :)); hold on;
    
    
end
hold off;


