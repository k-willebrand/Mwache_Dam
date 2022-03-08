folder = 'Jan28optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
%cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/SDP_sensitivity_tests/')

cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

load(strcat(folder,'/BestFlex_adaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
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


load(strcat(folder,'/BestFlex_nonadaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp2e5_g7_percFlex75_percExp15_disc6.mat'))
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

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

%% CDF of Total Costs with gray shaded background: COMBINED with Inset

bestOption = 0;

%facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",[255, 102, 102]/255,[255, 153, 153]/255};
%facecolors = {[124,152,179]/255,[150,189,217]/255,[153,204,204]/255};
facecolors = {[232,232,232]/255,[205,205,205]/255,[154,154,154]/255};

%P_regret = [68 78 88];

totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_adapt = squeeze(sum(damCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_nonadapt = squeeze(sum(damCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
% damCost_adapt_plan = squeeze(sum(damCostTime_adapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static
% damCost_nonadapt_plan = squeeze(sum(damCostTime_nonadapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static

maxCostPnow_all = zeros(3,1);
minCostPnow_all = zeros(3,1);
meanCostPnow_all = zeros(3,1);

P_ranges = {[66:1:76];[77:1:86];[87:97]};
for j = 1:size(P_ranges)
   P_regret = P_ranges{j};
   
% preallocate matrices
meanCostPnow_adapt = zeros(length(P_regret),3);
meanCostPnow_nonadapt = zeros(length(P_regret),3);
meanCostPnow = zeros(length(P_regret),1);
minCostPnow_adapt = zeros(length(P_regret),3);
minCostPnow_nonadapt = zeros(length(P_regret),3);
minCostPnow = zeros(length(P_regret),1);
maxCostPnow_adapt = zeros(length(P_regret),3);
maxCostPnow_nonadapt = zeros(length(P_regret),3);
maxCostPnow = zeros(length(P_regret),1);

for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    
    
    % total costs
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:);
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:);
   
    % mean total costs
    meanCostPnow_adapt(i,:) = mean(totalCostPnow_adapt,'all');
    meanCostPnow_nonadapt(i,:) = mean(totalCostPnow_nonadapt,'all');
    meanCostPnow(i,:) = mean([meanCostPnow_adapt(i,:),meanCostPnow_nonadapt(i,:)]);
    
    % min total costs
    minCostPnow_adapt(i,:) = min(totalCostPnow_adapt,[],'all');
    minCostPnow_nonadapt(i,:) = min(totalCostPnow_nonadapt,[],'all');
    minCostPnow(i,:) = min([meanCostPnow_adapt(i,:),meanCostPnow_nonadapt(i,:)],[],'all');
    
    % max total costs
    maxCostPnow_adapt(i,:) = max(totalCostPnow_adapt,[],'all');
    maxCostPnow_nonadapt(i,:) = max(totalCostPnow_nonadapt,[],'all');
    maxCostPnow(i,:) = max([meanCostPnow_adapt(i,:),meanCostPnow_nonadapt(i,:)],[],'all');

end

maxCostPnow_all(j) = max(maxCostPnow)/1E6;
minCostPnow_all(j) = min(minCostPnow)/1E6;
meanCostPnow_all(j) = mean(meanCostPnow)/1E6;
end

f = figure;

p1 = patch( [minCostPnow_all(1) minCostPnow_all(1) maxCostPnow_all(1) maxCostPnow_all(1)],  [0 1 1 0], facecolors{1},'LineStyle','none');
p1.FaceVertexAlphaData = 0.0001;
p1.FaceAlpha = 'flat';
hold on

p2 = patch( [minCostPnow_all(2) minCostPnow_all(2) maxCostPnow_all(2) maxCostPnow_all(2)],  [0 1 1 0], facecolors{2},'LineStyle','none');
p2.FaceAlpha = 'flat';
p2.FaceVertexAlphaData = 0.0001;
hold on

p3 = patch( [minCostPnow_all(3) minCostPnow_all(3) maxCostPnow_all(3) maxCostPnow_all(3)],  [0 1 1 0], facecolors{3},'LineStyle','none');
%p3.FaceAlpha = 'flat';
%p3.FaceVertexAlphaData = 0.001;
hold on

% facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",...
%     [255, 102, 102]/255,[255, 153, 153]/255};

facecolors = {[153,204,204]/255,[191,223,223]/255,[153,153,204]/255,[213,213,255]/255,...
     [255, 102, 102]/255,[255, 153, 153]/255};


% load data
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3), 2)); % 1 is flex, 2 is static
totalCostFlex_nonadapt = totalCost_nonadapt(:,1);
totalCostStatic_nonadapt = totalCost_nonadapt(:,2);
totalCostPlan_nonadapt = totalCost_nonadapt(:,3);

totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3), 2));
totalCostFlex_adapt = totalCost_adapt(:,1);
totalCostStatic_adapt = totalCost_adapt(:,2);
totalCostPlan_adapt = totalCost_adapt(:,3);
% 
% totalCost_nonadapt_plan = squeeze(sum(totalCostTime_nonadapt_plan(:,:,1:2), 2)); % 1 is flex, 2 is static
% totalCostFlex_nonadapt_plan = totalCost_nonadapt_plan(:,1);
% 
% totalCost_adapt_plan = squeeze(sum(totalCostTime_adapt_plan(:,:,1:2), 2));
% totalCostFlex_adapt_plan = totalCost_adapt_plan(:,1);

% ===== (1) PLOT CDF ====
hold on
c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 3.5;
c1.Color = facecolors{1};
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 3.5;
c2.Color = facecolors{2};
%c2.Color = facecolors{1};
%c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 3.5;
c3.Color = facecolors{3};
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 3.5;
c4.Color = facecolors{4};
%c4.Color = facecolors{3};
%c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 3.5;
c5.Color = facecolors{5};
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 3.5;
c6.Color = facecolors{6};
%c6.Color = facecolors{5};
%c6.LineStyle = '--';

% legend([c1 c2 c3 c4 c5 c6], {strcat('Static Dam (',num2str(bestAct_nonadapt(2))," MCM)"),...
%     strcat('Flexible Ops & Static Design(',num2str(bestAct_adapt(2))," MCM)"),...
%     strcat('Static Ops & Flexible Design(',num2str(bestAct_nonadapt(3)),"-",...
%     num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
%     strcat('Flexible Ops & Flexible Design(',num2str(bestAct_adapt(3)),"-",...
%     num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
%     strcat('Static Ops & Flexible Planning(',num2str(bestAct_nonadapt(8)),"-",...
%     num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
%     strcat('Flexible Ops & Flexible Planning (',num2str(bestAct_adapt(8)),"-",...
%     num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)")}, 'Location','best')
xlabel('Total Cost (M$)')
ylabel('F(x)')
xlim([0,1000])
% legend boxoff

% hcb = colorbar('TicksMode','manual','Ticks',[0.2, 0.5, 0.8],'TickLabels',...
%     {'Dry Final\newlinePrecip. State)', ...
%     'Moderate Final\newlinePrecip. State', ...
%     'Wet Final\newlinePrecip. State'});
% colorTitleHandle = get(hcb,'Title');
% titleString = 'Cost Range';
% set(colorTitleHandle ,'String',titleString);
% colormap([[232,232,232]/255;[205,205,205]/255;[175,175,175]/255]);

ax = gca;
ax.LineWidth = 3;

ax.XGrid = 'off';
ax.YGrid = 'off';
box on

font_size = 20;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
%legend('FontSize',12, 'Location','northeast','EdgeColor','k')
title('CDF of Simulated Total Cost','FontSize',25,'FontWeight','bold')

figure_width = 28;
figure_height = 11;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
 set(f, 'Position', [100,0, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [figure_width figure_height]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

% == ZOOM IN OF 95+ PERCENTILE COSTS ==

xstart=.45;
xend=.86;
ystart=.22;
yend=.7;
axes('position',[xstart ystart xend-xstart yend-ystart ])
box on

range=90:110% here i am using range from 90 to 110

percentiles = [95;100];

for i = 1
ptile = percentiles(2,i);
p1 = patch( [minCostPnow_all(1) minCostPnow_all(1) maxCostPnow_all(1) maxCostPnow_all(1)],  [0 1 1 0], [232,232,232]/255,'LineStyle','none');
p1.FaceVertexAlphaData = 0.0001;
p1.FaceAlpha = 'flat';
hold on

c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 3;
c1.Color = facecolors{1};
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 3;
c2.Color = facecolors{2};
%c2.Color = facecolors{1};
%c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 3;
c3.Color = facecolors{3};
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 3;
c4.Color = facecolors{4};
%c4.Color = facecolors{3};
%c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 3;
c5.Color = facecolors{5};
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 3;
c6.Color = facecolors{6};
%c6.Color = facecolors{5};
%c6.LineStyle = '--';

xlabel('Total Cost (M$)')
ylabel('F(x)')
ylim([percentiles(1,i), percentiles(2,i)]/100)
xlim([prctile(totalCostStatic_nonadapt/1E6, percentiles(1,i)),1000])
title('')
box on
grid off
ax = gca;
ax.LineWidth = 3;

%xlim([150,1800])

font_size = 18; 
set(gca,'FontSize', font_size)
% set(findall(allaxes,'type','text'),'FontSize', font_size)
end


%% Bar plot of optimal dam design

% Bar plot optimal dam design capacities


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
    strcat('$',string(round(damCostTime_adapt(1,1,3)/1E6,1)),'M')};
    
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

%% Frequency and Extent of Expansion in Forward Sims by Decade


nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[50,140,177]];
nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[50,140,177]];

adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[50,140,177]];
adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[50,140,177]];

for s = 1:2 % for non-adaptive and adaptive operations
    f = figure;
    % specify whether to use adaptive or non-adaptive operations data
    if s == 1 % non-adaptive
        bestAct = bestAct_nonadapt;
        V = V_nonadapt;
        X = X_nonadapt;
        action = action_nonadapt;
    elseif s == 2
        bestAct = bestAct_adapt;
        V = V_adapt;
        X = X_adapt;
        action = action_adapt;
    end
    if bestAct(3) + bestAct(4)*bestAct(5) > 150
        bestAct(4) = (150 - bestAct(3))/bestAct(5);
    end
    
    [R,~,~] = size(action); %size(action{1});
    n = length(unique(action)); % number of actions
    
    %cmap1 = cbrewer('qual', 'Set2', n);
    if s == 1 % nonadaptive
        cmap1 = [[150, 150, 150]; [150, 150, 150]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
    else % adaptive
        cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
    end
    cmap2 = cbrewer('div', 'Spectral',11);
    cmap = cbrewer('qual', 'Set3', n);
    
    % Define range capacity states to consider for optimal flexible dam
    s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
    
    % === SUBPLOT 1: FINAL EXPANSIONS OVER TIME ==
    s_C_bins = s_C - 0.01;
    s_C_bins(end+1) = s_C(end)+0.01;
    
    % Define range capacity states to consider for optimal flexible dam
        s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
        
        % === SUBPLOT 1: INFRASTRUCTURE DECISIONS OVER TIME ==
        subplot(1,10,10-9:10-3)
        s_C_bins = s_C - 0.01;
        s_C_bins(end+1) = s_C(end)+0.01;
        
        clear cPnowCounts cPnowCounts_test
        
        for k=1:5
            cPnowCounts(k,:) = histcounts(action(:,k,4), s_C_bins);
            cPnowCounts_test(k,:) = histcounts(action(:,k,4), s_C_bins);
        end
        
        for j=2:5
            cPnowCounts(j,1) = cPnowCounts(1,1);
            cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4)));
            cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end));
            cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
        end
        
        %colormap(cmap);
        b1 = bar(cPnowCounts, 'stacked');
