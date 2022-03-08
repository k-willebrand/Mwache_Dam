%% MUTLIFLEX SDP CLIMATE SENSTIVITY PLOTS

% the plots below investigate the sensitivity of optimal infrastructure and
% expansion decisions to the following parameters:

% (1) discount rate (costParam.discountrate)
% (2) initial percent higher cost for flexible dam (costParam.percFlex)
% (3) percent higher cost for flexible dam expansion (costParam.percFlexExp)

%% SETUP: state senstivity to which parameter we are interested in

test = "discount"; % options: {'discount', 'percFlex', 'percFlexExp'}

%% Load and store the sensitivity data

% === discont rate senstivity data ===
cd('C:\Users\kcuw9\Documents\Mwache_Dam\')
folder = 'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount';

for z = 1:2 % for adaptive and non-adaptive reservoir operations
    
    % Identify the relevant files for sensitivity analysis
    % NOTE: replace the folder name to the local folder containing the cluster shortage cost files
    if z == 1
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc*.mat'));
    elseif z == 2
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc*.mat'));
    end
    
    % find which storage files are in the folder (unique)
    discount_name = zeros(length(cluster_files),1);
    for i = 1:length(cluster_files)
        index_file_name = cluster_files(i).name;
        indices = str2double(regexp(index_file_name,'\d+','match'));
        discount_name(i) = indices(6);
    end
    
    discount_tests = sort(unique(discount_name));
    n = length(discount_tests); % number of storage capacities considered
    
    % Preallocate final combined variables
    optStatic = NaN(n,1,2);
    optFlex = NaN(n,3,2);
    optPlan = NaN(n,3,2);
    optAction = cell(n,1,2);
    optX = cell(n,1);
    optDamCostTime = cell(n,1,2);
    optTotalCostTime = cell(n,1,2);
end

for z = 1:2
    for i = 1:n
        discountRate = discount_tests(i);
        if z == 1
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc',...
                string(discountRate),'.mat'))
        else
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc',...
                string(discountRate),'.mat'))
        end
        optStatic(i,1,z) = bestAct(2);
        optFlex(i,1:3,z) = bestAct(3:5);
        optPlan(i,1:3,z) = bestAct(8:10);
        optAction{i,1,z} = action;
        optX{i,1,z} = X;
        optDamCostTime{i,1,z} = damCostTime;
        optTotalCostTime{i,1,z} = totalCostTime;
    end
end

sens_discount = struct;
sens_discount.values = discount_tests;
sens_discount.optStatic = optStatic;
sens_discount.optPlan= optPlan;
sens_discount.optFlex = optFlex;
sens_discount.optAction = optAction;
sens_discount.optX = optX;
sens_discount.optDamCostTime = optDamCostTime;
sens_discount.optTotalCostTime = optTotalCostTime;


% ===  percFlex sensitivity data ===

