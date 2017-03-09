function [Selection, ok] = pupup_list_features(featureNames,Selection)
    featureNames = [featureNames{:}]';
    Selection = [Selection{:}];
    [Selection, ok] = listdlg('ListString',featureNames,'SelectionMode','multiple',...
                              'InitialValue',find(Selection),'PromptString','Select features');
end