%         for i=1:length(b1)
%             b1(i).FaceColor = cmap1(i,:);
%         end
        xticklabels(decade);
        xlim([0.5,5.5])
        
        xlabel('Time Period');
        ylabel('Frequency');
        
% == SUBPLOT 2: EXPANSION DECISIONS  ==
        subplot(1,10,10-1:10)
        
        % frequency of 1st decision (flexible or static)
        act1 = action(:,1,end);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % frequency timing of of exp decisions
        actexp = action(:,2:end,3);
        exp1 = sum(actexp(:,1) == s_C(4:end),'all');
        exp2 = sum(actexp(:,2) == s_C(4:end),'all');
        exp3 = sum(actexp(:,3) == s_C(4:end),'all');
        exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
        expnever = R - exp1 - exp2 - exp3 - exp4;
        
        % plot bars
        colormap(cmap)
        b2 = bar([exp1 exp2 exp3 exp4 expnever; nan(1,5)], .8, 'stacked');
        for i = 1:5
            b2(i).FaceColor = cmap2(i+5,:);
        end
        xlim([0.5 1.5])
        xticklabels('Flexible Dam')
        [l1, l3] = legend({decade{1,2:end}, 'never'}, 'FontSize', 9, 'Location',"north");
        title('Expansion Decisions','FontSize',12)
        ylabel('Frequency')
        allaxes = findall(f, 'type', 'axes');
        set(allaxes,'FontSize', 10)
        
        % add title to subplot groups
        if s == 1
            str = {'Non-Adaptive Operations';strcat('Static Dam = ',...
                num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
                num2str(bestAct(4)*bestAct(5))," MCM")};
            sgtitle(str,'FontWeight','bold','FontSize',13);
        elseif s == 2
            str = {'Adaptive Operations';strcat('Static Dam = ',...
                num2str(bestAct(3))," MCM , Flexible Dam= ", num2str(bestAct(2))," + ",...
                num2str(bestAct(4)*bestAct(5))," MCM")};
            sgtitle(str,'FontWeight','bold','FontSize',13)
        end
