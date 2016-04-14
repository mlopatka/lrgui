function LR_GUI
global transformed_data feature_data distance_same distance_diff loc parameters_same parameters_diff h checked_data

%warning 'off'

%% we set the variables that determine the layout, this way we can more easily change the layout
x1 = 0.005;  %left  boundary left part
x2 = 0.275;  %right boundary left part
x3 = 0.415;  %right boundary middle part
x4 = 0.7175; %left boundary of right part

%% create GUI-figure  ,'menu','none'
h.g = figure('units','normalized','outerposition',[0 0.2 1 0.8],'toolbar','none','menubar','none','name','LR GUI','numbertitle','off');

%% create the buttongroups
% this is the parent buttongroup for the feature selection checkboxes
h.bg_features = uibuttongroup('visible','on','Title','Features','units','normalize','pos',[x1 0.07 x2-x1 0.90]);

% this is the parent buttongroup for the label selection checkboxes
h.bg_labels = uibuttongroup('visible','on','Title','Labels','units','normalize','pos',[x2+0.005 0.73 x3-(x2+0.005) 0.24]);

% this is the parent buttongroup for the selection of which things to plot
h.bg_plots = uibuttongroup('visible','on','Title','Plot','units','normalize','pos',[x3+0.02 0.235 (0.99-x3-0.02-0.01)/2 0.09]);
% create four checkboxes for selection the objects to plot
h.cb_plots(1) = uicontrol('style','checkbox','string','same source histogram'        ,'units','normalized','pos',[0 0.5   0.5 0.49],'parent',h.bg_plots,'HandleVisibility','off','value',1);
h.cb_plots(2) = uicontrol('style','checkbox','string','same source distribution'     ,'units','normalized','pos',[0   0   0.5 0.49],'parent',h.bg_plots,'HandleVisibility','off','value',1);
h.cb_plots(3) = uicontrol('style','checkbox','string','different source histogram'   ,'units','normalized','pos',[0.5 0.5 0.5 0.49],'parent',h.bg_plots,'HandleVisibility','off','value',1);
h.cb_plots(4) = uicontrol('style','checkbox','string','different source distribution','units','normalized','pos',[0.5 0   0.5 0.49],'parent',h.bg_plots,'HandleVisibility','off','value',1);

% here, we can select what plots to make of the transformed data
h.bg_data_overview    = uibuttongroup('visible','on','Title','Data overview','units','normalize','pos',[x2+0.005,0.04,x3-(x2+0.005),0.06]);
h.cb_data_overview(1) = uicontrol('style','checkbox','string','boxplot' ,'units','normalized','pos',[0   0 1/3 1],'parent',h.bg_data_overview,'HandleVisibility','off','value',1);
h.cb_data_overview(2) = uicontrol('style','checkbox','string','lineplot','units','normalized','pos',[1/3 0 1/3 1],'parent',h.bg_data_overview,'HandleVisibility','off','value',1);
h.cb_data_overview(3) = uicontrol('style','checkbox','string','heatmap' ,'units','normalized','pos',[2/3 0 1/3 1],'parent',h.bg_data_overview,'HandleVisibility','off','value',1);

% here, we can select what plots to make of the transformed data
h.bg_summary_figures    = uibuttongroup('visible','on','Title','Summary figures','units','normalized','pos',[x3+0.02,0.04,(0.99-x3-0.02-0.01)/2,0.06]);
%h.cb_summary_figures(1) = uicontrol('style','checkbox','string','ece plot     ' ,'units','normalized','pos',[0   0 1/4 1],'parent',h.bg_summary_figures,'HandleVisibility','off','value',1);
h.cb_summary_figures(1) = uicontrol('style','checkbox','string','hist and dist' ,'units','normalized','pos',[0 0 1/3 1],'parent',h.bg_summary_figures,'HandleVisibility','off','value',1);
h.cb_summary_figures(2) = uicontrol('style','checkbox','string','roc curve    ' ,'units','normalized','pos',[1/3 0 1/3 1],'parent',h.bg_summary_figures,'HandleVisibility','off','value',1);
h.cb_summary_figures(3) = uicontrol('style','checkbox','string','tippett plot ' ,'units','normalized','pos',[2/3 0 1/3 1],'parent',h.bg_summary_figures,'HandleVisibility','off','value',1);


% this parent radiobuttongroup is for the choice of feature selection method
h.bg_feature_selection =  uibuttongroup('visible','on','Title','Feature selection method','units','normalize','pos',[x2+0.005 0.16 x3-(x2+0.005) 0.17]);
% create three radiobuttons for selection of the method for feature selection
h.rb_feature_selection_method(1) = uicontrol('style','radiobutton','string','Magical Mystery Tour'            ,'units','normalized','pos',[0   0.75  0.99 0.25],'parent',h.bg_feature_selection,'HandleVisibility','off','value',1);
h.rb_feature_selection_method(2) = uicontrol('style','radiobutton','string','PCA determined features'         ,'units','normalized','pos',[0   0.50  0.99 0.25],'parent',h.bg_feature_selection,'HandleVisibility','off','value',0);
h.rb_feature_selection_method(3) = uicontrol('style','radiobutton','string','Random Forest'                   ,'units','normalized','pos',[0   0.25  0.99 0.25],'parent',h.bg_feature_selection,'HandleVisibility','off','value',0, 'enable', 'off');
h.rb_feature_selection_method(4) = uicontrol('style','radiobutton','string','Individual discrimination method','units','normalized','pos',[0   0     0.99 0.25],'parent',h.bg_feature_selection,'HandleVisibility','off','value',0);

