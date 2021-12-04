function plotFunctionRange(x, y, xLabel, yLabel, titleLabel, legendLabel, legendLocation, varargin)
% PLOTCOSTFNC  Plots EVC cost function.
%
% Required arguments:
% 
%   x                           ...1xM matrix lists M possible x values
%   y                           ...NxM matrix lists NxM possible y values 
%   titleLabel              ...label of the plot title

%   
% Author: Sebastian Musslick

    % load plotSettings
    plotsettings;
    
    numFunctions = size(y,1);
    colors = transpose(repmat(linspace(0.2, 1, numFunctions), 3, 1));

    % set up figure
    fig = figure();
    set(fig, 'Position', [100 100, 350 200]);
    
    justBounds = 0;
    if(~isempty(varargin)) 
        justBounds = varargin{1};
    end
     
    % just plot bounds
    if(justBounds) 
        
        y = [y(1,:); y(end,:)];
        colors = [plotSettings.colors(cContrast1,:); plotSettings.colors(cContrast2, :)];
        numFunctions = 2;
        
    end
    
    for fncIdx = 1:numFunctions
       
        plot(x, y(fncIdx,:), plotSettings.trueFncMarker, 'Color', colors(fncIdx, :), 'LineWidth', plotSettings.lineWidthTrue); hold on;
        
    end
    
    xlim([min(x) max(x)]);
    ylim([min([y(:)']) max([y(:)'])])
    
    xlabel(xLabel, 'FontSize', plotSettings.xLabelFontSize);
    ylabel(yLabel, 'Interpreter', 'LaTex', 'FontSize', plotSettings.yLabelFontSize+1);
    title({titleLabel}, 'FontSize', plotSettings.yLabelFontSize);
    
    hold off;
    
    leg = legend({legendLabel{1}, legendLabel{2}}, 'Interpreter', 'LaTex',  'FontSize', plotSettings.yLabelFontSize+1, 'Location', legendLocation);
    
%     leg = legend(legendText, 'Location', 'southeast');
%     set(leg, 'FontSize', plotSettings.legendFontSize);
    
end