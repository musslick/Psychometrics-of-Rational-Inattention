function plotEVCMap(controlSignalSpace, rewards, EVCMap, optimalControlValues, maxEVC, subjIdx)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   controlSignalSpace                          ...1xM vector lists M possible control signal intensities
%   rewards                                           ...1xN vector lists rewards provided in a given experimental condition
%   EVCMap                                           ... NxM matrix that contains expected value of control for combinations of control signal intensities and rewards
%   optimalControlValues                      ...1xN vector lists optimal control signal intensities for a all reward conditions
%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 350 250]);
    
    % convert rewards to dollars
    rewards = rewards/100;
    
    % plot EVC Map
    surf(controlSignalSpace, rewards, EVCMap); hold on;

    % plot maximum EVC for given reward condition
    plot3(optimalControlValues, rewards, maxEVC, 'LineWidth', plotSettings.lineWidth3D, 'Color', plotSettings.colors(cRed,:));
    
    % plot labels
    xlabel('Control Signal Intensity', 'FontSize', plotSettings.xLabelFontSize);
    ylabel('Reward ($)', 'FontSize', plotSettings.yLabelFontSize);
%     xlabel('$u$', 'interpreter', 'latex', 'FontSize', plotSettings.xLabelFontSize);
%     ylabel('$R(O_{correct})$', 'interpreter', 'latex', 'FontSize', plotSettings.yLabelFontSize);
    zlabel('EVC(u, S)', 'Interpreter', 'Latex', 'FontSize', plotSettings.zLabelFontSize);
%     title(['Expected Value Of Control'], 'FontSize', plotSettings.titleFontSize);
    
    zlim([min(EVCMap(:)), max(EVCMap(:))]);
    
    hold off;

end