% determine distribution same source
h.bg_same_distribution = uibuttongroup('visible','on','Title','same source distribution','units','normalized','pos',[x3+0.02,0.325,(0.99-x3-0.02-0.01)/2-0.06,0.06]);
% create three radio buttons in the button group
h.rb_samedistribution(1) = uicontrol('style','radiobutton','string','gamma'    ,'units','normalized','pos',[0.001,0.01,0.20,0.98],'parent',h.bg_same_distribution,'HandleVisibility','off');
h.rb_samedistribution(2) = uicontrol('style','radiobutton','string','lognormal','units','normalized','pos',[0.200,0.01,0.25,0.98],'parent',h.bg_same_distribution,'HandleVisibility','off');
h.rb_samedistribution(3) = uicontrol('style','radiobutton','string','weibull'  ,'units','normalized','pos',[0.450,0.01,0.20,0.98],'parent',h.bg_same_distribution,'HandleVisibility','off');
h.rb_samedistribution(4) = uicontrol('style','radiobutton','string','normal'   ,'units','normalized','pos',[0.650,0.01,0.20,0.98],'parent',h.bg_same_distribution,'HandleVisibility','off');
h.rb_samedistribution(5) = uicontrol('style','radiobutton','string','KDE'      ,'units','normalized','pos',[0.850,0.01,0.15,0.98],'parent',h.bg_same_distribution,'HandleVisibility','off');

%% manual KDE checkbox same source
h.cb_kde_samesource = uicontrol('style','checkbox','string','' ,'units','normalized','pos',[x3+0.025 + (0.99-x3-0.02-0.01)/2-0.06,0.325,0.011,0.03],'HandleVisibility','off','value',0);
h.t_kde_set_bandwidth_same_source = uicontrol('style','text','string','set bandwidth' ,'units','normalized','pos',[x3+0.025 + (0.99-x3-0.02-0.01)/2-0.06,0.355,0.055,0.03],'HorizontalAlignment','left');

% determine distribution different source
h.bg_diff_distribution = uibuttongroup('visible','on','Title','different source distribution','units','normalized','pos',[x4,0.325,(0.99-x3-0.02-0.01)/2 - 0.06,0.06]);
% create three radio buttons in the button groupS
h.rb_diffdistribution(1) = uicontrol('style','radiobutton','string','gamma'    ,'units','normalized','pos',[0.001,0.01,0.20,0.98],'parent',h.bg_diff_distribution,'HandleVisibility','off');
h.rb_diffdistribution(2) = uicontrol('style','radiobutton','string','lognormal','units','normalized','pos',[0.200,0.01,0.25,0.98],'parent',h.bg_diff_distribution,'HandleVisibility','off');
h.rb_diffdistribution(3) = uicontrol('style','radiobutton','string','weibull'  ,'units','normalized','pos',[0.450,0.01,0.20,0.98],'parent',h.bg_diff_distribution,'HandleVisibility','off');
h.rb_diffdistribution(4) = uicontrol('style','radiobutton','string','normal'   ,'units','normalized','pos',[0.650,0.01,0.20,0.98],'parent',h.bg_diff_distribution,'HandleVisibility','off');
h.rb_diffdistribution(5) = uicontrol('style','radiobutton','string','KDE'      ,'units','normalized','pos',[0.850,0.01,0.15,0.98],'parent',h.bg_diff_distribution,'HandleVisibility','off');

%% manual KDE checkbox same source
h.cb_kde_diffsource = uicontrol('style','checkbox','string','' ,'units','normalized','pos',                      [x3+0.025+0.02+2*(0.99-x3-0.02-0.03)/4 + (0.99-x3-0.02-0.01)/2-0.06,0.325,0.011,0.03],'HandleVisibility','off','value',0);
h.t_kde_set_bandwidth_diff_source = uicontrol('style','text','string','set bandwidth' ,'units','normalized','pos',[x3+0.025+0.02+2*(0.99-x3-0.02-0.03)/4 + (0.99-x3-0.02-0.01)/2-0.06,0.355,0.055,0.03],'HorizontalAlignment','left');


%% create axes
h.ax1 = axes('parent',h.g,'units','normalized','pos',[x3+0.02,0.43,0.99-x3-0.02,0.54]);

disclaimerText={'DISCLAIMER: This software is of a provisional nature and provided for research and academic use only. Commercial distribution is strictly prohibited. All calculations performed are to be treated as unvalidated with no guarantee of accuracy whatsoever. The software and constituent functions are still in development and have not been validated for use in forensic practice. This project is an individual initiative of the project contributors and is provided "as is" without warranty of any kind, either expressed or implied.'};

