function align_pie_labels(figure_handle, names)
%% ALIGN_PIE_LABELS(figure_handle, names)
% Copypasted from MathWorks:
% http://www.mathworks.se/help/matlab/creating_plots/customize-pie-chart-labels.html
% Moves pie chart labels so they don't overlap the chart.
% As a bonus, we also get both the percentage and the name in the label!
%
% See also pie.

    hText = findobj(figure_handle,'Type','text');
    percentValues = get(hText,'String');
    customStrings = strcat(names, repmat({' '},length(names),1), percentValues);
    oldExtents_cell = get(hText,'Extent'); % cell array
    oldExtents = cell2mat(oldExtents_cell); % numeric array
    set(hText,{'String'},customStrings);
    newExtents_cell = get(hText,'Extent'); % cell array
    newExtents = cell2mat(newExtents_cell); % numeric array
    width_change = newExtents(:,3)-oldExtents(:,3);
    signValues = sign(oldExtents(:,1));
    offset = signValues.*(width_change/2);
    textPositions_cell = get(hText,{'Position'}); % cell array
    textPositions = cell2mat(textPositions_cell); % numeric array
    textPositions(:,1) = textPositions(:,1) + offset; % add offset adjustment
    set(hText,{'Position'},num2cell(textPositions,[3,2])) % set Position property
end