end

%% Discount rate expansions

for d = 1:3
    
    subplot(
    act1 = action(:,1,end);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % frequency timing of of exp decisions
        actexp = action(:,2:end,3);
        exp1 = sum(actexp(:,1) == s_C(4:end),'all');
        exp2 = sum(actexp(:,2) == s_C(4:end),'all');
        exp3 = sum(actexp(:,3) == s_C(4:end),'all');
        exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
        expnever = R - exp1 - exp2 - exp3 - exp4;
        
        % plot bars
        colormap(cmap)
        b2 = bar([exp1 exp2 exp3 exp4 expnever; nan(1,5)], .8, 'stacked');
        for i = 1:5
            b2(i).FaceColor = cmap2(i+5,:);
        end
        xlim([0.5 1.5])
        xticklabels('Flexible Dam')
        [l1, l3] = legend({decade{1,2:end}, 'never'}, 'FontSize', 9, 'Location',"north");
        title('Expansion Decisions','FontSize',12)
        ylabel('Frequency')
        allaxes = findall(f, 'type', 'axes');
        set(allaxes,'FontSize', 10)
        
%% Single Subplot: Frequency and Extent of Expansion in Forward Sims
% (Highlights from Jenny's Plots using same blue colors)

% Run for 3% then 6% discount rate and combine figures in powerpoint

f = figure;

nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];

adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];

