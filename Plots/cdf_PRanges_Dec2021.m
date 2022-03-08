%% Load data: update data to load

% change default font style
set(groot,'defaultAxesFontName','Futura')

%folder = 'Nov02optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
folder = 'Jan28optimal_dam_design_comb';
cd('C:/Users/kcuw9/Documents/Mwache_Dam')
mkdir('Plots/multiflex_comb')

% load(strcat(folder,'/BestFlex_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
% load(strcat(folder,'/BestStatic_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
% load(strcat(folder,'/BestPlan_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
% load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestFlex_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
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


load(strcat(folder,'/BestFlex_nonadaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp125e6_g7_percFlex75_percExp15_disc0.mat'))
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


s_P_abs = 66:1:97;
s_T_abs = [26.25 26.75 27.25 27.95 28.8000];

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};


%% Plot the CDF (full and zoomed for 95th percentile). Also show range of 
% total costs observed from forward simulations.

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
    minCostPnow(i,:) = min([minCostPnow_adapt(i,:),minCostPnow_nonadapt(i,:)],[],'all');
    
    % max total costs
    maxCostPnow_adapt(i,:) = max(totalCostPnow_adapt,[],'all');
    maxCostPnow_nonadapt(i,:) = max(totalCostPnow_nonadapt,[],'all');
    maxCostPnow(i,:) = max([maxCostPnow_adapt(i,:),maxCostPnow_nonadapt(i,:)],[],'all');

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
ax.LineWidth = 2;

ax.XGrid = 'off';
ax.YGrid = 'off';
box on

font_size = 20;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
%legend('FontSize',12, 'Location','northeast','EdgeColor','k')
title('CDF of Simulated Total Cost','FontSize',26,'FontWeight','bold')

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
f = figure;
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
ax.LineWidth = 2;

%xlim([150,1800])

font_size = 18;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
end

%% Makethe legend (2x3) for AGU poster by creating a psuedo bar chart

figure

b(1) = bar(1,1,'facecolor', 'flat');
hold on
b(2) =  bar(1,1,'facecolor', 'flat');
hold on
b(3) = bar(1,1,'facecolor', 'flat');
hold on
b(4) =  bar(1,1,'facecolor', 'flat');
hold on
b(5) = bar(1,1,'facecolor', 'flat');
hold on
b(6) =  bar(1,1,'facecolor', 'flat');

for i = 1:6
    b(i).FaceColor = facecolors{i};
end

legend([b(1) b(2) b(3) b(4) b(5) b(6)], {'Static Design & Static Ops.{ }',...
    'Static Design & Flexible Ops.{ }','Flexible Design & Static Ops.{ }',...
    'Flexible Design & Flexible Ops.{ }','Flexible Planning & Static Ops.{ }',...
    'Flexible Planning & Flexible Ops.{ }'},'NumColumns',3,'FontSize',14)

ax = gca;
ax.LineWidth = 1.5;

set(gca,'visible','off')

%% Sample Dry Climate Forward Simlation: shortage and infrastructure costs (AGU)

P_regret = [72];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

for p = 1 % for each transition to drier or wetter climate

    % Index realizations where final P state is 72, 79, or 87 mm/mo
    [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(p));
    [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(p));
    
    % P state time series: select associated time series
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions: select associated simulations
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
    
    % Dam Cost Time: select associated simulations
    damCostPnowFlex_adapt = damCost_adapt(ind_P_adapt,:,1);
    damCostPnowFlex_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,1);
    damCostPnowStatic_adapt = damCost_adapt(ind_P_adapt,:,2);
    damCostPnowStatic_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,2);
    damCostPnowPlan_adapt = damCost_adapt(ind_P_adapt,:,3);
    damCostPnowPlan_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,3);

    % Shortage Cost Time: select associated simulations
    shortageCostPnowFlex_adapt = totalCost_adapt(ind_P_adapt,:,1)-damCost_adapt(ind_P_adapt,:,1);
    shortageCostPnowFlex_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,1)-damCost_nonadapt(ind_P_nonadapt,:,1);
    shortageCostPnowStatic_adapt = totalCost_adapt(ind_P_adapt,:,2)-damCost_adapt(ind_P_adapt,:,2);
    shortageCostPnowStatic_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,2)-damCost_nonadapt(ind_P_nonadapt,:,2);
    shortageCostPnowPlan_adapt = totalCost_adapt(ind_P_adapt,:,3)-damCost_adapt(ind_P_adapt,:,3);
    shortageCostPnowPlan_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,3)-damCost_nonadapt(ind_P_nonadapt,:,3);

    % == FLEXIBLE DESIGN ==
    % map actions to dam capacity of time
    actionPnowFlex_adapt = ActionPnow_adapt(:,:,1);   
    for r = 1:size(actionPnowFlex_adapt,1) % each forward simulation
        for ia = 2:size(actionPnowFlex_adapt,2) % each subsequent time period
            if actionPnowFlex_adapt(r,ia) == 0
                actionPnowFlex_adapt(r,ia) = actionPnowFlex_adapt(r,ia-1);
            end
        end
    end

    actionPnowFlex_nonadapt = ActionPnow_nonadapt(:,:,1);   
    for r = 1:size(actionPnowFlex_nonadapt,1)
        for ia = 2:size(actionPnowFlex_nonadapt,2)
            if actionPnowFlex_nonadapt(r,ia) == 0
                actionPnowFlex_nonadapt(r,ia) = actionPnowFlex_nonadapt(r,ia-1);
            end
        end
    end
 
    % == FLEXIBLE PLANNING ==
    actionPnowPlan_adapt = ActionPnow_adapt(:,:,3);
    for r = 1:size(actionPnowPlan_adapt,1)
        for ia = 2:size(actionPnowPlan_adapt,2)
            if actionPnowPlan_adapt(r,ia) == 0
                actionPnowPlan_adapt(r,ia) = actionPnowPlan_adapt(r,ia-1);
            end
        end
    end
    
    actionPnowPlan_nonadapt = ActionPnow_nonadapt(:,:,3);
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 2:size(actionPnowPlan_nonadapt,2)
            if actionPnowPlan_nonadapt(r,ia) == 0
                actionPnowPlan_nonadapt(r,ia) = actionPnowPlan_nonadapt(r,ia-1);
            end
        end
    end
    
    % == STATIC DAM ==
    actionPnowStatic_adapt = ActionPnow_adapt(:,:,2);   
    for r = 1:size(actionPnowStatic_adapt,1) % each forward simulation
        for ia = 2:size(actionPnowStatic_adapt,2) % each subsequent time period
            if actionPnowStatic_adapt(r,ia) == 0
                actionPnowStatic_adapt(r,ia) = actionPnowStatic_adapt(r,ia-1);
            end
        end
    end

    actionPnowStatic_nonadapt = ActionPnow_nonadapt(:,:,2);   
    for r = 1:size(actionPnowStatic_nonadapt,1)
        for ia = 2:size(actionPnowStatic_nonadapt,2)
            if actionPnowStatic_nonadapt(r,ia) == 0
                actionPnowStatic_nonadapt(r,ia) = actionPnowStatic_nonadapt(r,ia-1);
            end
        end
    end
    
    % == UNIQUE P STATE TRANSITIONS ==
    [uP, uPIdxs, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    f = figure()
    
    if p==1 % dry plot index
        idxP = uPIdxs(2);
    elseif p == 2 % moderate plot index
        idxP = uPIdxs(5);
    else % wet plot index
        idxP = uPIdxs(3);
    end

    subplot(2,1,1)
    allRows_comb = zeros(5,6,2);
    for i = 1:5
        allRows_comb(i,1:6,1) = [damCostPnowStatic_nonadapt(idxP,i), damCostPnowStatic_adapt(idxP,i),...
            damCostPnowFlex_nonadapt(idxP,i), damCostPnowFlex_adapt(idxP,i), damCostPnowPlan_nonadapt(idxP,i), damCostPnowPlan_adapt(idxP,i)];
        allRows_comb(i,1:6,2) = [ shortageCostPnowStatic_nonadapt(idxP,i), shortageCostPnowStatic_adapt(idxP,i),...
            shortageCostPnowFlex_nonadapt(idxP,i), shortageCostPnowFlex_adapt(idxP,i), shortageCostPnowPlan_nonadapt(idxP,i), shortageCostPnowPlan_adapt(idxP,i)];
    end
    yyaxis left
    %h = plotBarStackGroups(allRows_comb,decade_short);
    h = bar(1:5,allRows_comb(:,:,1)); % infrastructure costs
    for i = 1:6
        h(i).FaceColor = facecolors{i};
        %h(i,2).FaceColor = [211,211,211]/255;
    end
    xticklabels(decade_short)
    set(gca,'xticklabel',{[]})
    %xlabel('Time Period','FontWeight','bold')
    %xlabel('')
    ylabel('Cost (M$)')
    title('Infrastructure Costs vs. Time for Simulated Dry Climate','FontWeight','bold')
    
    yyaxis right
    hold on
    p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',3);
    ylabel('P State (mm/mo)')
    ylim([65,95]);
    xlim([0.5,5.5])
    box on
    
    ax = gca;
ax.LineWidth = 1.5;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
    if p == 1
     hL = legend([p1],{"Precip. state"},'FontSize', 18);
     legend boxoff
     
    end
    
    font_size = 14;
    allaxes = findall(ax, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    %legend('FontSize',12, 'Location','northeast','EdgeColor','k')

    % == Shortage Costs ==
    subplot(2,1,2)

    h = bar(1:5,allRows_comb(:,:,2)); % infrastructure costs
    for i = 1:6
        h(i).FaceColor = facecolors{i};
        %h(i,2).FaceColor = [211,211,211]/255;
    end
    xticklabels(decade_short)
    
    %yyaxis left
%     b = bar(1:5, allRows_comb,'facecolor','flat');
%     for i = 1:6
%         b(i).CData = repmat(facecolors{i},[5,1]);
%     end
    %ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Cost (M$)')
    title('Shortage Cost vs. Time for Simulated Dry Climate','FontWeight','bold')

     yyaxis right
     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
     p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',3);
     ylabel('P State (mm/mo)')
     ylim([65,95]);
     
     
     
     if p == 1
     hL = legend([p1],{"Precip. state"},'FontSize', 18);
     legend boxoff
     
     end
         ax = gca;
         ax = gca;
ax.LineWidth = 1.5;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
end

    font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    %legend('FontSize',12, 'Location','northeast','EdgeColor','k')
    
figure_width = 12;%20;
figure_height = 25;%6;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels


% SET UP FIGURE SIZE
set(gcf, 'Position', [107.4000 7.4000 849.6000 792]);
%set(gcf, 'OuterPosition', [100, 0, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
%set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperSize', [figure_width figure_height]);
%set(gcf, 'PaperPositionMode', 'manual');
%set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

%% Stack dry, moderate, wet sample simulation for base-case (discount rate 3%)
% Look at plots above to select interesting/representative forward
% simulations

% facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
%     [255, 102, 102]; [255, 153, 153]]/255;



P_regret = [72];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

for p = 1 % for each transition to drier or wetter climate

    % Index realizations where final P state is 72, 79, or 87 mm/mo
    [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(p));
    [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(p));
    
    % P state time series: select associated time series
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions: select associated simulations
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
    
    % Dam Cost Time: select associated simulations
    damCostPnowFlex_adapt = damCost_adapt(ind_P_adapt,:,1);
    damCostPnowFlex_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,1);
    damCostPnowStatic_adapt = damCost_adapt(ind_P_adapt,:,2);
    damCostPnowStatic_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,2);
    damCostPnowPlan_adapt = damCost_adapt(ind_P_adapt,:,3);
    damCostPnowPlan_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,3);

    % Shortage Cost Time: select associated simulations
    shortageCostPnowFlex_adapt = totalCost_adapt(ind_P_adapt,:,1)-damCost_adapt(ind_P_adapt,:,1);
    shortageCostPnowFlex_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,1)-damCost_nonadapt(ind_P_nonadapt,:,1);
    shortageCostPnowStatic_adapt = totalCost_adapt(ind_P_adapt,:,2)-damCost_adapt(ind_P_adapt,:,2);
    shortageCostPnowStatic_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,2)-damCost_nonadapt(ind_P_nonadapt,:,2);
    shortageCostPnowPlan_adapt = totalCost_adapt(ind_P_adapt,:,3)-damCost_adapt(ind_P_adapt,:,3);
    shortageCostPnowPlan_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,3)-damCost_nonadapt(ind_P_nonadapt,:,3);

    % == FLEXIBLE DESIGN ==
    % map actions to dam capacity of time
    actionPnowFlex_adapt = ActionPnow_adapt(:,:,1);   
    for r = 1:size(actionPnowFlex_adapt,1) % each forward simulation
        for ia = 2:size(actionPnowFlex_adapt,2) % each subsequent time period
            if actionPnowFlex_adapt(r,ia) == 0
                actionPnowFlex_adapt(r,ia) = actionPnowFlex_adapt(r,ia-1);
            end
        end
    end

    actionPnowFlex_nonadapt = ActionPnow_nonadapt(:,:,1);   
    for r = 1:size(actionPnowFlex_nonadapt,1)
        for ia = 2:size(actionPnowFlex_nonadapt,2)
            if actionPnowFlex_nonadapt(r,ia) == 0
                actionPnowFlex_nonadapt(r,ia) = actionPnowFlex_nonadapt(r,ia-1);
            end
        end
    end
 
    % == FLEXIBLE PLANNING ==
    actionPnowPlan_adapt = ActionPnow_adapt(:,:,3);
    for r = 1:size(actionPnowPlan_adapt,1)
        for ia = 2:size(actionPnowPlan_adapt,2)
            if actionPnowPlan_adapt(r,ia) == 0
                actionPnowPlan_adapt(r,ia) = actionPnowPlan_adapt(r,ia-1);
            end
        end
    end
    
    actionPnowPlan_nonadapt = ActionPnow_nonadapt(:,:,3);
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 2:size(actionPnowPlan_nonadapt,2)
            if actionPnowPlan_nonadapt(r,ia) == 0
                actionPnowPlan_nonadapt(r,ia) = actionPnowPlan_nonadapt(r,ia-1);
            end
        end
    end
    
    % == STATIC DAM ==
    actionPnowStatic_adapt = ActionPnow_adapt(:,:,2);   
    for r = 1:size(actionPnowStatic_adapt,1) % each forward simulation
        for ia = 2:size(actionPnowStatic_adapt,2) % each subsequent time period
            if actionPnowStatic_adapt(r,ia) == 0
                actionPnowStatic_adapt(r,ia) = actionPnowStatic_adapt(r,ia-1);
            end
        end
    end

    actionPnowStatic_nonadapt = ActionPnow_nonadapt(:,:,2);   
    for r = 1:size(actionPnowStatic_nonadapt,1)
        for ia = 2:size(actionPnowStatic_nonadapt,2)
            if actionPnowStatic_nonadapt(r,ia) == 0
                actionPnowStatic_nonadapt(r,ia) = actionPnowStatic_nonadapt(r,ia-1);
            end
        end
    end
    
    % == UNIQUE P STATE TRANSITIONS ==
    [uP, uPIdxs, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    f = figure()
    
    if p==1 % dry plot index
        idxP = uPIdxs(2);
    elseif p == 2 % moderate plot index
        idxP = uPIdxs(5);
    else % wet plot index
        idxP = uPIdxs(3);
    end

    subplot(2,1,1)
    allRows_comb = zeros(5,6,2);
    for i = 1:5
        allRows_comb(i,1:6,1) = [damCostPnowStatic_nonadapt(idxP,i), damCostPnowStatic_adapt(idxP,i),...
            damCostPnowFlex_nonadapt(idxP,i), damCostPnowFlex_adapt(idxP,i), damCostPnowPlan_nonadapt(idxP,i), damCostPnowPlan_adapt(idxP,i)];
        allRows_comb(i,1:6,2) = [ shortageCostPnowStatic_nonadapt(idxP,i), shortageCostPnowStatic_adapt(idxP,i),...
            shortageCostPnowFlex_nonadapt(idxP,i), shortageCostPnowFlex_adapt(idxP,i), shortageCostPnowPlan_nonadapt(idxP,i), shortageCostPnowPlan_adapt(idxP,i)];
    end
    yyaxis left
    h = plotBarStackGroups(allRows_comb,decade_short);
    for i = 1:6
        h(i,1).FaceColor = facecolors{i};
        h(i,2).FaceColor = [211,211,211]/255;
    end
    set(gca,'xticklabel',{[]})
    %xlabel('Time Period','FontWeight','bold')
    %xlabel('')
    ylabel('Cost (M$)')
    title('Total Costs vs. Time for Simulated Dry Climate','FontWeight','bold')
    
    yyaxis right
    hold on
    p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',3);
    ylabel('P State (mm/mo)')
    ylim([65,95]);
    xlim([0.5,5.5])
    box on
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
    if p == 1
     hL = legend([h(1,2), p1],{"Shortage costs", "Precip. state"},'FontSize', 18);
     legend boxoff
     
    end
    
    font_size = 14;
    allaxes = findall(ax, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    %legend('FontSize',12, 'Location','northeast','EdgeColor','k')

    subplot(2,1,2)
        allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
        s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
    %yyaxis left
    b = bar(1:5, allRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors{i},[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Capacity (MCM)')
    title('Dam Capacity vs. Time for Simulated Dry Climate','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors{5},'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors{6},'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors{3},'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors{4},'LineWidth',2)
    hold on
%     yyaxis right
%     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
%     plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([70,90]);

    font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    %legend('FontSize',12, 'Location','northeast','EdgeColor','k')

    if p == 1
%         sgtitle(strcat('Simulated Final Dry Climate State (',num2str(P_regret(p))," mm/mo)"),...
%          'FontWeight','bold','FontSize',24)
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold','FontSize',26)
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold','FontSize',24)
    end
    
figure_width = 18;%20;
figure_height = 22;%6;

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

end