%% create the textboxes
% create features_checked text
h.t(1)  = uicontrol('style','text','units','normalized','pos',[x1+0.13,0.005,x2-x1-0.13,0.025],'string','no features selected','backgroundcolor',[.8,.3,.3],'fontweight','b');
% create features_transformed text
h.t(2)  = uicontrol('style','text','units','normalized','pos',[x2+0.005,0.445,x3-(x2+0.005),0.025],'string','no transformation selected','backgroundcolor',[.8,.3,.3],'fontweight','b');
% create features_metric text
h.t(3)  = uicontrol('style','text','units','normalized','pos',[x2+0.005,0.35,x3-(x2+0.005),0.025],'string','no metric selected','backgroundcolor',[.8,.3,.3],'fontweight','b');
% create same source and different source plot text
h.t(4)  = uicontrol('style','text','units','normalized','pos',      [x3+0.02                         ,0.20,0.0875,0.025],'string','false pos rate','fontsize',10,'fontweight','b');
h.t(5)  = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.005        ,0.20,0.0875,0.025],'string','false neg rate','fontsize',10,'fontweight','b');
h.t(6)  = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.0875 + 0.01,0.20,0.0875,0.025],'string','CLLR','fontsize',10,'fontweight','b');
% create textboxes to keep score of the fp fn and cllr values
h.t(10) = uicontrol('style','text','units','normalized','pos',      [x3+0.02                         ,0.17,0.0875,0.025],'string','...','fontsize',10,'fontweight','bold');
h.t(11) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.005        ,0.17,0.0875,0.025],'string','...','fontsize',10,'fontweight','bold');
h.t(12) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.0875 + 0.01,0.17,0.0875,0.025],'string','...','fontsize',10,'fontweight','bold');
h.t(13) = uicontrol('style','pushbutton','units','normalized','pos',[x3+0.02                         ,0.14,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic','enable','off','callback',@p17_call);
h.t(14) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.005        ,0.14,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic');
h.t(15) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.0875 + 0.01,0.14,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic');
h.t(16) = uicontrol('style','pushbutton','units','normalized','pos',[x3+0.02                         ,0.11,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic','enable','off','callback',@p17_call);
h.t(17) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.005        ,0.11,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic');
h.t(18) = uicontrol('style','text','units','normalized','pos',      [x3+0.02 + 0.0875 + 0.0875 + 0.01,0.11,0.0875,0.025],'string','...','fontsize',10,'foregroundcolor',[0.4 0.4 0.4],'fontangle','italic');

% textbox with disclaimer text
h.t(19) = uicontrol('style','text','units','normalized','pos',[x4,0.005,0.27,0.15],'string',disclaimerText{1},'fontsize',7,'HorizontalAlignment','left');
% textbox with final model information
h.t(20) = uicontrol('style','edit','units','normalized','pos',[x3+0.02+0.03+3*(0.99-x3-0.02-0.03)/4,0.16,(0.99-x3-0.02-0.03)/4,0.155],'string','final model information','fontsize',9,'max',2,'HorizontalAlignment','left');
% textbox with whether the data is loaded
h.t(21) = uicontrol('style','text','units','normalized','pos',[x1+0.13,0.97,x2-x1-0.13,0.025],'string','no data/scores loaded','backgroundcolor',[.8,.3,.3],'fontweight','b');


%% special hold of the output of a population model
h.currentPopModelLoc = 0;

%% create pushbottons p0 -> p14
%% creat load data set pushbutton
p0_tt = 'Loads a CSV file containing your data set formatted as a matrix with one leading row (containing all label names formatted as _lab_labelName_ and all feature names)';
h.p0 = uicontrol('style','pushbutton','TooltipString', p0_tt,'units','normalized',...
    'pos',[x1,0.97,0.06,0.025],'string','Load Dataset',...
    'fontweight','b','callback',@p0_call);
    function p0_call(varargin)
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            set([h.p1,h.p2,h.p3,h.p6,h.p7,h.p8,h.p9,h.p10,h.p11,h.p13,h.p15,...
                h.popup1,h.popup2,h.e1,h.rb_feature_selection_method(1:4),h.cb_data_overview(1:3)],'enable','on')
            set(h.p18,'enable','off')
            set(h.t(21),'string','no data/scores loaded','backgroundcolor',[.8,.3,.3])
            pos_l = get(h.bg_labels,'pos'); %we use the position of the buttongroups to make sure everything stays in the same place
            pos_f = get(h.bg_features,'pos');
            [fileName,path2File] = uigetfile({'*.mat;*.xls;*.csv;*.dat;*.txt'},'Please select the data file to use this session');
            if (fileName(1) == 0) && (path2File(1) == 0)
                disp('File loading operation canceled.');
                set(h.p18,'enable','on')
            else
                [feature_data, labels, labelNames, featureNames] = parseData([path2File,fileName]);
                loc = labsConvert(labels);
                [s_features,new_order] = sort(featureNames);
                feature_data=feature_data(:,new_order);
                %         numb_of_features = length(feature_data);
                populateLabels({},pos_l); %clear any old labels and features in place first
                populateFeatures({},pos_f);
                p7_call %clears the workflow
                populateLabels(labelNames,pos_l);
                populateFeatures(s_features,pos_f);
                
                % if the number of features is too large, give a dialog box
                % and open a pop up to select features
                if(strcmp(get(h.cb_features(1),'visible'),'off'))
                    %msgbox('The number of features is too large to fit in the checkboxes region, use pop-up list to select features','Feature selection','createmode','modal')
                    p15_call
                end
                
                % set everything to default colors and values
                set(h.t(10:18),'string','...');
                set(h.t(20),'string','final model information');
                set(h.t(21),'string','data loaded','backgroundcolor',[.7,.9,.7])
                set([h.cb_plots(:);h.rb_samedistribution(:);h.rb_diffdistribution(:);h.rb_feature_selection_method(:)],'fontweight','n','backgroundcolor','default');
                cla(h.ax1)
                set(h.t(10),'userData',[]);
                set(h.t(13),'enable','off','userData',[]);
                set(h.t(16),'enable','off','userData',[]);
            end
        end
    end

%% select features pushbutton
p1_tt = 'Confirms the features that will be used to compute pairwise scores between same and different label samples!';
h.p1 = uicontrol('style','pushbutton','TooltipString', p1_tt,'units','normalized',...
    'pos',[x1,0.04,0.125,0.03],'string','SELECT FEATURES',...
    'fontweight','b','callback',@p1_call);
    function p1_call(varargin)
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            if(isfield(h,'cb_features')) % check if features exist
                if ~isempty(h.cb_features)
                    [checked_data] = check_features_call(h.cb_features,h.t,feature_data);
                    set(h.t(2),'string','no transformation selected','backgroundcolor',[.8,.3,.3]);
                    set(h.t(3),'string','no metric selected','backgroundcolor',[.8,.3,.3]);
                    set([h.rb_diffdistribution(:);h.rb_samedistribution(:);h.cb_plots(:)],'backgroundcolor','default','fontweight','n');
                end
                cla(h.ax1);
            end
        end
    end

%% transform data pushbutton
p2_tt='Applies the transformation to the selected features BEFORE the calculation of scores';
h.p2 = uicontrol('style','pushbutton','TooltipString', p2_tt, 'units','normalized',...
    'pos',[x2+0.005,0.475,x3-(x2+0.005),0.040],'string','TRANSFORM DATA',...
    'fontweight','b','callback',@p2_call);
    function p2_call(varargin)
        if(strcmp(get(h.t(1),'string'),'features selected')) % check if features are selected
            % transform the data
            [transformed_data, exitFlag,message]= transform_data_call(checked_data, get(h.e1,'String'));
            if exitFlag
                if(strcmp(message,'transformation complete'))
                    cla(h.ax1);
                    set([h.rb_diffdistribution(:);h.rb_samedistribution(:);h.cb_plots(:)],'backgroundcolor','default','fontweight','n');
                    set(h.t(2),'backgroundcolor',[.7,.9,.7],'string',message);
                else
                    % this is what we do in the case that the transformation fails
                    set(h.t(2),'backgroundcolor',[.8,.3,.3],'string',message);
                end
                set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','no metric selected');
            end
        else
            set(h.t(2),'backgroundcolor',[.8,.3,.3],'string','select features first');
        end
    end

%% calculate distances pushbutton
p3_tt = 'Computes pairwise distances between same-label sampels and different-label samples based on selected label level and using distance metric selected from drop down list';
h.p3 = uicontrol('style','pushbutton', 'TooltipString', p3_tt,'units','normalized',...
    'pos',[x2+0.005+(x3-(x2+0.005))/2,0.38,(x3-(x2+0.005))/2,0.04],'string','CALC. DIST.',...
    'fontweight','b','callback',@p3_call);
    function p3_call(varargin)
        % check if features are selected and transformation has been done
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            if(strcmp(get(h.t(1),'string'),'features selected'))&&(strcmp(get(h.t(2),'string'),'transformation complete'))
                % check if labels have been selected and exist
                if(isfield(h,'cb_labels'))
                    set(h.cb_labels(:),'backgroundcolor','default','fontweight','n');
                    labChecks = get(h.cb_labels, 'Value');
                    % we set labChecks in the appropriate format
                    if size(labChecks) > 1
                        labChecks = [labChecks{:}];
                    elseif isa(labChecks, 'cell')
                        labChecks = cell2mat(labChecks);
                    else
                        labChecks = logical(labChecks);
                    end
                    if sum(labChecks) < 1 % check if labels have been selected
                        set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','no labels selected');
                    else % if selected, we release the metric!
                        [distance_same, distance_diff, ~, message] = metric_call(logical(labChecks),{get(h.popup2,'string'),get(h.popup2,'value')},transformed_data, loc, h.rb_samedistribution, h.rb_diffdistribution);
                        % we check if the correct outcome returned
                        if(strcmp(message,'distances computed'))
                            cla(h.ax1);
                            set([h.rb_diffdistribution(:);h.rb_samedistribution(:);h.cb_plots(:)],'backgroundcolor','default','fontweight','n');
                            set(h.cb_labels(labChecks==1),'backgroundcolor',[.7,.9,.7],'fontweight','b');
                            set(h.t(3),'backgroundcolor',[.7,.9,.7],'string',message);
                        else
                            set(h.t(3),'backgroundcolor',[.8,.3,.3],'string',message);
                        end
                    end
                else % there are no labels
                    set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','there are no labels');
                end
            else % either transformation or feature selection needs to be done
                set(h.t(3),'backgroundcolor',[.8,.3,.3],'string','set features and transformation');
            end
        end
    end

%% export scores pushbutton
p4_tt = 'Exports the current scores as a .csv file. The first column consists of a label corresponding to same source score (0) or different source score (1). The second column consists of the scores. This file can be used with the Load Scores functionality';
h.p4 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x4,0.24,(0.99-x3-0.02-0.03)/4,0.035],'string','Exp. Scores',...
    'fontweight','b','fontsize',9, 'TooltipString', p4_tt,'callback',@p4_call);
    function p4_call(varargin)
        export_scores_call(distance_same,distance_diff);
    end

%% plot pushbutton
p5_tt = 'Plots the scores for different and same source sample as histograms. Distribution functions that can be specified by the user are estimated and added to the plot';
h.p5 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x4,0.28,(0.99-x3-0.02-0.03)/4,0.035], 'TooltipString', p5_tt,'string','PLOT',...
    'fontweight','b','callback',@p5_call);
    function p5_call(varargin)
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            if or(and(strcmp(get(h.t(3),'string'),'distances computed'),(strcmp(get(h.t(2),'string'),'transformation complete'))),strcmpi(get(h.t(21),'string'),'scores loaded'))
                % check if all steps are completed
                sucessFlag = plot_distrib_and_hist;
                
                if(sucessFlag)
                    % we compute the performance statistics
                    [confusion_matrix, CLLR] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, sucessFlag);
                    % we display the performance statistices
                    display_performance(confusion_matrix, CLLR, h.t)
                    if isa(get(h.cb_labels,'value'), 'double')
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find((get(h.cb_labels,'value'))))); %display the parameter
                    else
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find(cell2mat(get(h.cb_labels,'value'))))); %display the parameter
                    end
                else
                    set(h.cb_plots(:),'backgroundcolor','default','fontweight','n');
                    error('something went wrong with the plotting');
                end
                
                disp('new function properly executed')
            end
        end
    end