for s = 1:2 % for non-adaptive and adaptive operations
    
    % specify whether to use adaptive or non-adaptive operations data
    if s == 1 % non-adaptive
        bestAct = bestAct_nonadapt;
        V = V_nonadapt;
        X = X_nonadapt;
        action = action_nonadapt;
    elseif s == 2
        bestAct = bestAct_adapt;
        V = V_adapt;
        X = X_adapt;
        action = action_adapt;
    end
    if bestAct(3) + bestAct(4)*bestAct(5) > 150
        bestAct(4) = (150 - bestAct(3))/bestAct(5);
    end
    
    [R,~,~] = size(action); %size(action{1});
    n = length(unique(action)); % number of actions
    
    %cmap1 = cbrewer('qual', 'Set2', n);
    if s == 1 % nonadaptive
        cmap1 = [[150, 150, 150]; [150, 150, 150]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
    else % adaptive
        cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
    end
    cmap2 = cbrewer('div', 'Spectral',11);
    cmap = cbrewer('qual', 'Set3', n);
    
    % Define range capacity states to consider for optimal flexible dam
    s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
    
    % === SUBPLOT 1: FINAL EXPANSIONS OVER TIME ==
    s_C_bins = s_C - 0.01;
    s_C_bins(end+1) = s_C(end)+0.01;
    
    clear cPnowCounts cPnowCounts_test
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
    for k=1:5
        cPnowCounts(k,:) = histcounts(action(:,k,t), s_C_bins);
        cPnowCounts_test(k,:) = histcounts(action(:,k,t), s_C_bins);
    end
    
    for j=2:5
        cPnowCounts(j,1) = cPnowCounts(1,1);
        cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4)));
        cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end));
        cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
    end
    cPnowCounts = cPnowCounts./10000.*100; % convert counts to percent
    
    colormap(cmap);
    %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat',...
        'LineWidth',1);
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    hold on
    end
    
    xticklabels(decade);
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
        'Static Ops.';'Flexible Ops.'},'FontSize',22)

    ylabel('Simulations (%)','FontSize',22);
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5))," MCM")};
    end
    for r = 1:bestAct(9)
        planExp_labels(r) = {strcat("+", num2str(r*bestAct(10))," MCM{   }")};
    end
    
    h=get(gca,'Children');
    capState = {"Unexpanded{   }", planExp_labels{:}};
    if s == 1
    l = legend([b1([1 6:10])],capState,'Orientation','horizontal',...
    'Location','southoutside','FontSize',10,'AutoUpdate','off');
    l.ItemTokenSize(1) = 60;
    l.Position == l.Position + [-0.15 -0.15 0 0.05];

    box
    end
    
    ax = gca;
    ax.LineWidth = 1.5;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box on
    allaxes = findall(f, 'type', 'axes');
    title({'Discount Rate: 3%'},'FontSize',25)