% Load the data
cd('C:\Users\kcuw9\Documents\Mwache_Dam\')
folder = 'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_percFlex';

for z = 1:2 % for adaptive and non-adaptive reservoir operations
    
    % Identify the relevant files for sensitivity analysis
    % NOTE: replace the folder name to the local folder containing the cluster shortage cost files
    if z == 1
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex*_percExp15_disc3.mat'));
    elseif z == 2
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex*_percExp15_disc3.mat'));
    end
    
    % find which storage files are in the folder (unique)
    percFlex_name = zeros(length(cluster_files),1);
    for i = 1:length(cluster_files)
        index_file_name = cluster_files(i).name;
        indices = str2double(regexp(index_file_name,'\d+','match'));
        percFlex_name(i) = indices(4);
    end
    percFlex_tests = sort(unique(percFlex_name));
    n = length(percFlex_tests); % number of storage capacities considered
    
    % Preallocate final combined variables
    optStatic = NaN(n,1,2);
    optFlex = NaN(n,3,2);
    optPlan = NaN(n,3,2);
    optAction = cell(n,1,2);
    optX = cell(n,1);
    optDamCostTime = cell(n,1,2);
    optTotalCostTime = cell(n,1,2);
end

for z = 1:2
    for i = 1:n
        percFlex = percFlex_tests(i);
        if z == 1
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex',string(percFlex),'_percExp15_disc3.mat'))
        else
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex',string(percFlex),'_percExp15_disc3.mat'))
        end
        optStatic(i,1,z) = bestAct(2);
        optFlex(i,1:3,z) = bestAct(3:5);
        optPlan(i,1:3,z) = bestAct(8:10);
        optAction{i,1,z} = action;
        optX{i,1,z} = X;
        optDamCostTime{i,1,z} = damCostTime;
        optTotalCostTime{i,1,z} = totalCostTime;
    end
end

sens_percFlex = struct;
percFlex_tests(percFlex_tests == 75) = 7.5;
sens_percFlex.values = sort(percFlex_tests);
sens_percFlex.optStatic = optStatic;
sens_percFlex.optFlex = optFlex;
sens_percFlex.optPlan= optPlan;
sens_percFlex.optAction = optAction;
sens_percFlex.optX = optX;
sens_percFlex.optDamCostTime = optDamCostTime;
sens_percFlex.optTotalCostTime = optTotalCostTime;

% ===== percFlexExp sensitivity data === 

% Load the data
cd('C:\Users\kcuw9\Documents\Mwache_Dam\')
folder = 'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_percFlexExp';

for z = 1:2 % for adaptive and non-adaptive reservoir operations
    
    % Identify the relevant files for sensitivity analysis
    % NOTE: replace the folder name to the local folder containing the cluster shortage cost files
    if z == 1
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp*_disc3.mat'));
    elseif z == 2
        cluster_files = dir(fullfile(folder,'BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp*_disc3.mat'));
    end
    
    % find which storage files are in the folder (unique)
    percFlexExp_name = zeros(length(cluster_files),1);
    for i = 1:length(cluster_files)
        index_file_name = cluster_files(i).name;
        indices = str2double(regexp(index_file_name,'\d+','match'));
        percFlexExp_name(i) = indices(5);
    end
    
    percFlexExp_tests = sort(unique(percFlexExp_name));
    n = length(percFlexExp_tests); % number of storage capacities considered
    
    % Preallocate final combined variables
    optStatic = NaN(n,1,2);
    optFlex = NaN(n,3,2);
    optPlan = NaN(n,3,2);
    optAction = cell(n,1,2);
    optX = cell(n,1);
    optDamCostTime = cell(n,1,2);
    optTotalCostTime = cell(n,1,2);
end

for z = 1:2
    for i = 1:n
        percFlexExp = percFlexExp_tests(i);
        if z == 1
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp',...
                string(percFlexExp),'_disc3.mat'))
        else
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp',...
                string(percFlexExp),'_disc3.mat'))
        end
        optStatic(i,1,z) = bestAct(2);
        optFlex(i,1:3,z) = bestAct(3:5);
        optPlan(i,1:3,z) = bestAct(8:10);
        optAction{i,1,z} = action;
        optX{i,1,z} = X;
        optDamCostTime{i,1,z} = damCostTime;
        optTotalCostTime{i,1,z} = totalCostTime;
    end
end

sens_percFlexExp = struct;
sens_percFlexExp.values = percFlexExp_tests;
sens_percFlexExp.optStatic = optStatic;
sens_percFlexExp.optPlan= optPlan;
sens_percFlexExp.optFlex = optFlex;
sens_percFlexExp.optAction = optAction;
sens_percFlexExp.optX = optX;
sens_percFlexExp.optDamCostTime = optDamCostTime;
sens_percFlexExp.optTotalCostTime = optTotalCostTime;

%% USE SETUP TO DEFINE VARIABLES

test_values = eval(strcat('sens_',test,'.values'));
optStatic = eval(strcat('sens_',test,'.optStatic'));
optFlex = eval(strcat('sens_',test,'.optFlex'));
optPlan = eval(strcat('sens_',test,'.optPlan'));
optAction = eval(strcat('sens_',test,'.optAction'));
optX = eval(strcat('sens_',test,'.optX'));
optDamCostTime = eval(strcat('sens_',test,'.optDamCostTime'));
optTotalCostTime = eval(strcat('sens_',test,'.optTotalCostTime'));