%% add a preprocessing step to the workflow pushbutton
p6_tt = 'Adds the selected pre-processing step from the drop down menu on the left to the current workflow. It is possible to combine several pre-processing steps into one workflow.';
h.p6 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x2+0.005+(x3-(x2+0.005))/2,0.665,(x3-(x2+0.01))/2,0.04],'string','add step >',...
    'fontweight','b','TooltipString', p6_tt,'callback',@p6_call);
    function p6_call(varargin)
        preProcs = get(h.popup1, 'String');
        preProcs = preProcs(get(h.popup1, 'Value'),:);
        set(h.e1, 'String', [get(h.e1, 'String'), ' > ', preProcs]);
        disp 'user added a preprocessing step!'
    end

%% clear workflow pushbutton
p7_tt = 'Clears the specified workflow. This way, the user can construct a new workflow';
h.p7 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x2+0.005,0.53,x3-(x2+0.005),0.030], 'TooltipString', p7_tt,'string','clear',...
    'fontweight','b','callback',@p7_call);
    function p7_call(varargin)
        set(h.e1, 'String', 'data');
        disp('user cleared the workflow.');
    end

%% select all features pushbutton
p8_tt = 'Selects all the features';
h.p8 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x1+0.13,0.04,0.0325,0.030],'string','ALL',...
    'fontweight','b', 'TooltipString', p8_tt,'callback',@p8_call);
    function p8_call(varargin)
        if(isfield(h,'cb_features')) % check if features exist
            set(h.cb_features(:), 'Value', 1);
            p1_call;
        end
    end