end


% set figure size
figure_width = 25;
figure_height =5;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(f, 'Position', [100, 10, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

%% Overall total dam and shortage costs for each discount rate and flexible alternative (I THINK THIS DOES NOT MAKE SENSE...)

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

folder = 'Jan28optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

disc_vals = string([0, 3, 6]);
cp_vals = ["125e6", "6e6", "2e5"];
figure()
for d=1:3
    
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',cp_vals(d),'_g7_percFlex75_percExp15_disc',disc_vals(d),'.mat'))
totalCostTime_adapt = totalCostTime;
damCostTime_adapt = damCostTime;
bestAct_adapt = bestAct;

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',cp_vals(d),'_g7_percFlex75_percExp15_disc',disc_vals(d),'.mat'))
totalCostTime_nonadapt = totalCostTime;
damCostTime_nonadapt = damCostTime;
bestAct_nonadapt = bestAct;

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

% Shortage Cost Time: select associated simulations
shortageCost_adapt = mean(sum(totalCost_adapt(:,:,:)-damCost_adapt(:,:,:),2));
shortageCost_nonadapt = mean(sum(totalCost_nonadapt(:,:,:)-damCost_nonadapt(:,:,:),2)); 
initDamCost_adapt = mean(damCost_adapt(:,1,:)); % first time period building cost
initDamCost_nonadapt = mean(damCost_nonadapt(:,1,:)); % first time period building cost
expandDamCost_adapt = mean(sum(damCost_adapt(:,2:5,:),2));
expandDamCost_nonadapt = mean(sum(damCost_nonadapt(:,2:5,:),2));

% PLOT
subplot(3,1,d)
allRows_comb = zeros(1,6,3);
    allRows_comb(1,1:6,1) = [initDamCost_nonadapt(1,1,2), initDamCost_adapt(1,1,2), initDamCost_nonadapt(1,1,1),...
        initDamCost_adapt(1,1,1), initDamCost_nonadapt(1,1,3), initDamCost_adapt(1,1,3)];
    allRows_comb(1,1:6,2) = [expandDamCost_nonadapt(1,1,2), expandDamCost_adapt(1,1,2), expandDamCost_nonadapt(1,1,1),...
        expandDamCost_adapt(1,1,1), expandDamCost_nonadapt(1,1,3), expandDamCost_adapt(1,1,3)];
    allRows_comb(1,1:6,3) = [ shortageCost_nonadapt(1,1,2), shortageCost_adapt(1,1,2),...
        shortageCost_nonadapt(1,1,1), shortageCost_adapt(1,1,1), shortageCost_nonadapt(1,1,3), shortageCost_adapt(1,1,3)];

h = bar(squeeze(allRows_comb),'stacked','FaceColor','flat',...
        'LineWidth',1);

    h(1,1).FaceColor = facecolors(1,:);
    h(1,2).FaceColor = facecolors(2,:);
    h(1,3).FaceColor = [211,211,211]/255;

if d == 3
    xticklabels(repmat(["Static Ops.", "Flex Ops."],1,3))
    legend('Initial Dam Cost','Expansion Dam Cost','Shortage Cost')
else
     xticklabels(repmat(["", ""],1,3))
end
ylabel('Expected Cost (M$)','FontWeight','bold')
%ylim([0, 110])
title(strcat("Discount Rate: ", disc_vals(d),"%"),'FontWeight','bold')
box on
grid on
grid(gca,'minor')

end
sgtitle("Expected Total Cost for Flexible Alternatives")
ax = gca;
% hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2), p1],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
%     strcat("Static Ops (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
%     string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
%     ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
%     string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts","Precip.\newlinestate"},'Orientation','horizontal', 'FontSize', 9);

% Programatically move the Legend
% newPosition = [0.4 0.05 0.2 0];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);

