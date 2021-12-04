function plotOutcomeProbabilityFncComparison(controlSignalSpace, assumedOutcomeProbabilityFnc, trueOutcomeProbabilityFnc, colors, subjIdx, subjLabel)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   controlSignalSpace                           ...NxM matrix lists M possible control signal intensities in order for N subjects
%   assumedOutcomeProbabilityFnc      ...1xM matrix lists assumed outcome probaility as a function of M control signal intensities for N subjects
%   trueOutcomeProbabilityFnc              ...NxM matrix lists true outcome probaility as a function of M control signal intensities for N subjects
%   colors                                               ... Nx3 matrix contains RGB values for N subject curves
%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 450 250]);

    % plot all subject curves
    numSubj = size(trueOutcomeProbabilityFnc,1);
    
    legendText = {};
    
    plot(controlSignalSpace, assumedOutcomeProbabilityFnc, plotSettings.trueFncMarker, 'Color', plotSettings.colors(cSingle,:), 'LineWidth', plotSettings.lineWidthTrue); hold on;
    legendText{1} = 'Assumed';
    
    for subj = 1:numSubj
        
        if(exist('subjIdx', 'var')) 
            subjID = subjIdx;
        else
            subjID = subj;
        end
        
        plot(controlSignalSpace, trueOutcomeProbabilityFnc(subj,:), plotSettings.trueFncMarker, 'Color', colors(subj, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        
        if(exist('subjLabel', 'var')) 
            legendText{length(legendText)+1} = subjLabel;
        else
            legendText{length(legendText)+1} = ['Subj ' num2str(subjID) ''];
        end
        
        
    end
    
    xlim([min(controlSignalSpace) max(controlSignalSpace)]);
    ylim([min([assumedOutcomeProbabilityFnc trueOutcomeProbabilityFnc(:)']) max([assumedOutcomeProbabilityFnc trueOutcomeProbabilityFnc(:)'])])
    
    xlabel('Control Signal Intensity u', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('$P(O_{correct} | u, S)$', 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
    title({'Probability Of Rewarded Outcome'}, 'FontSize', plotSettings.yLabelFontSize);
    
    hold off;
    
    leg = legend(legendText, 'Location', 'southeast');
    set(leg, 'FontSize', plotSettings.legendFontSize);
    
end