%% PLOTS - SIMPLE OPTIMAL DAM DESIGN (SINGLE DISCOUNT RATE AT A TIME)

folder = 'Nov02optimal_dam_design_discount'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/SDP_sensitivity_tests/')

load(strcat(folder,'/BestFlex_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
bestAct_adapt = bestAct;
V_adapt = V;
Vs_adapt = Vs;
Vd_adapt = Vd;
X_adapt = X;
C_adapt = C_state;
action_adapt = action;
totalCostTime_adapt = totalCostTime;
damCostTime_adapt = damCostTime;
P_state_adapt = P_state;
bestVal_flex_adapt = bestVal_flex;
bestVal_static_adapt = bestVal_static;
bestVal_plan_adapt = bestVal_plan;
if bestAct(3) + bestAct(4)*bestAct(5) > 150
    bestAct_adapt(4) = (150 - bestAct(2))/bestAct(5);
end
if bestAct(8) + bestAct(9)*bestAct(10) > 150
    bestAct_adapt(9) = (150 - bestAct(8))/bestAct(10);
end


load(strcat(folder,'/BestFlex_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
bestAct_nonadapt = bestAct;
V_nonadapt = V;
Vs_nonadapt = Vs;
Vd_nonadapt = Vd;
X_nonadapt = X;
C_nonadapt = C_state;
action_nonadapt = action;
totalCostTime_nonadapt = totalCostTime;
damCostTime_nonadapt = damCostTime;
P_state_nonadapt = P_state;
bestVal_flex_nonadapt = bestVal_flex;
bestVal_static_nonadapt = bestVal_static;
bestVal_plan_nonadapt = bestVal_plan;
if bestAct(3) + bestAct(4)*bestAct(5) > 150
    bestAct_nonadapt(4) = (150 - bestAct(2))/bestAct(5);
end
if bestAct(8) + bestAct(9)*bestAct(10) > 150
    bestAct_nonadapt(9) = (150 - bestAct(8))/bestAct(10);
end


% Bar plot optimal dam design capacities


% facecolors = [[90, 90, 90]; [153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
%     [255, 102, 102]; [255, 153, 153]]/255;
% 
% facecolors_exp = [[90, 90, 89]; [153,204,203]; [204,255,254]; [153, 153, 203]; [204, 204, 254];...
%     [255, 102, 101]; [255, 153, 152]]/255;


facecolors = [[90, 90, 90]; [153,204,204]; [191,223,223]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

facecolors_exp = [[90, 90, 89]; [153,204,203]; [191,223,223]; [153, 153, 203]; [204, 204, 254];...
    [255, 102, 101]; [255, 153, 152]]/255;

capacities = [[0 bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3) bestAct_adapt(3) ...
    bestAct_nonadapt(8) bestAct_adapt(8)];[0 0 0 bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
    bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
    bestAct_adapt(9)*bestAct_adapt(10)]]';

figure;
b = bar(capacities,'stacked', 'FaceColor','flat','LineWidth',1.5);

for i = 1:7
    b(1).CData(i,:) = facecolors(i,:);
    b(2).CData(i,:) = facecolors_exp(i,:);
end

hold on
yl = yline(150,'LineStyle',':','color',[0.1 0.1 0.1],'Label','Max Capacity');
yl.LabelHorizontalAlignment = 'left';
yl.FontSize = 18;
set(gca, 'XTick', [1 2 3 4 5 6]+1)
yl = ylim;
ylim([0, yl(2)+25])

set(gca,'XTickLabel',{strcat('Static Ops.'),...
    strcat('Flexible Ops.'),...
    strcat('Static Ops.'),...
    strcat('Flexible Ops.'),...
    strcat('Static Ops.'),...
    strcat('Flexible Ops.')},'fontsize',20);

ax = gca;
ax.LineWidth = 1.5;

ylabel('Dam Capacity (MCM)','FontWeight','bold','FontSize',20)
xlim([1.5,7.5])
title('Discount Rate: 6%','FontSize',22)
% legend('Initial Dam Capacity','Maximum Expanded Capacity',...
%     'Orientation','horizontal','Location','eastoutside')
% %legend('Initial Dam\newlineCapacity','Maximum Expanded\newlineDam Capacity','Location','eastoutside')

% add lables with intial dam cost
xtips = [1 2 3 4 5 6]+1;
ytips = [bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
    bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
    bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)];
labels = {strcat('$',string(round(damCostTime_nonadapt(1,1,2)/1E6,1)),'M'),...
    strcat('$',string(round(damCostTime_adapt(1,1,2)/1E6,1)),'M'),...
    strcat('$',string(round(damCostTime_nonadapt(1,1,1)/1E6,1)),'M'),...
    strcat('$',string(round(damCostTime_adapt(1,1,1)/1E6,1)),'M'),...
    strcat('$',string(round(damCostTime_nonadapt(1,1,3)/1E6,1)),'M'),...
    strcat('$',string(round(damCostTime_nonadapt(1,1,3)/1E6,1)),'M')};
    
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',18)
 
 font_size = 26;
 ax = gca;
 allaxes = findall(f, 'type', 'axes');
 set(allaxes,'FontSize', font_size)
 set(findall(allaxes,'type','text'),'FontSize', font_size)
    
figure_width = 25;
figure_height = 4.5;


% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(gcf, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);


%im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
%    1-makehatch_plus('\',6),makehatch_plus('\',1),1-makehatch_plus('\',6),makehatch_plus('\',1)},facecolors);
im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
    makehatch_plus('\\40',50), makehatch_plus('\',1), makehatch_plus('\\40',50), ...
    makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1),...
    makehatch_plus('\\40',50),makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1)},...
    [facecolors(2:4,:); facecolors_exp(4,:); facecolors(5,:); facecolors_exp(5,:); facecolors(6,:); facecolors_exp(6,:);...
    facecolors(7,:); facecolors_exp(7,:);facecolors(1,:); facecolors_exp(1,:)],[],300);


%% == Generate a Pseudo-Plot to create legend == 
capacities = [1 1];

figure;
b1 = bar(1,capacities(1),'FaceColor',facecolors(1,:));
%b1.CData(1,:) = facecolors(1,:);
hold on
b2 = bar(2,capacities(2),'FaceColor',facecolors_exp(1,:));
%b2.CData(2,:) = facecolors_exp(1,:);

legend([b1 b2],{'Initial Dam Capacity','Maximum Expanded Capacity'},...
    'Orientation','horizontal','Location','eastoutside')
 
 font_size = 26;
 ax = gca;
 allaxes = findall(f, 'type', 'axes');
 set(allaxes,'FontSize', font_size)
 set(findall(allaxes,'type','text'),'FontSize', font_size)
    
figure_width = 15;
figure_height = 4.5;


% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(gcf, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);


%im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
%    1-makehatch_plus('\',6),makehatch_plus('\',1),1-makehatch_plus('\',6),makehatch_plus('\',1)},facecolors);
im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\\15',20),makehatch_plus('\',1)},...
    [facecolors(1,:); facecolors_exp(1,:)],[],300);



%% PLOTS - DIFFERENCE IN OPTIMAL DAM DESIGN

facecolors = [[90, 90, 90]; [153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

facecolors_exp = [[90, 90, 89]; [153,204,203]; [204,255,254]; [153, 153, 203]; [204, 204, 254];...
    [255, 102, 101]; [255, 153, 152]]/255;

filenames = cell(1,length(test_values));

for t = 1:length(test_values)
    
figure(1);

capacities = [[0 optStatic(t,1,1) optStatic(t,1,2) optFlex(t,1,1) optFlex(t,1,2)...
    optPlan(t,1,1) optPlan(t,1,2)];[0 0 0 optFlex(t,2,1)*optFlex(t,3,1) ...
    optFlex(t,2,2)*optFlex(t,3,2) optPlan(t,2,1)*optPlan(t,3,1) ...
    optPlan(t,2,2)*optPlan(t,3,2)]]';

b = bar(capacities,'stacked', 'FaceColor','flat');

for i = 1:7
    b(1).CData(i,:) = facecolors(i,:);
    b(2).CData(i,:) = facecolors_exp(i,:);
end

hold on
if optStatic(t,1,1) == 150
    yl = yline(150,'LineStyle',':','color',[0.1 0.1 0.1]);
else
    yl = yline(150,'LineStyle',':','color',[0.1 0.1 0.1],'Label','Max Capacity');
end
yl.LabelHorizontalAlignment = 'left';
yl.FontSize = 8;
set(gca, 'XTick', [1 2 3 4 5 6]+1)
yl = ylim;
ylim([0, yl(2)+10])

set(gca,'XTickLabel',{strcat('Non-flexible Operations\newline      & Static Dam'),...
    strcat('Flexible Operations\newline      & Static Dam'),...
    strcat('Non-flexible Operations\newline   & Flexible Design'),...
    strcat('Flexible Operations\newline & Flexible Design'),...
    strcat('Non-flexible Operations\newline  & Flexible Planning'),...
    strcat('Flexible Operations\newline& Flexible Planning')});

ylabel('Optimal Dam Design Capacity (MCM)','FontWeight','bold')
xlabel('Dam Alternative','FontWeight','bold')
xlim([1.5,7.5])
if test == "discount"
    title(strcat("Discount Rate: ", num2str(test_values(t)),"%"),'FontWeight','bold')
elseif test == "percFlex"
        title(strcat("Flexible Design Preimum: ", num2str(test_values(t)),"%"),'FontWeight','bold')
end
legend('Initial Dam\newlineCapacity','Maximum Expanded\newlineDam Capacity',...
    'Orientation','horizontal','Location','southoutside')
%legend('Initial Dam\newlineCapacity','Maximum Expanded\newlineDam Capacity','Location','eastoutside')

% add lables with intial dam cost
xtips = [1 2 3 4 5 6]+1;
ytips = [optStatic(t,1,1) optStatic(t,1,2) optFlex(t,1,1)+optFlex(t,2,1)*optFlex(t,3,1) ...
    optFlex(t,1,2)+optFlex(t,2,2)*optFlex(t,3,2) optPlan(t,1,1)+optPlan(t,2,1)*optPlan(t,3,1) ...
    optPlan(t,1,2)+optPlan(t,2,2)*optPlan(t,3,2)];
labels = {strcat('Initial Cost: $',string(round(optDamCostTime{t,1,1}(1,1,2)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(optDamCostTime{t,1,2}(1,1,2)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(optDamCostTime{t,1,1}(1,1,1)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(optDamCostTime{t,1,2}(1,1,1)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(optDamCostTime{t,1,1}(1,1,1)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(optDamCostTime{t,1,2}(1,1,1)/1E6,1)),'M')};
    
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',9)

figure_width = 18;
figure_height = 6;


% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(gcf, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);


%im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
%    1-makehatch_plus('\',6),makehatch_plus('\',1),1-makehatch_plus('\',6),makehatch_plus('\',1)},facecolors);
im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
    makehatch_plus('\\15',20), makehatch_plus('\',1), makehatch_plus('\\15',20), ...
    makehatch_plus('\',1),makehatch_plus('\\15',20),makehatch_plus('\',1),...
    makehatch_plus('\\15',20),makehatch_plus('\',1),makehatch_plus('\\15',20),makehatch_plus('\',1)},...
    [facecolors(2:4,:); facecolors_exp(4,:); facecolors(5,:); facecolors_exp(5,:); facecolors(6,:); facecolors_exp(6,:);...
    facecolors(7,:); facecolors_exp(7,:);facecolors(1,:); facecolors_exp(1,:)],[],300);

filenames{t} = strcat('C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_sens/percFlex',string(test_values(t)),'_optDesign.png');
exportgraphics(figure(2),filenames{t},'Resolution',1200)

close all
end

% stack figures
fcomb = figure;
out = imtile(filenames,'GridSize',[length(test_values),1],'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
if test == "discount"
    title({'Optimal Dam Design Sensitivity to Discount Rate'},'FontSize',15)
elseif test == "percFlex"
    title({'Optimal Dam Design Sensitivity to Premium Cost'},'FontSize',15)
end
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_sens/discount_sens_flexPlan.png'];
exportgraphics(fcomb,filename,'Resolution',1200)

%% PLOTS - DIFFERENCE FORWARD SIMULATION ACTIONS

%
%% PLOTS - DIFFERENCE IN PERCENTILES COSTS