%% select no features pushbutton
p9_tt = 'Deselects all the features';
h.p9 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x1+0.2375,0.04,0.0325,0.030],'string','NONE',...
    'fontweight','b', 'TooltipString', p9_tt,'callback',@p9_call);
    function p9_call(varargin)
        if(isfield(h,'cb_features')) % check if features exist
            set(h.cb_features,'Value', 0);
            set(h.cb_features,'backgroundcolor','default','fontweight','n')
            set(h.t(1),'string','no features selected','backgroundcolor',[.8,.3,.3],'fontweight','b');
        end
    end


%% non zero standard deviation feature selection pushbutton
p10_tt = 'Selects all the features that have a non zero standard deviation, ignoring the features that do not have discriminative power.';
h.p10 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x1+0.1675,0.04,0.065,0.030],'string','NON-ZERO STD',...
    'fontweight','b', 'TooltipString', p10_tt,'callback',@p10_call);
    function p10_call(varargin)
        if(isfield(h,'cb_features')) % check if features exist
            set(h.cb_features, 'Value', 0);
            set(h.cb_features(std(feature_data)~=0), 'Value', 1);
            p1_call;
        end
    end

%% feature selection method execture pushbutton
p11_tt = 'Executes the feature selection method that is selected in the radiobutton group';
h.p11 = uicontrol('style','pushbutton','units','normalized','pos',...
    [x2+0.005+1/8*(x3-(x2+0.005)),0.115,3/4*(x3-(x2+0.005)),0.03],'string','Execute',...
    'fontweight','b', 'TooltipString', p11_tt,'callback',@p11_call,'Interruptible','on');
    function p11_call(varargin)
        if(strcmp(get(h.t(3),'string'),'distances computed'))
            vals = get(h.rb_feature_selection_method,'Value');
            checked = find([vals{:}]);
            set(h.rb_feature_selection_method(:),'backgroundcolor','default','fontweight','n')
            % we limit the user in selecting the possible options
            %p5_call;
            set([h.p0,h.p1,h.p2,h.p3,h.p4,h.p5,h.p6,h.p7,h.p8,h.p9,h.p10,h.p12,h.p13,h.p14,h.p15,h.p16,h.p18,h.cb_features,h.cb_labels,h.rb_samedistribution,h.rb_diffdistribution,h.cb_plots,h.popup1,h.popup2],'enable','off');
            if(checked==1) %jacobs magical mystery tour
                if(~isempty(str2num(get(h.t(10),'string')))&&strcmp(get(h.t(3),'string'),'distances computed'))
                    if(strcmp(get(h.p11,'string'),'Execute'))
                        set(h.p11,'string','Cancel');
                        [transformed_data, distance_same, distance_diff, parameters_same, parameters_diff] = jacob_feature_selection(h,feature_data,loc);
                        
                        checked_data = check_features_call(h.cb_features,h.t,feature_data);
                        [transformed_data, ~,~]= transform_data_call(checked_data,get(h.e1,'String'));
                        
                        labChecks = get(h.cb_labels, 'Value');
                        if size(labChecks) > 1
                            labChecks = [labChecks{:}];
                        elseif isa(labChecks, 'cell')
                            labChecks = cell2mat(labChecks);
                        else
                            labChecks = logical(labChecks);
                        end
                        
                        [distance_same, distance_diff, ~, ~] = metric_call(logical(labChecks),{get(h.popup2,'string'),get(h.popup2,'value')},transformed_data, loc, h.rb_samedistribution, h.rb_diffdistribution);
                        
                        plot_distrib_and_hist;
                        [confusion_matrix, CLLR] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, 1);
                        set(h.t(12),'string',num2str(CLLR))
                        if isa(get(h.cb_labels,'value'), 'cell')
                            post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find(cell2mat(get(h.cb_labels,'value'))))); %display the parameter
                        else
                            post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find((get(h.cb_labels,'value'))))); %display the parameter
                        end
                        set(h.rb_feature_selection_method(1),'backgroundcolor',[.7,.9,.7],'fontweight','b')
                        set(h.p11,'string','Execute');
                    else
                        set(h.p11,'string','Execute');
                    end
                end
            elseif(checked==2)
                if(strcmp(get(h.p11,'string'),'Execute'))
                    set(h.p11,'string','Cancel');
                    % pca based feature selection
                    martinFeatureSelection1(feature_data,loc)
                    set(h.rb_feature_selection_method(2),'backgroundcolor',[.7,.9,.7],'fontweight','b')
                    p1_call; p2_call; p3_call; p5_call;
                    plot_distrib_and_hist;
                    %[confusion_matrix, CLLR] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, 1);
                    %display_performance(confusion_matrix, CLLR, h.t)
                    if isa(get(h.cb_labels,'value'), 'cell')
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find(cell2mat(get(h.cb_labels,'value'))))); %display the parameter
                    else
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find((get(h.cb_labels,'value'))))); %display the parameter
                    end
                    set(h.p11,'string','Execute');
                else
                    set(h.p11,'string','Execute');
                end
            elseif(checked==3)
                if(strcmp(get(h.p11,'string'),'Execute'))
                    set(h.p11,'string','Cancel');
                    % random forest feature selection
                    martinFeatureSelection2(feature_data,loc);
                    set(h.rb_feature_selection_method(3),'backgroundcolor',[.7,.9,.7],'fontweight','b')
                    p1_call; p2_call; p3_call; p5_call;
                    plot_distrib_and_hist;
                    if isa(get(h.cb_labels,'value'), 'cell')
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find(cell2mat(get(h.cb_labels,'value'))))); %display the parameter
                    else
                        post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find((get(h.cb_labels,'value'))))); %display the parameter
                    end
                    set(h.p11,'string','Execute');
                else
                    set(h.p11,'string','Execute');
                end
            elseif(checked==4)
                if(strcmp(get(h.p11,'string'),'Execute'))
                    set(h.p11,'string','Cancel');
                    %% individual discrimination method
                    labChecks = get(h.cb_labels, 'Value');
                    % we set labChecks in the appropriate format
                    if size(labChecks) > 1
                        labChecks = [labChecks{:}];
                    elseif isa(labChecks, 'cell')
                        labChecks = cell2mat(labChecks);
                    else
                        labChecks = logical(labChecks);
                    end
                    % we select all non zero standard deviation features and do the
                    % current transformation to have the appropriate data
                    p10_call; p2_call;
                    
                    temp_lab_cell = get(h.cb_labels,'value');
                    if(~iscell(temp_lab_cell))
                        temp_lab_cell = mat2cell(temp_lab_cell);
                    end
                    
                    if(strcmp(get(h.t(1),'string'),'features selected')&&strcmp(get(h.t(2),'string'),'transformation complete')&&(sum(cell2mat(temp_lab_cell))>0))
                        feature_selection_distance_discrimination_per_feature(h,loc,labChecks, transformed_data,75);
                        [checked_data] = check_features_call(h.cb_features,h.t,feature_data);
                        set(h.rb_feature_selection_method(4),'backgroundcolor',[.7,.9,.7],'fontweight','b');
                        %p5_call;
                        plot_distrib_and_hist;
                        %[confusion_matrix, CLLR] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, 1);
                        %display_performance(confusion_matrix, CLLR, h.t)
                        if isa(get(h.cb_labels,'value'), 'cell')
                            post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find(cell2mat(get(h.cb_labels,'value'))))); %display the parameter
                        else
                            post_params_to_gui(h, parameters_same, parameters_diff, size(distance_diff,2), size(distance_same,2), size(feature_data,1), loc(find((get(h.cb_labels,'value'))))); %display the parameter
                        end
                        p1_call; p2_call; p3_call; p5_call;
                        
                    else
                        disp('something went wrong')
                    end
                    set(h.p11,'string','Execute');
                else
                    set(h.p11,'string','Execute');
                end
            end
            % Again, we allow the user to select all the possible options
            set([h.p0,h.p1,h.p2,h.p3,h.p4,h.p5,h.p6,h.p7,h.p8,h.p9,h.p10,h.p12,h.p13,h.p14,h.p15,h.p16,h.cb_features,h.cb_labels,h.cb_plots,h.popup1,h.popup2],'enable','on');
        end
    end

