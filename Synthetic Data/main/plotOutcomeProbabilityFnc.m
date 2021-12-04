function plotOutcomeProbabilityFnc(controlSignalSpace, outcomeProbabilityFnc, colors, controlSignalSpaceEstimates, outcomeProbabilityFncEstimates, subjIdx)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   controlSignalSpace                          ...NxM matrix lists M possible control signal intensities in order for N subjects
%   outcomeProbabilityFnc                    ...NxM matrix lists true outcome probability as a function of M control signal intensities for N subjects
%   colors                                              ... Nx3 matrix contains RGB values for N subject curves
%   outcomeProbabilityFncEstimates     ...NxM matrix lists estimated outcome probability as a function of M control signal intensities for N subjects
%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 350 250]);

    % plot all subject curves
    numSubj = size(outcomeProbabilityFnc,1);
    
    legendText = {};
    
    for subj = 1:numSubj
        
        if(exist('subjIdx', 'var')) 
            subjID = subjIdx;
        else
            subjID = subj;
        end
        
        plot(controlSignalSpace, outcomeProbabilityFnc, plotSettings.trueFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        
        legendText{length(legendText)+1} = ['Subj ' num2str(subjID)];
        
        % plot estimated cost curve
        if(exist('outcomeProbabilityFncEstimates', 'var'))
            plot(controlSignalSpaceEstimates, outcomeProbabilityFncEstimates, plotSettings.estimatedFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthEstimated);
            
            if(exist('subjIdx', 'var'))
                legendText{length(legendText)} = ['True'];
                legendText{length(legendText) + 1} = ['Measured'];
            else
                legendText{length(legendText)} = ['Subj ' num2str(subjID) ' (True)'];
                legendText{length(legendText) + 1} = ['Subj ' num2str(subjID) ' (Measured)'];
            end
        end
        
    end
    
    xlim([min(controlSignalSpace) max(controlSignalSpace)]);
    ylim([min(outcomeProbabilityFnc) max(outcomeProbabilityFnc)])
    
    xlabel('Control Signal Intensity', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('$P(O_{correct} | u, S)$', 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
    
    if(exist('subjIdx', 'var'))
        title({'Probability Of Rewarded Outcome', ['(Subj ' num2str(subjIdx) ')']}, 'FontSize', plotSettings.yLabelFontSize);
    else
        title({'Probability Of Rewarded Outcome'}, 'FontSize', plotSettings.yLabelFontSize);
    end
    
    hold off;
    
    leg = legend(legendText, 'Location', 'southeast');
    set(leg, 'FontSize', plotSettings.legendFontSize);
    
end