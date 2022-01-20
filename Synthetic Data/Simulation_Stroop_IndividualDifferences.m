% EVC Model Data Generation

clear all;
clc;

addpath('main');

logfilename = 'Stroop_IndividualDifference';

% INDIVIDUAL DIFFERENCES

nSubj = 1000;

controlCost_range = [0.8 0.9];    % range of tested control cost values 0.8
controlEfficacy_range = [4 5];    % range of tested control efficacy values 5
taskAutomaticity_range = [-5 -6];    % task automaticity values -5 -6

%%% EXPERIMENT

congruency = 3;

% set up reward manipulations
experiment.rewards = 0:0.1:10;

%%% DEFINE DEFAULT AGENT

% parameters
default_controlCost = 1;
default_taskAutomaticity = -7.5;
default_controlEfficacy = 15;
default_accuracyBias = 5;
default_rewardSensitivity = 1;

% define space of control signals
agent.controlSignalSpace = 0:0.01:10;

% define cost functions for all subjects
agent.costFnc = @(u) exp(default_controlCost * u) - 1;

% define outcome probability function for both subjects
agent.outcomeProbabilityFnc = @(u) 1./(1+exp(-default_controlEfficacy*u - default_taskAutomaticity));

% define value function
agent.valueFnc = @(u) default_rewardSensitivity * u + default_accuracyBias;

traits.controlCost = controlCost_range(1) + (controlCost_range(2)-controlCost_range(1)).*rand(nSubj,1);
traits.controlEfficacy = controlEfficacy_range(1) + (controlEfficacy_range(2)-controlEfficacy_range(1)).*rand(nSubj,1);
traits.taskAutomaticity = taskAutomaticity_range(1) + (taskAutomaticity_range(2)-taskAutomaticity_range(1)).*rand(nSubj,1);
traits.N = nSubj;

% RUN EXPERIMENT

run_Stroop_Simulation(agent, experiment, traits, congruency, logfilename);