%% export population parameters pushbutton
p12_tt = 'Exports a .txt file containing all the performed steps. This .txt file can be used to reconstruct a workflow.';
h.p12 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x4,0.20,(0.99-x3-0.02-0.03)/4,0.035],'string','Exp. Pop. Parameters',...
    'fontweight','b','fontsize',9, 'TooltipString', p12_tt, 'callback', @p12_call);
    function p12_call(varargin)
        if(~strcmp('...',get(h.t(11),'string')))
            vals = get(h.rb_samedistribution,'Value');
            checked = [vals{:}];
            distribution_same = get(h.rb_samedistribution(logical(checked)), 'String');
            %get different distribution
            vals = get(h.rb_diffdistribution,'Value'); checked = [vals{:}];
            distribution_diff = get(h.rb_diffdistribution(logical(checked)),'String');
            wrkflw = get(h.e1,'String');
            temp_labs_var = get(h.cb_labels, 'Value');
            if ~isa(temp_labs_var, 'cell')
                temp_labs_var = {temp_labs_var};
            end
            labels_active = cell2mat(temp_labs_var);
            
            [exportLocaion, successFlag] = exportPopParams(wrkflw, distribution_same,distribution_diff,labels_active, 'txt');
            if successFlag
                disp('Successfully exported population model');
                h.currentPopModelLoc = exportLocaion;
                set(h.p12, 'string', 'Population Exported');
                pause(0.5);
                set(h.p12, 'string', 'Export Population Parameters');
            end
            
            uiresume(gcf);
        end
    end