figure_width = 25;%20;
figure_height = 6;%6;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(gcf, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'OuterPosition', [100, 0, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

%% Cost by time 

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

folder = 'Jan28optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

disc_vals = string([0, 3, 6]);
cp_vals = ["125e6", "6e6", "2e5"];
figure()
for d=1:3
    
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',cp_vals(d),'_g7_percFlex75_percExp15_disc',disc_vals(d),'.mat'))
totalCostTime_adapt = totalCostTime;
damCostTime_adapt = damCostTime;
bestAct_adapt = bestAct;

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',cp_vals(d),'_g7_percFlex75_percExp15_disc',disc_vals(d),'.mat'))
totalCostTime_nonadapt = totalCostTime;
damCostTime_nonadapt = damCostTime;
bestAct_nonadapt = bestAct;

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

% Shortage Cost Time: select associated simulations
shortageCost_adapt = totalCost_adapt(:,:,:)-damCost_adapt(:,:,:);
shortageCost_nonadapt = totalCost_nonadapt(:,:,:)-damCost_nonadapt(:,:,:);    

% PLOT
subplot(1,3,d)
allRows_comb = zeros(5,6,2);
for i = 1:5
    allRows_comb(i,1:6,1) = mean([damCost_nonadapt(:,i,2), damCost_adapt(:,i,2),...
        damCost_nonadapt(:,i,1), damCost_adapt(:,i,1), damCost_nonadapt(:,i,3), damCost_adapt(:,i,3)]);
    allRows_comb(i,1:6,2) = mean([ shortageCost_nonadapt(:,i,2), shortageCost_adapt(:,i,2),...
        shortageCost_nonadapt(:,i,1), shortageCost_adapt(:,i,1), shortageCost_nonadapt(:,i,3), shortageCost_adapt(:,i,3)]);
end
h = plotBarStackGroups(allRows_comb,decade_short);
for i = 1:6
    h(i,1).FaceColor = facecolors(i,:);
    h(i,2).FaceColor = [211,211,211]/255;
end
%xticklabels(decade_short)
xlabel('Time Period','FontWeight','bold')
ylabel('Expected Cost (M$)','FontWeight','bold')
ylim([0, 110])
title(strcat("Discount Rate: ", disc_vals(d),"%"),'FontWeight','bold')
box on
grid on

end
sgtitle("Expected Cost vs. Time")
ax = gca;
% hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2), p1],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
%     strcat("Static Ops (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
%     string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
%     ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
%     string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts","Precip.\newlinestate"},'Orientation','horizontal', 'FontSize', 9);

% Programatically move the Legend
% newPosition = [0.4 0.05 0.2 0];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);

