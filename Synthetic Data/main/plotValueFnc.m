function plotValueFnc(rewards, assumedValueFnc, trueValueFnc, colors, subjIdx)
% PLOTVALUEFNC  Plots subjective value function.
%
% Required arguments:
% 
%   rewards                          ...NxM matrix lists M possible control signal intensities in order for N subjects
%   trueValueFnc                  ...NxM matrix lists true outcome probability as a function of M control signal intensities for N subjects
%   assumedValueFnc          ...NxM matrix lists assumed outcome probability as a function of M control signal intensities for N subjects
%   colors                            ... Nx3 matrix contains RGB values for N subject curves
%   subjIdx                          ... index of subject that is plotted
%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 350 250]);

    % plot all subject curves
    numSubj = size(trueValueFnc,1);
    
    % convert rewards to dollar
    rewards =  rewards/100;
    
    legendText = {};
    
    plot(rewards, assumedValueFnc, plotSettings.trueFncMarker, 'Color', 'k', 'LineWidth', plotSettings.lineWidthTrue); hold on;
    legendText{length(legendText)+1} = ['Assumed'];
    
    for subj = 1:numSubj
        
        if(exist('subjIdx', 'var')) 
            subjID = subjIdx;
        else
            subjID = subj;
        end
        
        plot(rewards, trueValueFnc(subjID,:), plotSettings.trueFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        
        legendText{length(legendText)+1} =  ['Subj ' num2str(subjID) ' (True)'];
        
    end
    
    xlim([min(rewards) max(rewards)]);
    ylim([min(trueValueFnc(:)) max(trueValueFnc(:))])
    
    xlabel('Reward ($)', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('$V(O_{correct})$', 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
    
    if(exist('subjIdx', 'var'))
        title({'Subjective Value', ['(Subj ' num2str(subjIdx) ')']}, 'FontSize', plotSettings.yLabelFontSize);
    else
        title({'Subjective Value'}, 'FontSize', plotSettings.yLabelFontSize);
    end
    
    hold off;
    
    leg = legend(legendText, 'Location', 'southeast');
    set(leg, 'FontSize', plotSettings.legendFontSize);
    
end