%% data overview plot pushbutton
p13_tt = 'Plots the figures selected in the checkboxes in separate windoes. These provice an overview of the data.';
h.p13 = uicontrol('style','pushbutton','units','normalized','pos',...
    [x2+0.005,0.005,x3-(x2+0.005),0.03], 'TooltipString', p13_tt,'string','Plot data overview',...
    'fontweight','b','callback',@p13_call);
    function p13_call(varargin)
        if(strcmp(get(h.t(2),'string'),'transformation complete')&&get(h.cb_data_overview(1),'value')==1)
            boxplot_transformed_data( transformed_data, h.cb_features )
        end
        
        if(strcmp(get(h.t(2),'string'),'transformation complete')&&get(h.cb_data_overview(2),'value')==1)
            lineplot_transformed_data( transformed_data, h.cb_features, loc, h.cb_labels)
        end
        
        if(strcmp(get(h.t(2),'string'),'transformation complete')&&get(h.cb_data_overview(3),'value')==1)
            heatmap_transformed_data( transformed_data, h.cb_features )
        end
    end

%% evaluate validation samples pushbutton

p14_tt = ['do some stuff!!'];
h.p14 = uicontrol('style','pushbutton','TooltipString', p14_tt,'units', 'normalized',...
    'pos',[x4,0.16,(0.99-x3-0.02-0.03)/4,0.035],'string','Eval. Validation Samples',...
    'fontweight','b','fontsize',9, 'callback', @p_14_call);
    function p_14_call(varargin)
        if(~strcmp('...',get(h.t(11),'string')))
            % get different and same distribution
            vals = get(h.rb_samedistribution,'Value'); checked = [vals{:}];
            distribution_same = get(h.rb_samedistribution(logical(checked)), 'String');
            vals = get(h.rb_diffdistribution,'Value'); checked = [vals{:}];
            distribution_diff = get(h.rb_diffdistribution(logical(checked)),'String');
            % get the workflow
            wrkflw = get(h.e1,'String');
            temp_labs_var = get(h.cb_labels, 'Value');
            if ~isa(temp_labs_var, 'cell')
                temp_labs_var = {temp_labs_var};
            end
            labels_active = cell2mat(temp_labs_var);
            [population_data, successFlag] = exportPopParams(wrkflw, distribution_same, distribution_diff, labels_active, 'consolidate');
            if successFlag
                [a,b] = uigetfile('*.csv','Select the case file containing unlabeled data');
                if isnumeric(a)
                    disp('invalid file location!');
                else
                    path2caseFile = [b,a];
                    [case_data, caseNumbers, featureNames] = parseCase(path2caseFile);
                    okToProceed = testCasetoPopValidity(population_data, case_data, featureNames);
                    if okToProceed
                        [dCell, d] = generateDistsFromPair(case_data, population_data, featureNames, caseNumbers);
                        lr = NaN(numel(d),1);%preallocate
                    else
                        error('case file not compatible with reference population');
                    end
                end
            else
                error('population data not complete, invalid workflow or missing parameters');
            end
            
            if exist('dCell','var')
                for i = 1:numel(d);
                    dCell{i,4} = evalLR(d(i), population_data);
                end
                saveValidationResults(dCell);
            end
        end
    end

%% popup list with all the features, possible to select within the popup list
h.p15 = uicontrol('style','pushbutton','units','normalized',...
    'pos',[x1,0.005,0.125,0.030],'string','FEATURES POP UP LIST',...
    'fontweight','b','callback',@p15_call);
    function p15_call(varargin)
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            if(isfield(h,'cb_features')) % check if features exist
                [selection,ok] = pupup_list_features(get(h.cb_features,'string'),get(h.cb_features,'value'));
                if(ok==1)
                    set(h.cb_features(:),'value',0,'backgroundcolor','default','fontweight','n');
                    set(h.cb_features(selection),'value',1);
                    p1_call
                end
            end
        end
    end

%% summary figures plot pushbutton
%[x3+0.02,0.08,(0.99-x3-0.02-0.01)/2,0.06]
h.p16 = uicontrol('style','pushbutton','units','normalized','pos',...
    [x3+0.02,0.005,(0.99-x3-0.02-0.01)/2,0.03],'string','Plot summary figures',...
    'fontweight','b','callback',@p16_call);
    function p16_call(varargin)
        %         if(~(strcmp((get(h.t(10),'string')),'...'))&&get(h.cb_summary_figures(1),'value')==1)
        %             %ece plot
        %         end
        
        if(~(strcmp((get(h.t(10),'string')),'...'))&&get(h.cb_summary_figures(1),'value')==1)
            % hist and dist
            figure('name','histogram and distributions')
            plot_distrib_and_hist;
        end
        
        if(~(strcmp((get(h.t(10),'string')),'...'))&&get(h.cb_summary_figures(2),'value')==1)
            % roc curve
            [labels, LRs] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, false);
            plotROC(LRs, labels);
        end
        
        if(~(strcmp((get(h.t(10),'string')),'...'))&&get(h.cb_summary_figures(3),'value')==1)
            % tippett plot
            [labels, LRs] = eval_performance_ofFit(distance_same, distance_diff, parameters_same, parameters_diff, h.rb_samedistribution, h.rb_diffdistribution, false);
            plotTippet(LRs(labels==1),LRs(labels==0));
        end
    end

