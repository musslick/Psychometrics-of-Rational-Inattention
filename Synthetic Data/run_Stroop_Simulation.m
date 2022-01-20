function run_Stroop_Simulation(agent, experiment, traits, congruency, logfilename)

numReps = 1;
numSubj = traits.N;

%%% META PARAMETERS
logFolderName = 'logfiles';

% Simulation Loop

overwrite = 1;

% generate log file name
logfileName = [logfilename];
                    
filePath = [logFolderName '/' logfileName '.mat'];

if exist(filePath, 'file') == 2  && ~overwrite   % if log file exists load it
    load(filePath);
else                                         % if log file doesn't exist, generate it 

    % for each standard_deviation condition
    for current_subject = 1:numSubj
        
        % set current experiment condition
        controlEfficacy = traits.controlEfficacy(current_subject);
        taskAutomaticity = traits.taskAutomaticity(current_subject);
        controlCost = traits.controlCost(current_subject);
        
        agent.costFnc = @(u) exp(controlCost * u) - 1;
        
        experiment_log{current_subject}.congruent_outcome_probabilities = nan(1, length(experiment.rewards));
        experiment_log{current_subject}.incongruent_outcome_probabilities = nan(1, length(experiment.rewards));
        experiment_log{current_subject}.controlEfficacy = controlEfficacy;
        experiment_log{current_subject}.taskAutomaticity = taskAutomaticity;
        experiment_log{current_subject}.controlCost = controlCost;
        experiment_log{current_subject}.rewards = experiment.rewards;

        % for each repetition
        for rep = 1:numReps

            % define space of control signals
            controlSignalSpace = agent.controlSignalSpace;

            % define cost functions for subject
            costFnc = agent.costFnc;

            % define value function
            valueFnc = agent.valueFnc;

            %%% EXPERIMENT

            % set up reward manipulations
            rewards = experiment.rewards;
            
            % CONGRUENT
            
            % define outcome probability function for subject
            agent.outcomeProbabilityFnc = @(u) 1./(1+exp(-controlEfficacy*u - (taskAutomaticity + congruency)));
            outcomeProbabilityFnc = agent.outcomeProbabilityFnc;

            % submit EVC agent to experiment (generate outcome probabilities from reward manipulations)
            [outcomeProbabilities, optimalControlSignals, ~, maxEVC_congruent] = runEVCAgent(controlSignalSpace, outcomeProbabilityFnc, valueFnc, costFnc, rewards);
            experiment_log{current_subject}.congruent_outcome_probabilities = outcomeProbabilities;
            experiment_log{current_subject}.congruent_control = optimalControlSignals;
            
            % INCONGRUENT
            
            % define outcome probability function for subject
            agent.outcomeProbabilityFnc = @(u) 1./(1+exp(-controlEfficacy*u - taskAutomaticity));
            outcomeProbabilityFnc = agent.outcomeProbabilityFnc;

            % submit EVC agent to experiment (generate outcome probabilities from reward manipulations)
            [outcomeProbabilities, optimalControlSignals, ~, maxEVC_incongruent] = runEVCAgent(controlSignalSpace, outcomeProbabilityFnc, valueFnc, costFnc, rewards);
            experiment_log{current_subject}.incongruent_outcome_probabilities = outcomeProbabilities;
            experiment_log{current_subject}.incongruent_control = optimalControlSignals;
            
            choice_congruent = exp(maxEVC_congruent) ./ (exp(maxEVC_congruent) + exp(maxEVC_incongruent));
            experiment_log{current_subject}.choice_congruent = choice_congruent;

        end

        disp(['progress: ' num2str(current_subject) '/' num2str(numSubj)]);

    end
    
    save(filePath);
    
end

% Write CSV File
    
for current_subject = 1:numSubj
    
    congruent_accuracies = experiment_log{current_subject}.congruent_outcome_probabilities;
    incongruent_accuracies = experiment_log{current_subject}.incongruent_outcome_probabilities;
    congruency_effect = congruent_accuracies-incongruent_accuracies;
    rewards = experiment_log{current_subject}.rewards;
    controlEfficacy = experiment_log{current_subject}.controlEfficacy;
    taskAutomaticity = experiment_log{current_subject}.taskAutomaticity;
    controlCost = experiment_log{current_subject}.controlCost;
    incongruent_control = experiment_log{current_subject}.incongruent_control;
    congruent_control = experiment_log{current_subject}.congruent_control;
    choice_congruent = experiment_log{current_subject}.choice_congruent;
    
    n_rewards = length(rewards);
    
    data = [congruent_accuracies' (1-congruent_accuracies)' incongruent_accuracies' (1-incongruent_accuracies)' congruency_effect' choice_congruent' experiment.rewards' repmat(controlEfficacy, n_rewards, 1) repmat(taskAutomaticity, n_rewards, 1),  repmat(controlCost, n_rewards, 1)];
    T = array2table(data);
    T.Properties.VariableNames(1:10) = {'congruent_correct','congruent_incorrect','incongruent_correct', 'incongruent_incorrect', 'congruency_effect', 'choice_congruent', 'reward', 'control_efficacy', 'task_automaticity', 'control_cost'};
    csv_filename = [logFolderName '/' logfileName  '_' num2str(current_subject) '.csv'];
    writetable(T,csv_filename);
end

figure(1);
subplot(3, 3, 1);
plot(congruency_effect);

figure(1);
subplot(3, 3, 4);
plot(choice_congruent);
ylim([0 1]);

ylim([0 1]);
subplot(3, 3, 2);
plot(congruent_accuracies);
ylim([0 1]);
subplot(3, 3, 3);
plot(congruent_control);
ylim([0 3]);

subplot(3, 3, 5)
plot(incongruent_accuracies);
ylim([0 1]);
subplot(3, 3, 6);
plot(incongruent_control);
ylim([0 3]);

end