figure_width = 25;%20;
figure_height = 6;%6;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(gcf, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'OuterPosition', [100, 0, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);


%% C' senstivity: optimal dam design vs. c' with 3% discounting

folder = 'Jan28_cprime_sens'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

cps = [1e-8:1e-7:1e-6, 1e-6:2e-6:2.3e-5];
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

bestAct_Cprimes = zeros(length(cps),15,2); % first is non-adaptive, second is adaptive;
for i=1:length(cps)
    c_prime = cps(i);
    load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex75_percExp15_disc3.mat'))
    bestAct_Cprimes(i,:,1) = bestAct; % non-adaptive ops
    load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex75_percExp15_disc3.mat'))
    bestAct_Cprimes(i,:,2) = bestAct; % adaptive ops
end

f = figure();
fill([cps, fliplr(cps)],[bestAct_Cprimes(:,8,1)',flip(bestAct_Cprimes(:,8,1)+bestAct_Cprimes(:,9,1).*bestAct_Cprimes(:,10,1))'],facecolors(5,:),'EdgeColor',facecolors(5,:),'FaceAlpha',0.9,'LineWidth',2,'DisplayName','Flex. Plan., Static. Ops.')
hold on
fill([cps, fliplr(cps)],[bestAct_Cprimes(:,8,2)',flip(bestAct_Cprimes(:,8,2)+bestAct_Cprimes(:,9,2).*bestAct_Cprimes(:,10,2))'],facecolors(6,:),'EdgeColor',facecolors(6,:),'FaceAlpha',0.6,'LineWidth',2,'LineStyle','--', 'DisplayName','Flex. Plan., Flex. Ops.')
hold on

fill([cps, fliplr(cps)],[bestAct_Cprimes(:,3,1)',flip(bestAct_Cprimes(:,3,1)+bestAct_Cprimes(:,4,1).*bestAct_Cprimes(:,5,1))'],facecolors(3,:),'EdgeColor',facecolors(3,:),'FaceAlpha',0.7,'LineWidth',2,'DisplayName','Flex. Design., Static. Ops.')
hold on
fill([cps, fliplr(cps)],[bestAct_Cprimes(:,3,2)',flip(bestAct_Cprimes(:,3,2)+bestAct_Cprimes(:,4,2).*bestAct_Cprimes(:,5,2))'],facecolors(4,:),'EdgeColor',facecolors(4,:),'FaceAlpha',0.6,'LineWidth',2,'LineStyle','--','DisplayName','Flex. Design., Flex. Ops.')
hold on
plot(cps, bestAct_Cprimes(:,2,1),'DisplayName','Static Design, Static Ops.', 'Color', facecolors(1,:),'LineWidth',2)
hold on
plot(cps, bestAct_Cprimes(:,2,2),'DisplayName','Static Design., Flex. Ops.', 'Color', facecolors(2,:),'LineWidth',2,'LineStyle','--')
hold on
yline(150,':k','Max Capacity','DisplayName','Max Capacity','LabelVerticalAlignment','top','LabelHorizontalAlignment','left')
legend()

xlim([cps(1), cps(end)])
ylim([50,165])
xlabel("c' ($/m^6)")
ylabel("Dam Capacity (MCM)")
title("Optimal Dam Capacity vs. c'","Discount Rate: 3%",'HorizontalAlignment','center')
    