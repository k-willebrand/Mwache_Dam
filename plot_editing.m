folder = 'Nov02optimal_dam_design_discount'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
%cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/SDP_sensitivity_tests/')

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

%% Single AGU Plot: COMBINED with Inset

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


%% Single Subplot for AGU for extent of expansion: Highlights from Jenny's Plots (same colors)

% Run for 3% then 6% discount rate and combine figures in powerpoint

f = figure;

% nonadapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
% nonadapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];
% 
% adapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
% adapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];
% 


nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177]];
nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177]];

adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177]];
adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177]];

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
    %l = legend([b1([1 6:9])],capState,'Orientation','horizontal',...
    %'Location','southoutside','FontSize',10,'AutoUpdate','off');
    %l.ItemTokenSize = 0.2;
    %l.Position == l.Position + [-0.15 -0.15 0 0.05];
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



%% COMBINE ROWS OF SUBPLOTS: Highlights from Jenny's Plots (initial infrastructure decision, final decision, timing of decisions)

f = figure;

nonadapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
nonadapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];

adapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
adapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];


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
    subplot(2,1,1)
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
    
    colormap(cmap);
    %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    hold on
    end
    
    xticklabels(decade);
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Operations \newline& Flexible Design';'Flexible Operations \newline& Flexible Design';...
        'Static Operations \newline& Flexible Planning';'Flexible Operations \newline& Flexible Planning'})

    ylabel('Frequency');
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5))," MCM")};
    end
    for r = 1:bestAct(9)
        planExp_labels(r) = {strcat("Flex Planning, Exp:+", num2str(r*bestAct(10))," MCM")};
    end
    
    h=get(gca,'Children');
    capState = {'Flex. Design, Unexpanded','Flex. Planning, Unexpanded', flexExp_labels{:}, planExp_labels{:}};
    l = legend(capState,'Location',"southwest",'FontSize', 9);
    l.Position == l.Position + [-0.15 -0.15 0 0.05];
    box
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    set(findall(allaxes,'type','text'),'FontSize', 10);
    title('Frequency of Capacity Expansion Decision','FontSize',12)

    
    % == SUBPLOT 2: EXPANSION DECISIONS  ==
    
    subplot(2,1,2)
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,t);
    static = sum(act1 == 1);
    flex = sum(act1 == 2);
    plan = sum(act1 == 3);
    
    % frequency timing of of exp decisions
    
    
    actexp = action(:,2:end,t);
    exp1 = sum(actexp(:,1) == s_C(4:end),'all');
    exp2 = sum(actexp(:,2) == s_C(4:end),'all');
    exp3 = sum(actexp(:,3) == s_C(4:end),'all');
    exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    colormap(cmap)
    b2 = bar(1+(2*(type-1)+s),[expnever exp4 exp3 exp2 exp1]', .8, 'stacked','FaceColor','flat');
    for i = 2:4
        b2(i).FaceColor = cmap2(i+4,:);
    end
    b2(5).FaceColor = cmap2(10,:);
    b2(1).FaceColor = [150, 150, 150]/255;
    hold on
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    
    ax = gca;
    ax.XAxis;
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Operations \newline& Flexible Design';'Flexible Operations \newline& Flexible Design';...
        'Static Operations \newline& Flexible Planning';'Flexible Operations \newline& Flexible Planning'})
    [l1, l3] = legend({'never', decade{1,end:-1:2}}, 'FontSize', 9, 'Location',"north");
    title('Expansion Decisions','FontSize',12)
    ylabel('Frequency')
    xlabel('Dam Alternative','FontWeight','bold')
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    
    % add title to subplot groups
    title('Frequency of Capacity Expansion Time Period','FontSize',12)

    end
end

sgtitle('Summary of Forward Simulated Expansion Decisions through 2100','FontWeight','bold')

% set figure size
figure_width = 10;
figure_height =10;

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

%% (NO LEGEND VERSION) COMBINE ROWS OF SUBPLOTS: Highlights from Jenny's Plots (initial infrastructure decision, final decision, timing of decisions)

f = figure;

nonadapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
nonadapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];

adapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
adapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];


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
    subplot(2,1,1)
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
    
    colormap(cmap);
    %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    hold on
    end
    
    xticklabels(decade);
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Operations \newline& Flexible Design';'Flexible Operations \newline& Flexible Design';...
        'Static Operations \newline& Flexible Planning';'Flexible Operations \newline& Flexible Planning'})

    ylabel('Frequency');
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5))," MCM")};
    end
    for r = 1:bestAct(9)
        planExp_labels(r) = {strcat("Flex Planning, Exp:+", num2str(r*bestAct(10))," MCM")};
    end
    
    h=get(gca,'Children');
    capState = {'Flex. Design, Unexpanded','Flex. Planning, Unexpanded', flexExp_labels{:}, planExp_labels{:}};
    %l = legend(capState,'Location',"southwest",'FontSize', 9);
    %l.Position == l.Position + [-0.15 -0.15 0 0.05];
    box
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    set(findall(allaxes,'type','text'),'FontSize', 10);
    title('Frequency of Capacity Expansion Decision','FontSize',12)

    
    % == SUBPLOT 2: EXPANSION DECISIONS  ==
    
    subplot(2,1,2)
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,t);
    static = sum(act1 == 1);
    flex = sum(act1 == 2);
    plan = sum(act1 == 3);
    
    % frequency timing of of exp decisions
    
    
    actexp = action(:,2:end,t);
    exp1 = sum(actexp(:,1) == s_C(4:end),'all');
    exp2 = sum(actexp(:,2) == s_C(4:end),'all');
    exp3 = sum(actexp(:,3) == s_C(4:end),'all');
    exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    colormap(cmap)
    b2 = bar(1+(2*(type-1)+s),[expnever exp4 exp3 exp2 exp1]', .8, 'stacked','FaceColor','flat');
    for i = 2:4
        b2(i).FaceColor = cmap2(i+4,:);
    end
    b2(5).FaceColor = cmap2(10,:);
    b2(1).FaceColor = [150, 150, 150]/255;
    hold on
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    
    ax = gca;
    ax.XAxis;
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Operations \newline& Flexible Design';'Flexible Operations \newline& Flexible Design';...
        'Static Operations \newline& Flexible Planning';'Flexible Operations \newline& Flexible Planning'})
    %[l1, l3] = legend({'never', decade{1,end:-1:2}}, 'FontSize', 9, 'Location',"north");
    title('Expansion Decisions','FontSize',12)
    ylabel('Frequency')
    xlabel('Dam Alternative','FontWeight','bold')
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    
    % add title to subplot groups
    title('Frequency of Capacity Expansion Time Period','FontSize',12)

    end
end

sgtitle('Summary of Forward Simulated Expansion Decisions through 2100','FontWeight','bold')

% set figure size
figure_width = 10;
figure_height =10;

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

%% (AGU NO LEGEND VERSION) COMBINE ROWS OF SUBPLOTS: Highlights from Jenny's Plots (initial infrastructure decision, final decision, timing of decisions)
% Run for 3% then 6% discount rate and combine figures in powerpoint

f = figure;

nonadapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
nonadapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];

adapt_plan_colors = [[150, 150, 150];[255,214,214];[255,153,153];[255,102,102];[211,85,85]];
adapt_flex_colors = [[150, 150, 150];[213,213,255];[153,153,204];[126,126,168];[105,105,139]];


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
    subplot(1,2,1)
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
    
    colormap(cmap);
    %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
    b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
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
        'Static Ops.';'Flexible Ops.'},'FontSize',17)

    ylabel('Frequency','FontSize',18);
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5))," MCM")};
    end
    for r = 1:bestAct(9)
        planExp_labels(r) = {strcat("Flex Planning, Exp:+", num2str(r*bestAct(10))," MCM")};
    end
    
    h=get(gca,'Children');
    capState = {'Flex. Design, Unexpanded','Flex. Planning, Unexpanded', flexExp_labels{:}, planExp_labels{:}};
    %l = legend(capState,'Location',"southwest",'FontSize', 9);
    %l.Position == l.Position + [-0.15 -0.15 0 0.05];
    box
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    allaxes = findall(f, 'type', 'axes');
    title({'Frequency of Capacity Expansion Decision';'Discount Rate: 3%'},'FontSize',20)

    
    % == SUBPLOT 2: EXPANSION DECISIONS  ==
    
    subplot(1,2,2)
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,t);
    static = sum(act1 == 1);
    flex = sum(act1 == 2);
    plan = sum(act1 == 3);
    
    % frequency timing of of exp decisions
    
    
    actexp = action(:,2:end,t);
    exp1 = sum(actexp(:,1) == s_C(4:end),'all');
    exp2 = sum(actexp(:,2) == s_C(4:end),'all');
    exp3 = sum(actexp(:,3) == s_C(4:end),'all');
    exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    colormap(cmap)
    b2 = bar(1+(2*(type-1)+s),[expnever exp4 exp3 exp2 exp1]', .8, 'stacked','FaceColor','flat');
    for i = 2:4
        b2(i).FaceColor = cmap2(i+4,:);
    end
    b2(5).FaceColor = cmap2(10,:);
    b2(1).FaceColor = [150, 150, 150]/255;
    hold on
    xlim([1.5 5.5])
    %xline(3.5,'LineWidth',.8)
    
    ax = gca;
    ax.XAxis;
    set(gca, 'XTick', [2 3 4 5])
    set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
        'Static Ops.';'Flexible Ops.'},'FontSize',17)
    %[l1, l3] = legend({'never', decade{1,end:-1:2}}, 'FontSize', 9, 'Location',"north");

    ylabel('Frequency','FontSize',18)
    %xlabel('Dam Alternative','FontWeight','bold')
    allaxes = findall(f, 'type', 'axes');
    
    % add title to subplot groups
    title({'Frequency of Capacity Expansion Time Period';'Discount Rate: 3%'},'FontSize',20)

    end
end

%sgtitle('Summary of Forward Simulated Expansion Decisions through 2100','FontWeight','bold')

% set figure size
figure_width = 32;
figure_height =4;

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