%% recover previous workflow
    function p17_call(varargin)
        if(~isempty(get(h.t(sum([get(h.t(13),'value'),get(h.t(16),'value')].*[13,16])),'UserData')))
            recover_old_workflow(get(h.t(sum([get(h.t(10),'value'),get(h.t(13),'value'),get(h.t(16),'value')].*[10,13,16])),'UserData'));
            p1_call;
            p2_call;
            p3_call;
            p5_call;
        end
    end

%% create popup menus
%% popup menu for different transformations
trans_names = ['exp  ';'-mean';'norm ';'log  ';'log10';'sqrt ';'/std '];
h.popup1 = uicontrol('style','popupmenu', 'string', trans_names, ...
    'units','normalized','pos',[x2+0.005,0.28,(x3-(x2+0.01))/2,0.425],'HandleVisibility','on');
%% pop up for different distance metrics
metric_names = ['absolute dif';'bray-curtis ';'cannbera    ';'chebychev   ';'cityblock   ';'correlation ';'cosine      ';'euclidean   ';'mahalanobis '; 'minkowski   '];
h.popup2= uicontrol('style','popupmenu', 'string', metric_names, ...
    'units','normalized','pos',[x2+0.005,0.38,(x3-(x2+0.01))/2,0.040],'HandleVisibility','on');

%% workflow text edit, this is selectable but can not be manually edited. Only set by the use of the dropdowns.
h.e1 = uicontrol('style','text','units','normalized',...
    'pos',[x2+0.005,0.565,x3-(x2+0.005),0.09],'string','data','fontsize',10,'fontweight','b');

%% manual selection of KDE bandwith same source
h.e2 = uicontrol('style','edit','units','normalized',...
    'pos',[x3+0.02 + (0.99-x3-0.02-0.01)/2-0.04 + 0.005 ,0.325,0.035,0.035],'string','0','fontsize',9);

%% manual selection of KDE bandwith different source distribution
h.e3 = uicontrol('style','edit','units','normalized',...
    'pos',[x3+0.02+0.02+2*(0.99-x3-0.02-0.03)/4 + + (0.99-x3-0.02-0.01)/2-0.04 + 0.005,0.325,0.035,0.035],'string','0','fontsize',9);

%% load scores button on top of the screen
h.p18 = uicontrol('style','pushbutton','units','normalized','pos',[x1+0.065,0.97,0.06,0.025],'string','Load Scores',...
    'fontweight','b','callback',@p18_call);
    function p18_call(varargin)
        if ~checkThings
            error('It is possible that you are using an illegal copy of this application. Limited time or site license expired. If you feel you have recieved this message in error contact <m.lopatka@uva.nl> or <j.c.dezoete@uva.nl>');
        else
            set(h.t(21),'string','no data/scores loaded','backgroundcolor',[.8,.3,.3])
            % the load scores stuff
            
            [fileName,path2File] = uigetfile({'*.mat;*.xls;*.csv;*.dat;*.txt'},'Please select the data file containing precomputed pairwise scores to use this session');
            if (fileName(1) == 0) && (path2File(1) == 0)
                disp('File loading operation canceled.');
            else
                set([h.p1,h.p2,h.p3,h.p6,h.p7,h.p8,h.p9,h.p10,h.p11,h.p13,h.p15,...
                h.popup1,h.popup2,h.e1,h.rb_feature_selection_method(1:4),h.cb_data_overview(1:3)],'enable','off')
            %set([h.bg_feature_selection,h.bg_data_overview h.t(1:3)],'visible','off')
                set(h.t(10:18),'string','...');
                set(h.t(20),'string','final model information');
                set(h.t(21),'string','scores loaded','backgroundcolor',[.7,.9,.7])
                set([h.cb_plots(:);h.rb_samedistribution(:);h.rb_diffdistribution(:);h.rb_feature_selection_method(:)],'fontweight','n','backgroundcolor','default');
                cla(h.ax1)
                set(h.t(10),'userData',[]);
                set(h.t(13),'enable','off','userData',[]);
                set(h.t(16),'enable','off','userData',[]);
            
                [score_data, labels_s] = parseDataScores([path2File,fileName]);
                
                distance_same = score_data(labels_s == 0);
                distance_diff = score_data(labels_s == 1);
                cla(h.ax1);
                set([h.rb_diffdistribution(:);h.rb_samedistribution(:);h.cb_plots(:)],'backgroundcolor','default','fontweight','n');
                %set(h.cb_labels(labChecks==1),'backgroundcolor',[.7,.9,.7],'fontweight','b');
                %`set(h.t(3),'backgroundcolor',[.7,.9,.7],'string',message);
                %loc = labsConvert(labels);
                %[s_features,new_order] = sort(featureNames);
                %feature_data=feature_data(:,new_order);
                %         numb_of_features = length(feature_data);
            end    
            
            % set everything to default colors and values, make
           
        end
    end
end
