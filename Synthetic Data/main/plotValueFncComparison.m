function plotValueFncComparison(rewards, assumedValueFnc, trueValueFnc, colors, subjIdx, subjLabel)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   rewards                           ...NxM matrix lists M possible control signal intensities in order for N subjects
%   assumedValueFnc      ...1xM matrix lists assumed outcome probaility as a function of M control signal intensities for N subjects
%   trueValueFnc              ...NxM matrix lists true outcome probaility as a function of M control signal intensities for N subjects
%   colors                                               ... Nx3 matrix contains RGB values for N subject curves
%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 450 250]);

    % plot all subject curves
    numSubj = size(trueValueFnc,1);
    
    % convert rewards to dollar
    rewards = rewards / 100;
    
    legendText = {};
    
    plot(rewards, assumedValueFnc, plotSettings.trueFncMarker, 'Color', plotSettings.colors(cSingle,:), 'LineWidth', plotSettings.lineWidthTrue); hold on;
    legendText{1} = 'Assumed';
    
    for subj = 1:numSubj
        
        if(exist('subjIdx', 'var')) 
            subjID = subjIdx;
        else
            subjID = subj;
        end
        
        plot(rewards, trueValueFnc(subj,:), plotSettings.trueFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        
        if(exist('subjLabel', 'var')) 
            legendText{length(legendText)+1} = subjLabel;
        else
            legendText{length(legendText)+1} = ['Subj ' num2str(subjID) ''];
        end
        
        
    end
    
    xlim([min(rewards) max(rewards)]);
    ylim([min([assumedValueFnc trueValueFnc(:)']) max([assumedValueFnc trueValueFnc(:)'])])
    
    xlabel('Reward ($)', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('$V(O_{correct})$', 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
    title({'Subjective Value'}, 'FontSize', plotSettings.yLabelFontSize);
    
    hold off;
    
    leg = legend(legendText, 'Location', 'northwest');
    set(leg, 'FontSize', plotSettings.legendFontSize);
    
end