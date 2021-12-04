function plotCostFnc_CogSci(controlSignalSpace, costFnc, colors, controlSignalSpaceEstimates, costFncEstimates, c, offset, varargin)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   controlSignalSpace                          ...NxM matrix lists M possible control signal intensities in order for N subjects
%   costFnc                                           ...NxM matrix lists true costs as a function of M control signal intensities for N subjects
%   colors                                              ... Nx3 matrix contains RGB values for N subject curves
%   costFncEstimates                            ...NxM matrix lists estimated costs as a function of M control signal intensities for N subjects
%   c                                                      ... 1xN vector that lists cost coefficients for each subject
%   offset                                              ... 1xN vector that lists offset coefficients for each subject
%
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 350 250]);

    % plot all subject curves
    numSubj = size(costFnc,1);
    
    legendText = {};
    legendLabels = {};
    
    if(~isempty(varargin))
        legendLabels = varargin{1};
    end
    
    for subj = 1:numSubj
        
        plot(controlSignalSpace, costFnc(subj,:), plotSettings.trueFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        if(~isempty(legendLabels))
            legendText{length(legendText) + 1} = legendLabels{subj};
        else
            legendText{length(legendText) + 1} = ['Subj ' num2str(subj)];
        end
        
        % plot cost estimates
        if(exist('costFncEstimates', 'var'))
            plot(controlSignalSpaceEstimates(subj,:), costFncEstimates(subj,:), plotSettings.estimatedFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthEstimated);
            if(~isempty(legendLabels))
                legendText{length(legendText)} = [legendLabels{subj} ' (True)'];
                legendText{length(legendText) + 1} = [legendLabels{subj} ' (Estimate)'];
            else
                legendText{length(legendText)} = ['Subj ' num2str(subj) ' (True)'];
                legendText{length(legendText) + 1} = ['Subj ' num2str(subj) ' (Estimate)'];
            end
        end
        
        % plot cost fit
        if(exist('c', 'var') && exist('offset', 'var'))
            if(~isempty(c) && ~isempty(offset))
                y = exp(c(subj).*controlSignalSpace) + offset(subj);
                plot(controlSignalSpace, y, plotSettings.fittedFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); 
                legendText{length(legendText) + 1} = ['Subj ' num2str(subj) ' (Fitted)'];
            end
        end
        
    end
    
    xlabel('Control Signal Intensity u', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('Cost(u)', 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
%     title('Control Costs', 'FontSize', plotSettings.titleFontSize);
    hold off;
    
    ylim([0 max([costFncEstimates(:); costFnc(:)])]);
    
    leg = legend(legendText, 'Location', 'eastoutside');
    set(leg, 'FontSize', plotSettings.legendFontSize-1);
end