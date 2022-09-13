% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 3.5e-6 7E-7 1.8E-6 3.75e-6 6e-6]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Jan28optimal_dam_design_comb';
    %folder = 'May20optimal_dam_design_comb';
else
    folder = 'Feb7optimal_dam_design_comb';
end
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1 %length(discounts)
    disc = string(discounts(d));
    for c = 3 %4%length(cprimes)
        cp = cprimes(c);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        % load adaptive operations files:
        if newCostModel == 1
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
        elseif fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
        else % only can be used if discount is 6%
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
        end
        bestAct_adapt = bestAct;
        V_adapt = V;
        Vs_adapt = Vs;
        Vd_adapt = Vd;
        Vs_static_adapt = allVs_static;
        Vs_flex_adapt = allVs_flex;
        Vs_plan_adapt = allVs_plan;
        Vd_static_adapt = allVd_static;
        Vd_flex_adapt = allVd_flex;
        Vd_plan_adapt = allVd_plan;
        %Vs_adapt_nondisc = Vs_nondisc;
        %Vd_adapt_nondisc = Vd_nondisc;
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
        
        % load non-adaptive operations files:
        if newCostModel == 1
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
        elseif fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
        else
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'_s60.mat'))
        end
        bestAct_nonadapt = bestAct;
        V_nonadapt = V;
        Vs_nonadapt = Vs;
        Vd_nonadapt = Vd;
        Vs_static_nonadapt = allVs_static;
        Vs_flex_nonadapt = allVs_flex;
        Vs_plan_nonadapt = allVs_plan;
        Vd_static_nonadapt = allVd_static;
        Vd_flex_nonadapt = allVd_flex;
        Vd_plan_nonadapt = allVd_plan;
        %Vs_nonadapt_nondisc = Vs_nondisc;
        %Vd_nonadapt_nondisc = Vd_nondisc;
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
        
    end
end

% set different decade label parameters for use in plotting
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

%% Infrastructure Cost Look-up Structures:
% Note: for discounted infrastructure and shortage costs, use: totalCostTime and damCostTime

% calculate non-discounted infrastructure costs using storage2damcost:
for s = 1:2 % for non-adaptive and adaptive operations
    if s == 1
        x = bestAct_nonadapt;
    else
        x = bestAct_adapt;
    end
    
    % load optimal infrastructure information
    optParam.staticCap = x(2); % static dam size [MCM]
    optParam.smallFlexCap = x(3); % unexpanded flexible design dam size [MCM]
    optParam.numFlex = x(4);  % number of possible expansion capacities [#]
    optParam.flexIncr = x(5); % increment of flexible expansion capacities [MCM]
    costParam.PercFlex = x(6); % Initial upfront capital cost increase (0.075)
    costParam.PercFlexExp = x(7); % Expansion cost of flexible dam  (0.15)
    optParam.smallPlanCap = x(8); % unexpanded flexible planning dam size [MCM]
    optParam.numPlan = x(9); % MCM
    optParam.planIncr = x(10);
    costParam.PercPlan = x(11); % initial upfront capital cost increase (0);
    costParam.PercPlanExp = x(12); % expansion cost of flexibly planned dam (0.5)
    costParam.discountrate = x(15);
    
    s_C = 1:3+optParam.numFlex+optParam.numPlan;
    M_C = length(s_C);
    
    storage = zeros(1, M_C);
    storage(1) = optParam.staticCap;
    storage(2) = optParam.smallFlexCap;
    storage(3) = optParam.smallPlanCap;
    storage(4:3+optParam.numFlex) = min(storage(2) + (1:optParam.numFlex)*optParam.flexIncr, 150);
    storage(4+optParam.numFlex:end) = min(storage(3) + (1:optParam.numPlan)*optParam.planIncr, 150);
    
    % Actions: Choose dam option in time period 1; expand dam in future time periods
    a_exp = 0:3+optParam.numFlex+optParam.numPlan;
    
    % Define infrastructure costs
    infra_cost = zeros(1,length(a_exp));
    infra_cost(2) = storage2damcost(storage(1),0); % cost of static dam
    for i = 1:optParam.numFlex % cost of flexible design dam
        [infra_cost(3), infra_cost(i+4)] = storage2damcost(storage(2), ...
            storage(i+3),costParam.PercFlex, costParam.PercFlexExp); % cost of flexible design exp to option X
    end
    for i = 1:optParam.numPlan % cost of flexible plan dam
        [infra_cost(4), infra_cost(i+4+optParam.numFlex)] = storage2damcost(storage(3), ...
            storage(i+3+optParam.numFlex),costParam.PercPlan, costParam.PercPlanExp); % cost of flexible planning exp to option X
    end
    
    if s == 1
        infra_cost_nonadaptive = struct();
        infra_cost_nonadaptive.static = [storage(1); infra_cost(2)/1E6];
        infra_cost_nonadaptive.flex = [[storage(2), storage(4:3+optParam.numFlex)]; [infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6];
        infra_cost_nonadaptive.plan = [[storage(3), storage(4+optParam.numFlex:end)]; [infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6];
        infra_cost_nonadaptive_lookup = infra_cost;
    else
        infra_cost_adaptive = struct();
        infra_cost_adaptive.static = [storage(1); infra_cost(2)/1E6];
        infra_cost_adaptive.flex = [[storage(2), storage(4:3+optParam.numFlex)]; [infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6];
        infra_cost_adaptive.plan = [[storage(3), storage(4+optParam.numFlex:end)]; [infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6];
        infra_cost_adaptive_lookup = infra_cost;
    end
end

%% Compare cost savings for flexible design and flexible planning from forward simulations

% 1 is flex design, 2 is static design, 3 is flex planning

% (1) find the row indices of top 10 percent of forward simulations where flex design
% performs better than flexible planning (and vice-versa)

facecolors = [[153,204,204]; [187,221,221]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

% make a generalized vector of 10,000 indices
allIdx = 1:length(totalCostTime_nonadapt);

% STATIC OPS INDICES
TotalCostDiff_nonadapt = squeeze(-(sum(totalCostTime_nonadapt(:,:,1:3),2) - sum(totalCostTime_nonadapt(:,:,2),2))/1E6); % flex design - static design w/ static ops
Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt(:,3) > 0);
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt(:,1) > 0);
%Idx_bestFlex_nonadapt = allIdx;
TotalCostDiff_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3),2)./sum(totalCostTime_nonadapt(:,:,2),2)); % flex design - static design w/ static operations

% FLEXIBLE OPS INDICES
TotalCostDiff_adapt = squeeze(-(sum(totalCostTime_adapt(:,:,1:3),2) - sum(totalCostTime_nonadapt(:,:,2),2))/1E6); % flex design - static design w/ static operations
Idx_bestStatic_adapt = allIdx(TotalCostDiff_adapt(:,2) > 0);
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt(:,3) > 0);
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt(:,1) > 0);
%  Idx_bestStatic_adapt = allIdx;
%  Idx_bestPlan_adapt = allIdx;
%  Idx_bestFlex_adapt = allIdx;
TotalCostDiff_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3),2)./sum(totalCostTime_nonadapt(:,:,2),2)); % flex design - static design w/ static operations


% bar number of sims where there are cost savings with flexibility


% combined difference for barplot


% make histogram of total cost savings
figure

% non-adaptive operations
groups = [repmat({'Static Design & Flexible Ops'},length(Idx_bestStatic_adapt),1);...
    repmat({'Flexible Design & Static Ops'},length(Idx_bestFlex_nonadapt),1); ...
    repmat({'Flexible Design & Flexible Ops'},length(Idx_bestFlex_adapt),1);...
    repmat({'Flexible Planning & Static Ops'},length(Idx_bestPlan_nonadapt),1);...
    repmat({'Flexible Planning & Flexible Ops'},length(Idx_bestPlan_adapt),1)];
% costDiff = -[TotalCostDiff_adapt(Idx_bestStatic_adapt); TotalCostDiff_nonadapt(Idx_bestFlex_nonadapt);...
%     TotalCostDiff_adapt(Idx_bestFlex_adapt); TotalCostDiff_nonadapt(Idx_bestPlan_nonadapt);...
%     TotalCostDiff_adapt(Idx_bestPlan_adapt)];
boxplot([TotalCostDiff_adapt(Idx_bestStatic_adapt,2); TotalCostDiff_nonadapt(Idx_bestFlex_nonadapt,1);...
    TotalCostDiff_adapt(Idx_bestFlex_adapt,1); TotalCostDiff_nonadapt(Idx_bestPlan_nonadapt,3);...
    TotalCostDiff_adapt(Idx_bestPlan_adapt,3)], groups,'Widths',0.7,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
hold on
p1=plot(1,mean(TotalCostDiff_adapt(Idx_bestStatic_adapt)), 'k.');
plot(2,mean(TotalCostDiff_nonadapt(Idx_bestFlex_nonadapt)), 'k.')
plot(3,mean(TotalCostDiff_adapt(Idx_bestFlex_adapt)), 'k.')
plot(4,mean(TotalCostDiff_nonadapt(Idx_bestPlan_nonadapt)), 'k.')
plot(5,mean(TotalCostDiff_adapt(Idx_bestPlan_adapt)), 'k.')

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1:5),'Color','k');

set(whisks(1),'Color',facecolors(6,:),'Linewidth',90);
set(whisks(2),'Color',facecolors(5,:),'Linewidth',90);
set(whisks(3),'Color',facecolors(4,:),'Linewidth',90);
set(whisks(4),'Color',facecolors(3,:),'Linewidth',90);
set(whisks(5),'Color',facecolors(2,:),'Linewidth',90);

set(outs(1),'MarkerEdgeColor',facecolors(6,:));
set(outs(2),'MarkerEdgeColor',facecolors(5,:));
set(outs(3),'MarkerEdgeColor',facecolors(4,:));
set(outs(4),'MarkerEdgeColor',facecolors(3,:));
set(outs(5),'MarkerEdgeColor',facecolors(2,:));

a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(6,:),'Linewidth',55);
set(a(2),'Color',facecolors(5,:),'Linewidth',55);
set(a(3),'Color',facecolors(4,:),'Linewidth',55);
set(a(4),'Color',facecolors(3,:),'Linewidth',55);
set(a(5),'Color',facecolors(2,:),'Linewidth',55);
ylabel('Total Cost Savings (M$)','FontWeight','bold')
%ylim([0,200])
set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
%set(gca, 'YScale', 'log')
legend([p1, meds(1)],{'Mean Total Cost Savings','Median Total Cost Savings'},...
    'Location','northwest')

title('Total Cost Savings for Flexible Design vs. Flexible Planning',...
    'FontWeight','bold')

%% Compare cost savings for flexible design and flexible planning from forward simulations

% 1 is flex design, 2 is static design, 3 is flex planning

% (1) find the row indices of top 10 percent of forward simulations where flex design
% performs better than flexible planning (and vice-versa)

% make a generalized vector of 10,000 indices
allIdx = 1:length(totalCostTime_nonadapt);

% STATIC OPS INDICES
TotalCostDiff_nonadapt = (sum(totalCostTime_nonadapt(:,:,1),2) - sum(totalCostTime_nonadapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt > 0);
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt < 0);

% FLEXIBLE OPS INDICES
TotalCostDiff_adapt = (sum(totalCostTime_adapt(:,:,1),2) - sum(totalCostTime_adapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt > 0);
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt < 0);

% make barplot of number of simulations where each alternative performs
% better
figure
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';

% static ops
nexttile
b = bar([length(Idx_bestFlex_nonadapt); length(Idx_bestPlan_nonadapt)],'FaceColor','flat');
for i=1:length(b.XData)
    b.CData(i,:) = facecolors(1+2*i,:);
end
title('Static Operations')
xlim([0.5,2.5])
ylim([0,9000])
xticklabels({'Flexible Design', 'Flexible Planning'})
ylabel('Frequency','FontWeight','bold')
set(gca, 'YGrid', 'on', 'XGrid', 'off');

% flexible ops
nexttile
b = bar([length(Idx_bestFlex_adapt); length(Idx_bestPlan_adapt)],'FaceColor','flat');
for i=1:length(b.XData)
    b.CData(i,:) = facecolors(2+2*i,:);
end
title('Flexible Operations')
xticklabels({'Flexible Design', 'Flexible Planning'})
set(gca, 'YGrid', 'on', 'XGrid', 'off');
xlim([0.5,2.5])
ylim([0,9000])
title(t, 'Frequency of Flexible Alternative Best Performance in Forward Simulations',...
    'FontWeight','bold')

% make histogram of total cost savings
figure
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';

% non-adaptive operations
nexttile
groups = [repmat({'Flexible Design'},length(Idx_bestFlex_nonadapt),1); ...
    repmat({'Flexible Planning'},length(Idx_bestPlan_nonadapt),1)];
boxplot([-TotalCostDiff_nonadapt(Idx_bestFlex_nonadapt);TotalCostDiff_nonadapt(Idx_bestPlan_nonadapt)],...
    groups,'Widths',0.3,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
hold on
p1=plot(1,mean(-TotalCostDiff_nonadapt(Idx_bestFlex_nonadapt)), 'k.')
plot(2,mean(TotalCostDiff_nonadapt(Idx_bestPlan_nonadapt)), 'k.')

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1),'Color','k');
set(meds(2),'Color','k');
set(whisks(1),'Color',facecolors(5,:));
set(whisks(2),'Color',facecolors(3,:));
set(outs(1),'MarkerEdgeColor',facecolors(5,:));
set(outs(2),'MarkerEdgeColor',facecolors(3,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(5,:),'Linewidth',25);
set(a(2),'Color',facecolors(3,:),'Linewidth',25);
ylabel('Total Cost Savings (M$)','FontWeight','bold')
ylim([0,17])
set(gca, 'YGrid', 'on', 'XGrid', 'off');
legend([p1, meds(1)],{'Mean Total Cost Savings','Median Total Cost Savings'},...
    'Location','northwest')
title('Static Operations')

% adaptive operations
nexttile
groups = [repmat({'Flexible Design'},length(Idx_bestFlex_adapt),1); ...
    repmat({'Flexible Planning'},length(Idx_bestPlan_adapt),1)];
boxplot([-TotalCostDiff_adapt(Idx_bestFlex_adapt);TotalCostDiff_adapt(Idx_bestPlan_adapt)],...
    groups,'BoxStyle','filled','Widths',0.3,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
hold on
plot(1,mean(-TotalCostDiff_adapt(Idx_bestFlex_adapt)), 'k.')
plot(2,mean(TotalCostDiff_adapt(Idx_bestPlan_adapt)), 'k.')
whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1),'Color','k');
set(meds(2),'Color','k');
set(whisks(1),'Color',facecolors(6,:));
set(whisks(2),'Color',facecolors(4,:));
set(outs(1),'MarkerEdgeColor',facecolors(6,:));
set(outs(2),'MarkerEdgeColor',facecolors(4,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(6,:),'Linewidth',25);
set(a(2),'Color',facecolors(4,:),'Linewidth',25);
ylim([0,17])
set(gca, 'YGrid', 'on', 'XGrid', 'off');
title('Flexible Operations')

title(t, 'Total Cost Savings for Flexible Design vs. Flexible Planning',...
    'FontWeight','bold')


%% Find Top 10% of Forward Simulations where Total Cost Flex Design < Flex Plan

% 1 is flex design, 2 is static design, 3 is flex planning

% (1) find the row indices of top 10 percent of forward simulations where flex design
% performs better than flexible planning (and vice-versa)

% make a generalized vector of 10,000 indices
allIdx = 1:length(totalCostTime_nonadapt);

% STATIC OPS INDICES
TotalCostDiff_nonadapt = (sum(totalCostTime_nonadapt(:,:,1),2) - sum(totalCostTime_nonadapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt > 0);
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt < 0);

% FLEXIBLE OPS INDICES
TotalCostDiff_adapt = (sum(totalCostTime_adapt(:,:,1),2) - sum(totalCostTime_adapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt > 0);
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt < 0);

Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt >= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt>0), 90));
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt <= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt<0), 10));
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt >= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt>0), 90));
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt <= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt<0), 10));

% plot histogram of climate states:
f=figure;
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';

% static operations
nexttile
% groups = [repmat({'Flexible Design'},length(Idx_bestFlex_nonadapt),5); ...
%     repmat({'Flexible Planning'},length(Idx_bestPlan_nonadapt),5)];
% boxplot([reshape(P_state_adapt(Idx_bestFlex_nonadapt,:),[],1);...
%     reshape(P_state_adapt(Idx_bestPlan_nonadapt,:),[],1)], groups,'Widths',0.7,'OutlierSize',5,'Symbol','.','BoxStyle','filled')

boxplot([P_state_adapt(Idx_bestFlex_nonadapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)-0.2])

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(3,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(3,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(3,:));

hold on
boxplot([P_state_adapt(Idx_bestPlan_nonadapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)+0.2])

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(5,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(5,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(5,:));

hold on
p1=plot((1:5)-0.2,mean(P_state_adapt(Idx_bestFlex_nonadapt,:)), 'k.');
plot((1:5)+0.2,mean(P_state_adapt(Idx_bestPlan_nonadapt,:)), 'k.')

xticks(1:5)
xticklabels(decade_short);
ax=gca;
ax.XAxis.FontSize = 8;
xlabel('Time Period','FontWeight','bold')
                
ylabel('Precipitation State (mm/mo)','FontWeight','bold')
ylim([66,97])
set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
title('Static Operations',...
    'FontWeight','bold')

% flexible operations
nexttile
%hold on
% groups = [repmat({'Flexible Design'},length(Idx_bestFlex_adapt)*5,1);...
%     repmat({'Flexible Planning'},length(Idx_bestPlan_adapt)*5,1)];
% boxplot([reshape(P_state_adapt(Idx_bestFlex_adapt,:),[],1);...
%     reshape(P_state_adapt(Idx_bestPlan_adapt,:),[],1)], groups,'Widths',0.7,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
% hold on
boxplot([P_state_adapt(Idx_bestFlex_adapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)-0.2])

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(4,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(4,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(4,:));

hold on
boxplot([P_state_adapt(Idx_bestPlan_adapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)+0.2])
whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(6,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(6,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(6,:));

hold on
p1=plot((1:5)-0.2,mean(P_state_adapt(Idx_bestFlex_adapt,:)), 'k.');
plot((1:5)+0.2,mean(P_state_adapt(Idx_bestPlan_adapt,:)), 'k.')

xticks(1:5)
xticklabels(decade_short);
ax=gca;
ax.XAxis.FontSize = 8;
xlabel('Time Period','FontWeight','bold')
ylim([66,97])

%ylim([0,17])
set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
legend([p1, meds(1) a(1) a(6)],{'Mean Precipitation State','Median Precipitation State',...
    'Flexible Planning','Flexible Design'},'Location','northwest')

title('Flexible Operations',...
    'FontWeight','bold')
title(t, 'Box Plot of Precipitation States by Time Period','Fontweight','bold')


% Now reindex based on best 10 percent
Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt >= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt>0), 90));
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt <= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt<0), 10));
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt >= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt>0), 90));
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt <= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt<0), 10));



% (2) Plot sample forward simulations

for type = 1:2 % (1) nonadapt and (2) adaptive ops
    for q=1:2 % (1) flex design better than plan and (2) flex plan better than design
        if type==1 % nonadaptive ops
            TotalCostDiff = TotalCostDiff_nonadapt;
            if q==1
                Idx = Idx_bestFlex_nonadapt;
            else
                Idx = Idx_bestPlan_nonadapt;
            end
        else % adaptive ops
            TotalCostDiff = TotalCostDiff_adapt;
            if q==1
                Idx = Idx_bestFlex_adapt;
            else
                Idx = Idx_bestPlan_adapt;
            end
        end
        
        % consider only *unique* forward simulations of climate
        P_state = P_state_adapt(Idx,:);
        [~, uniquePs] = unique(P_state,'rows');
        Idx = Idx(uniquePs);
        
        % instead of random top 10 percent best performing, choose top 10
        [TotalCost_top10,Idx_top10] = maxk(TotalCostDiff(Idx),1); % was 10, now 1
        Idx = Idx(Idx_top10);
        
        % update actions for capacity indexing
        action_adapt_nonzero = action_adapt;
        action_nonadapt_nonzero = action_nonadapt;
        for z = 1:2 % (1) adapt (2) nonadapt
            for r=1:4
                for i=2:5 % each expansion action
                    if z == 1
                        action_adapt_nonzero(action_adapt_nonzero(:,i,r)==0,i,r) ...
                            = action_adapt_nonzero(action_adapt_nonzero(:,i,r)==0,i-1,r);
                    else
                        action_nonadapt_nonzero(action_nonadapt_nonzero(:,i,r)==0,i,r) ...
                            = action_nonadapt_nonzero(action_nonadapt_nonzero(:,i,r)==0,i-1,r);
                    end
                end
            end
        end
        
        s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
            (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
        
        s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
            (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
        
        % forward simulations of shortage and infrastructure costs
        totalCost_adapt = squeeze(totalCostTime_adapt(Idx,:,1:3))/1E6;% 1 is flex, 2 is static
        totalCost_nonadapt = squeeze(totalCostTime_nonadapt(Idx,:,1:3))/1E6;% 1 is flex, 2 is static
        damCost_adapt = squeeze(damCostTime_adapt(Idx,:,1:3))/1E6;% 1 is flex, 2 is static
        damCost_nonadapt = squeeze(damCostTime_nonadapt(Idx,:,1:3))/1E6;% 1 is flex, 2 is static
        
        % Make dam capacity time series
        damCapIdxStatic_nonadapt = repmat(bestAct_nonadapt(2),[length(Idx),5]);
        damCapIdxStatic_adapt = repmat(bestAct_adapt(2),[length(Idx),5]);
        damCapIdxFlex_nonadapt = s_C_nonadapt(action_nonadapt_nonzero(Idx,:,1));
        damCapIdxFlex_adapt = s_C_adapt(action_adapt_nonzero(Idx,:,1));
        damCapIdxPlan_nonadapt = s_C_nonadapt(action_nonadapt_nonzero(Idx,:,3));
        damCapIdxPlan_adapt = s_C_adapt(action_adapt_nonzero(Idx,:,3));
        
        % randomly sample 15 of the shared forward simulation indices
        %s = RandStream('mlfg6331_64');
        %idxs = randsample(s,length(Idx),min(length(Idx),10)); % sample without replacement
        idxs = randsample(length(Idx),min(length(Idx),1)); % sample without replacement (previously 5 rand)
        
        for fg = 1:ceil(length(idxs)/5)
            figure('WindowState','maximized');
            t = tiledlayout(3,5);
            %t = tiledlayout(1,3);
            for j = 1:5
                idx = idxs(5*(fg-1)+j); % random sample
                % plot dam capacities
                %subplot(5,3,j+3*(i-1))
                nexttile(j)
                l1 = plot(1:5,repmat(bestAct_nonadapt(2),[1,5]),'Color',facecolors(1,:),'LineWidth',1.5);
                hold on
                l2 = plot(1:5,repmat(bestAct_adapt(2),[1,5]),'Color',facecolors(2,:),'LineWidth',1.5);
                hold on
                l3 = plot(1:5, s_C_nonadapt(action_nonadapt_nonzero(Idx(idx),:,1)),'Color',facecolors(3,:),'LineWidth',1.5);
                hold on
                l4 = plot(1:5, s_C_adapt(action_adapt_nonzero(Idx(idx),:,1)),'Color',facecolors(4,:),'LineWidth',1.5);
                hold on
                l5 = plot(1:5, s_C_nonadapt(action_nonadapt_nonzero(Idx(idx),:,3)),'Color',facecolors(5,:),'LineWidth',1.5);
                hold on
                l6 = plot(1:5, s_C_adapt(action_adapt_nonzero(Idx(idx),:,3)),'Color',facecolors(6,:),'LineWidth',1.5);
                
                xlim([1,5])
                ylim([0,160])
                grid('minor')
                grid on
                title('Dam Capacity vs. Time','FontWeight','bold')
                ylabel('Capacity (MCM)')
                
                % omit lines for static or non-adaptive operations
                if type == 1 % nonadaptive
                    l2.Color(4) = 0;
                    l4.Color(4) = 0;
                    l6.Color(4) = 0;
                else
                    l1.Color(4) = 0;
                    l3.Color(4) = 0;
                    l5.Color(4) = 0;
                end
                
                % add line for precipitation state over time on secondary axis:
                yyaxis right
                hold on
                p1 = plot(P_state_adapt(Idx(idx),:),'color','black','LineWidth',1.5);
                labs = string(P_state_adapt(Idx(idx),:));
                text([1:5],P_state_adapt(Idx(idx),:)+2,labs,'Fontsize', 8)
                ylabel('P State (mm/mo)')
                ylim([65,95]);
                xlim([1,5])
                box on
                
                ax = gca;
                ax.YAxis(1).Color = 'k';
                ax.YAxis(2).Color = 'k';
                xticklabels([]);
                
                % plot dam costs
                nexttile(j+5)
                h(1) = plot(1:5, damCost_nonadapt(:,2), 'Color',facecolors(1,:),'LineWidth',1.5);
                hold on
                h(2) = plot(1:5, damCost_adapt(:,2),'Color',facecolors(2,:),'LineWidth',1.5);
                hold on
                h(3) = plot(1:5, damCost_nonadapt(:,1),'Color',facecolors(3,:),'LineWidth',1.5);
                hold on
                h(4) = plot(1:5, damCost_adapt(:,1),'Color',facecolors(4,:),'LineWidth',1.5);
                hold on
                h(5) = plot(1:5, damCost_nonadapt(:,3),'Color',facecolors(5,:),'LineWidth',1.5);
                hold on
                h(6) = plot(1:5, damCost_adapt(:,3)+1,'Color',facecolors(6,:),'LineWidth',1.5);
                ylabel('Cost (M$)','FontWeight','bold')
                title('Infrastructure Cost vs. Time','FontWeight','bold')
                grid('minor')
                grid on
                
                xticklabels([]);
                if type == 1 % nonadaptive
                    h(2).Color(4) = 0;
                    h(4).Color(4) = 0;
                    h(6).Color(4) = 0;
                else
                    h(1).Color(4) = 0;
                    h(3).Color(4) = 0;
                    h(5).Color(4) = 0;
                end
                
                
                % plot shortage costs
                
                nexttile(j+10)
                l1 = plot(1:5,  totalCost_nonadapt(:,2)-damCost_nonadapt(:,2), 'Color',facecolors(1,:),'LineWidth',1.5);
                hold on
                l2 = plot(1:5, totalCost_adapt(:,2)-damCost_adapt(:,2),'Color',facecolors(2,:),'LineWidth',1.5);
                hold on
                l3 = plot(1:5, totalCost_nonadapt(:,1)-damCost_nonadapt(:,1),'Color',facecolors(3,:),'LineWidth',1.5);
                hold on
                l4 = plot(1:5,  totalCost_adapt(:,1)-damCost_adapt(:,1),'Color',facecolors(4,:),'LineWidth',1.5);
                hold on
                l5 = plot(1:5, totalCost_nonadapt(:,3)-damCost_nonadapt(:,3),'Color',facecolors(5,:),'LineWidth',1.5);
                hold on
                l6 = plot(1:5, totalCost_adapt(:,3)-damCost_adapt(:,3),'Color',facecolors(6,:),'LineWidth',1.5);
                
                %                     % annotate minimum expansion costs:
                %                     hold on
                %                     l1 = yline(infra_cost_adaptive_lookup(5)/1E6, '--', 'color', facecolors(3,:), 'LineWidth',2);
                %                     hold on
                %                     l2 = yline(infra_cost_nonadaptive_lookup(5)/1E6, 'color',facecolors(3,:), 'LineWidth',2);
                %                     hold on
                %                     l3=yline(infra_cost_adaptive_lookup(5+bestAct_adapt(4))/1E6, '--','color', facecolors(5,:), 'LineWidth',2);
                %                     hold on
                %                     l4=yline(infra_cost_nonadaptive_lookup(5+bestAct_nonadapt(4))/1E6,'color', facecolors(5,:), 'LineWidth',2);
                %                     hold on
                
                ylabel('Cost (M$)','FontWeight','bold')
                yl = ylim;
                ylim([0,yl(2)+5])
                grid('minor')
                grid on
                title('Shortage Costs vs. Time','FontWeight','bold')
                xticks(1:5)
                xticklabels(decade_short);
                ax=gca;
                ax.XAxis.FontSize = 8;
                xlabel('Time Period','FontWeight','bold')
                
                % omit lines for static or non-adaptive operations
                if type == 1 % nonadaptive
                    l2.Color(4) = 0;
                    l4.Color(4) = 0;
                    l6.Color(4) = 0;
                else
                    l1.Color(4) = 0;
                    l3.Color(4) = 0;
                    l5.Color(4) = 0;
                end
                
            end
            
            % include corresponding legend
            if type == 1
                hL = legend([h(1), h(3), h(5), p1],{strcat("Static Design & Static Ops"),...
                    strcat("Flexible Design & Static Ops"),...
                    strcat("Flexible Planning & Static Ops"),...
                    "Precip. state"},'Orientation','horizontal', 'FontSize', 9);
            elseif type == 2
                hL = legend([h(2), h(4), h(6), p1],{strcat("Static Design & Static Ops"),...
                    strcat("Flexible Design & Static Ops"),...
                    strcat("Flexible Planning & Static Ops"),...
                    "Precip. state"},'Orientation','horizontal', 'FontSize', 9);
            else
                hL = legend([h(1), h(2), h(3), h(4), h(5), h(6), p1],{strcat("Static Design & Static Ops"),strcat("Static Design & Flexible Ops"),...
                    strcat("Flexible Design & Static Ops"),...
                    strcat("Flexible Design & Flexible Ops"),strcat("Flexible Planning & Static Ops"),...
                    strcat("Flexible Planning & Flexible Ops"),"Precip. state"},'Orientation','horizontal', 'FontSize', 9);
            end
            
            % Programatically move the Legend
            newPosition = [0.05 0.025 0.9 0.025];
            newUnits = 'normalized';
            set(hL,'Position', newPosition,'Units',newUnits);
            
            if type ==1
                title(t, "Sample Forward Simulations (Static Operations)")
            else
                title(t, "Sample Forward Simulations (Flexible Operations)")
            end
                            
            if q == 1
                subtitle(t,{'Total Cost Flex Design < Total Cost Flex Planning'},'FontSize',14, 'FontWeight','bold')
            else
                subtitle(t,{'Total Cost Flex Design > Total Cost Flex Planning'},'FontSize',14, 'FontWeight','bold')
            end
            
            facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [180, 180, 231];...
    [255, 102, 102]; [255, 153, 153]]/255;
expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;

f = figure('WindowState','maximized');
t = tiledlayout(2,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';

    if type == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif type == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    % create combined policy where each row is the next time period
    X_newFlex = zeros(5, length(s_P_abs));
    X_newPlan = zeros(5, length(s_P_abs));
    for N=2:5
        X_newFlex(N,:) = X(N,:,2,N);
        X_newPlan(N,:) = X(N,:,3,N);
    end
    % binary expand (1) vs. non-expand (0)
    X_newFlex(X_newFlex ~= 0) = 1;
    X_newPlan(X_newPlan ~= 0) = 1;
    
    % plot the newly formatted policies

    for q=1:2 % flex design and flex planning
        
        if q == 1
            %ax = subplot(1,4,1+2*(s-1));
            ax = nexttile;
            imagesc(1:5,s_P_abs,X_newFlex')
            xticks(1:5) 
            xticklabels([])
            if type == 1
                title("Flexible Design & Static Ops.",'FontWeight','bold','Color',facecolors(3,:))
                %ylabel('Time Period','FontWeight','bold')
            else
                title("Flexible Design & Flexible Ops.",'FontWeight','bold','Color',facecolors(4,:))
                xticklabels([])
            end
        else
            %ax = subplot(1,4,2+2*(s-1));
            ax = nexttile;
            imagesc(1:5,s_P_abs,X_newPlan')
            xticks(1:5)
            xticklabels([])
            %yticklabels(decade_short)
            if type == 1
                title("Flexible Planning & Static Ops.",'FontWeight','bold','Color',facecolors(5,:))
            else
                title("Flexible Planning & Flexible Ops.",'FontWeight','bold','Color',facecolors(6,:))
                xticklabels({decade_short{1:5}})
            end
        end
        map = expansion_colors([1,4],:);
        step = 1/(2*(1+bestAct(9)));
        caxis([0, 1])

        colormap(ax, map);
        set(gca,'YDir','normal')

        %ax(N).YAxis.Visible = 'off';
        %xlabel('Mean P [mm/m]','FontWeight','bold')
        box on
        set(ax,'ytick',[65:5:97])
        set(ax,'xtick',[1:5])
        for i=1:5
            xline(i-0.5,'color',[0.3,0.3,0.3])
        end
        set(ax, 'YGrid', 'on', 'XGrid', 'off');
        
        % plot precip transition
        for i=1:length(idxs)
            hold on
            p1 = plot(P_state_adapt(Idx(idxs(i)),:),'color','black','LineWidth',0.8);
            p1 = scatter(1:5,P_state_adapt(Idx(idxs(i)),:),5,'black','filled','MarkerEdgeColor','black');
            labs = string(P_state_adapt(Idx(idxs(i)),:));
            text([1:5]-0.01,P_state_adapt(Idx(idxs(i)),:)+2,labs,'Fontsize', 5)
        end
        
    
    if q ==2
        h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
            'TickLabels',["Do Not\newlineExpand","Expand"]);
        h.Location = 'eastoutside';
        hpos = get(h, 'Position');
        h.Position = [0.92 0.11 0.015 0.81];
    end

    title(t,"Infrastructure Expansion Policies",'FontWeight','bold','FontSize',15)
    xlabel(t, "Time Period",'FontWeight','bold')
    ylabel(t, "Mean Precipitation [mm/mo]",'FontWeight','bold')
end
            
        end
    end
end

%% Flex Planning vs. Design:
%Costs and climate states Flex design with flex ops better than flex planning

% 1 is flex design, 2 is static design, 3 is flex planning

% make a generalized vector of 10,000 indices
allIdx = 1:length(totalCostTime_nonadapt);

% FLEXIBLE OPS INDICES
TotalCostDiff_adapt = (sum(totalCostTime_adapt(:,:,1),2) - sum(totalCostTime_adapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt > 0);
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt < 0);

% SET UP FIGURE:
f=figure;
t = tiledlayout(4,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';

% ========================================================================
% (1) BAR GRAPH: NUMBER SIMS FLEX DESIGN VS. FLEX PLANNING PERFORM BETTER

% flexible ops
nexttile([2,1])
b = bar([length(Idx_bestFlex_adapt); length(Idx_bestPlan_adapt)],'FaceColor','flat');
for i=1:length(b.XData)
    b.CData(i,:) = facecolors(2+2*i,:);
end
xticklabels({'Flexible Design', 'Flexible Planning'})
set(gca, 'YGrid', 'on', 'XGrid', 'off');
xlim([0.5,2.5])
ylim([0,9000])
ylabel('Number of Simulations','FontWeight','bold')
title('Frequency of Best Performance in Simulations',...
    'FontWeight','bold')

% =========================================================================
% (2) BOXPLOT: TOTAL COST SAVINGS FROM SIMULATIONS

% flexible operations
nexttile([2,1])
groups = [repmat({'Flexible Design'},length(Idx_bestFlex_adapt),1); ...
    repmat({'Flexible Planning'},length(Idx_bestPlan_adapt),1)];
boxplot([-TotalCostDiff_adapt(Idx_bestFlex_adapt);TotalCostDiff_adapt(Idx_bestPlan_adapt)],...
    groups,'BoxStyle','filled','Widths',0.3,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
hold on
plot(1,mean(-TotalCostDiff_adapt(Idx_bestFlex_adapt)), 'k.')
plot(2,mean(TotalCostDiff_adapt(Idx_bestPlan_adapt)), 'k.')
whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1),'Color','k');
set(meds(2),'Color','k');
set(whisks(1),'Color',facecolors(6,:));
set(whisks(2),'Color',facecolors(4,:));
set(outs(1),'MarkerEdgeColor',facecolors(6,:));
set(outs(2),'MarkerEdgeColor',facecolors(4,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(6,:),'Linewidth',25);
set(a(2),'Color',facecolors(4,:),'Linewidth',25);
ylim([0,17])
set(gca, 'YGrid', 'on', 'XGrid', 'off');
ylabel('Cost Savings (M$)','FontWeight','bold')

title('Simulated Total Cost Savings','FontWeight','bold')

% =========================================================================
% (3) BOXPLOT: CLIMATE STATES OF 10% BEST SIMULATIONS

% find the row indices of top 10 percent of forward simulations where flex design
% performs better than flexible planning (and vice-versa)

% make a generalized vector of 10,000 indices
allIdx = 1:length(totalCostTime_nonadapt);

% FLEXIBLE OPS INDICES
TotalCostDiff_adapt = (sum(totalCostTime_adapt(:,:,1),2) - sum(totalCostTime_adapt(:,:,3),2))/1E6; % flex design - flex planning
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt > 0);
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt < 0);

Idx_bestPlan_nonadapt = allIdx(TotalCostDiff_nonadapt >= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt>0), 90));
Idx_bestFlex_nonadapt = allIdx(TotalCostDiff_nonadapt <= prctile(TotalCostDiff_nonadapt(TotalCostDiff_nonadapt<0), 10));
Idx_bestPlan_adapt = allIdx(TotalCostDiff_adapt >= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt>0), 90));
Idx_bestFlex_adapt = allIdx(TotalCostDiff_adapt <= prctile(TotalCostDiff_adapt(TotalCostDiff_adapt<0), 10));

% PLOT CLIMATE STATE TRENDS IN BEST 10% SIMULATIONS (for flexible operations only)
%nexttile([2,2])
figure()
%hold on
% groups = [repmat({'Flexible Design'},length(Idx_bestFlex_adapt)*5,1);...
%     repmat({'Flexible Planning'},length(Idx_bestPlan_adapt)*5,1)];
% boxplot([reshape(P_state_adapt(Idx_bestFlex_adapt,:),[],1);...
%     reshape(P_state_adapt(Idx_bestPlan_adapt,:),[],1)], groups,'Widths',0.7,'OutlierSize',5,'Symbol','.','BoxStyle','filled')
% hold on
boxplot([P_state_adapt(Idx_bestFlex_adapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)-0.2])

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(4,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(4,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(4,:),'LineWidth',20);

hold on
boxplot([P_state_adapt(Idx_bestPlan_adapt,:)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', [(1:5)+0.2])
whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1:5),'Color','k');
set(whisks(1:5),'Color',facecolors(6,:));
set(outs(1:5),'MarkerEdgeColor',facecolors(6,:));
a = findobj(gca,'Tag','Box');
set(a(1:5),'Color',facecolors(6,:),'LineWidth',20);

hold on
p1=plot((1:5)-0.2,mean(P_state_adapt(Idx_bestFlex_adapt,:)), 'k.');
plot((1:5)+0.2,mean(P_state_adapt(Idx_bestPlan_adapt,:)), 'k.')

xticks(1:5)
xticklabels(decade_short);
ax=gca;
ax.XAxis.FontSize = 10;
xlabel('Time Period','FontWeight','bold')
ylim([65,100])
ylabel('Precipitation State (mm/mo)','FontWeight','bold')

%ylim([0,17])
set(gca, 'YGrid', 'off', 'YMinorGrid','off', 'XGrid', 'off');
leg1 = legend([a(1) a(6)],{'Flexible Planning','Flexible Design'},'Location','northwest')
%title(leg1,{'Simulations with Greatest Cost Savings\newlinefor Flexible Planning vs. Flexible Design'})

title({'Simulations with Greatest Cost Savings for Flexible Planning vs. Flexible Design'},'Fontweight','bold','FontSize',11)


%% Alternative policy visualization (Expand vs. no expand) since T state is deterministic: [4,1]


% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [180, 180, 231];...
    [255, 102, 102]; [255, 153, 153]]/255;
expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

f = figure('WindowState','maximized');
t = tiledlayout(4,1);
t.TileSpacing = 'compact';
%t.Padding = 'compact';

for s=1:2 % adapt vs non-adapt
    if s == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif s == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    % create combined policy where each row is the next time period
    X_newFlex = zeros(5, length(s_P_abs));
    X_newPlan = zeros(5, length(s_P_abs));
    for N=2:5
        X_newFlex(N,:) = X(N,:,2,N);
        X_newPlan(N,:) = X(N,:,3,N);
    end
    % binary expand (1) vs. non-expand (0)
    X_newFlex(X_newFlex ~= 0) = 1;
    X_newPlan(X_newPlan ~= 0) = 1;
    
    % plot the newly formatted policies

    for q=1:2 % flex design and flex planning
        
        if q == 1
            %ax = subplot(1,4,1+2*(s-1));
            ax = nexttile(q + s - 1);
            imagesc(1:5,s_P_abs,X_newFlex')
            xticks(1:5) 
            xticklabels([])
            if s == 1
                title("Flexible Design & Static Ops.",'FontWeight','bold','Color',facecolors(3,:))
                %ylabel('Time Period','FontWeight','bold')
            else
                title("Flexible Design & Flexible Ops.",'FontWeight','bold','Color',facecolors(4,:))
                xticklabels([])
            end
        else
            %ax = subplot(1,4,2+2*(s-1));
            ax = nexttile(q + s);
            imagesc(1:5,s_P_abs,X_newPlan')
            xticks(1:5)
            xticklabels([])
            %yticklabels(decade_short)
            if s == 1
                title("Flexible Planning & Static Ops.",'FontWeight','bold','Color',facecolors(5,:))
            else
                title("Flexible Planning & Flexible Ops.",'FontWeight','bold','Color',facecolors(6,:))
                xticklabels({decade_short{1:5}})
            end
        end
        map = expansion_colors([1,4],:);
        step = 1/(2*(1+bestAct(9)));
        caxis([0, 1])

        colormap(ax, map);
        set(gca,'YDir','normal')

        %ax(N).YAxis.Visible = 'off';
        %xlabel('Mean P [mm/m]','FontWeight','bold')
        box on
        set(ax,'ytick',[65:5:97])
        set(ax,'xtick',[1:5])
        for i=1:5
            xline(i-0.5,'color',[0.3,0.3,0.3])
        end
        set(ax, 'YGrid', 'on', 'XGrid', 'off');
        
        % plot precip transition
        for i=1:length(idxs)
            hold on
            p1 = plot(P_state(idxs(i),:),'color','black','LineWidth',0.8);
            p1 = scatter(1:5,P_state(idxs(i),:),5,'black','filled','MarkerEdgeColor','black');
            labs = string(P_state(idxs(i),:));
            text([1:5]-0.01,P_state(idxs(i),:)+2,labs,'Fontsize', 8)
        end
        
    end
    
    if s == 2 && q ==2
        h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
            'TickLabels',["Do Not\newlineExpand","Expand"]);
        h.Location = 'eastoutside';
        hpos = get(h, 'Position');
        h.Position = [0.92 0.11 0.015 0.81];
    end

    title(t,"Infrastructure Expansion Policies",'FontWeight','bold','FontSize',15)
    xlabel(t, "Time Period",'FontWeight','bold')
    ylabel(t, "Mean Precipitation [mm/mo]",'FontWeight','bold')
end

%% Alternative policy visualization since T state is deterministic: [4,1]


% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [180, 180, 231];...
    [255, 102, 102]; [255, 153, 153]]/255;
%expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
%expansion_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]]/255;
expansion_colors = [[205,213,223];[167,208,241];[113,161,193];[39,76,119];[20,37,62]]/255; % 80,90,100,110 MCM:[255,255,255];[230,230,230];[240,240,240];[205,213,223];
%expansion_colors = [[39,76,119];[20,37,62]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

f = figure('WindowState','maximized');
t = tiledlayout(4,1);
t.TileSpacing = 'compact';
%t.Padding = 'compact';

for s=1:2 % adapt vs non-adapt
    if s == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif s == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    % storage capacity look-up vector (MCM):
    minStor_all = min([bestAct_nonadapt(3), bestAct_nonadapt(8), bestAct_adapt(3), bestAct_adapt(8)]);
    stor = [bestAct(2), bestAct(3), bestAct(8), ...
        bestAct(3)+bestAct(5):bestAct(5):bestAct(3)+bestAct(5)*bestAct(4),...
        bestAct(8)+bestAct(10):bestAct(10):bestAct(8)+bestAct(10)*bestAct(9)];
    
    % create combined policy where each row is the next time period
    X_newFlex = zeros(5, length(s_P_abs));
    X_newPlan = zeros(5, length(s_P_abs));
    for N=2:5
        X_newFlex(N,:) = X(N,:,2,N);
        X_newPlan(N,:) = X(N,:,3,N);
    end
    % binary expand (1) vs. non-expand (0)
    %X_newFlex(X_newFlex ~= 0) = 1;
    %X_newPlan(X_newPlan ~= 0) = 1;
    X_newFlex(X_newFlex == 0) = 2;
    X_newPlan(X_newPlan == 0) = 3;
    X_newFlex = stor(X_newFlex);
    X_newPlan = stor(X_newPlan);
    
    % plot the newly formatted policies

    for q=1:2 % flex design and flex planning
        
        if q == 1
            %ax = subplot(1,4,1+2*(s-1));
            ax = nexttile(q + s - 1);
            imagesc(1:5,s_P_abs,X_newFlex')
            xticks(1:5) 
            xticklabels([])
            if s == 1
                title("Flexible Design & Static Ops.",'FontWeight','bold','Color',facecolors(3,:))
                %ylabel('Time Period','FontWeight','bold')

                for ln = 1:2
                    hold on
                    if ln == 1
                        TotalCostDiff = TotalCostDiff_nonadapt;
                        Idx = Idx_bestPlan_nonadapt;
                    else
                        TotalCostDiff = TotalCostDiff_nonadapt;
                        Idx = Idx_bestFlex_nonadapt;
                    end
                    
                    % consider only *unique* forward simulations of climate
                    P_state = P_state_adapt(Idx,:);
                    [~, uniquePs] = unique(P_state,'rows');
                    Idx = Idx(uniquePs);
                    
                    % instead of random top 10 percent best performing, choose top 1
                    [TotalCost_top10,Idx_top10] = maxk(TotalCostDiff(Idx),1);
                    Idx = Idx(Idx_top10);
                    
                    % plot best performing P state simulation
%                     if ln == 1
%                         p1 = plot(P_state_adapt(Idx,:),'color',facecolors(5,:),'LineWidth',1.5);
%                     else
%                         p1 = plot(P_state_adapt(Idx,:),'color',facecolors(3,:),'LineWidth',1.5);
%                     end
%                     labs = string(P_state_adapt(Idx,:));
%                     text([1:5],P_state_adapt(Idx,:)+2,labs,'Fontsize', 8)
                end
               
            else
                title("Flexible Design & Flexible Ops.",'FontWeight','bold','Color',facecolors(4,:))
                xticklabels([])
                
                                for ln = 1:2
                hold on
                if ln == 1
                    TotalCostDiff = TotalCostDiff_adapt;
                    Idx = Idx_bestPlan_nonadapt;
                else
                    TotalCostDiff = TotalCostDiff_adapt;
                    Idx = Idx_bestFlex_nonadapt;  
                end
                
                % consider only *unique* forward simulations of climate
                P_state = P_state_adapt(Idx,:);
                [~, uniquePs] = unique(P_state,'rows');
                Idx = Idx(uniquePs);
                
                % instead of random top 10 percent best performing, choose top 1
                [TotalCost_top10,Idx_top10] = maxk(TotalCostDiff(Idx),1);
                Idx = Idx(Idx_top10);
                
                % plot best performing P state simulation
%                 if ln == 1
%                     p1 = plot(P_state_adapt(Idx,:),'color',facecolors(6,:),'LineWidth',1.5);
%                 else
%                     p1 = plot(P_state_adapt(Idx,:),'color',facecolors(4,:),'LineWidth',1.5);
%                 end
%                 labs = string(P_state_adapt(Idx,:));
%                 text([1:5],P_state_adapt(Idx,:)+2,labs,'Fontsize', 8)
                end
            end
            %map = expansion_colors((min(X_newFlex',[],'all')-minStor_all)/10:(min(X_newFlex',[],'all')-minStor_all)/10+bestAct(4),:);  
            map = expansion_colors(1+(min(X_newFlex',[],'all')-minStor_all)/10:1+(max(X_newFlex',[],'all')-minStor_all)/10,:);          
        else
            %ax = subplot(1,4,2+2*(s-1));
            ax = nexttile(q + s);
            imagesc(1:5,s_P_abs,X_newPlan')
            xticks(1:5)
            xticklabels([])
            %yticklabels(decade_short)
            if s == 1
                title("Flexible Planning & Static Ops.",'FontWeight','bold','Color',facecolors(5,:))
                for ln = 1:2
                hold on
                if ln == 1
                    TotalCostDiff = TotalCostDiff_nonadapt;
                    Idx = Idx_bestPlan_nonadapt;
                else
                    TotalCostDiff = TotalCostDiff_nonadapt;
                    Idx = Idx_bestFlex_nonadapt;  
                end
                
                % consider only *unique* forward simulations of climate
                P_state = P_state_adapt(Idx,:);
                [~, uniquePs] = unique(P_state,'rows');
                Idx = Idx(uniquePs);
                
                % instead of random top 10 percent best performing, choose top 1
                [TotalCost_top10,Idx_top10] = maxk(TotalCostDiff(Idx),1);
                Idx = Idx(Idx_top10);
                
                % plot best performing P state simulation
%                 if ln == 1
%                     p1 = plot(P_state_adapt(Idx,:),'color',facecolors(5,:),'LineWidth',1.5);
%                 else
%                     p1 = plot(P_state_adapt(Idx,:),'color',facecolors(3,:),'LineWidth',1.5);
%                 end
%                 labs = string(P_state_adapt(Idx,:));
%                 text([1:5],P_state_adapt(Idx,:)+2,labs,'Fontsize', 8)
                end
            else
                title("Flexible Planning & Flexible Ops.",'FontWeight','bold','Color',facecolors(6,:))
                xticklabels({decade_short{1:5}})
                
                for ln = 1:2
                    hold on
                    if ln == 1
                        TotalCostDiff = TotalCostDiff_adapt;
                        Idx = Idx_bestPlan_nonadapt;
                    else
                        TotalCostDiff = TotalCostDiff_adapt;
                        Idx = Idx_bestFlex_nonadapt;
                    end
                    
                    % consider only *unique* forward simulations of climate
                    P_state = P_state_adapt(Idx,:);
                    [~, uniquePs] = unique(P_state,'rows');
                    Idx = Idx(uniquePs);
                    
                    % instead of random top 10 percent best performing, choose top 1
                    [TotalCost_top10,Idx_top10] = maxk(TotalCostDiff(Idx),1);
                    Idx = Idx(Idx_top10);
                    
                    % plot best performing P state simulation
%                     if ln == 1
%                         p1 = plot(P_state_adapt(Idx,:),'color',facecolors(6,:),'LineWidth',1.5);
%                     else
%                         p1 = plot(P_state_adapt(Idx,:),'color',facecolors(4,:),'LineWidth',1.5);
%                     end
%                     labs = string(P_state_adapt(Idx,:));
%                     text([1:5],P_state_adapt(Idx,:)+2,labs,'Fontsize', 8)
                end
                
            end
            %map = expansion_colors(1+(min(X_newPlan',[],'all')-minStor_all)/10:1+(min(X_newPlan',[],'all')-minStor_all)/10+bestAct(9),:);
            %map = expansion_colors(1+(min(X_newPlan',[],'all')-minStor_all)/10:1+(min(X_newPlan',[],'all')-minStor_all)/10,:);
            map = expansion_colors(1+(min(X_newPlan',[],'all')-minStor_all)/10:1+(max(X_newPlan',[],'all')-minStor_all)/10,:);
        end
        %map = expansion_colors([1,4],:);
        step = 1/(2*(1+bestAct(9)));
        %caxis([0, 1])
        
        colormap(ax, map);
        set(gca,'YDir','normal')
        
        %ax(N).YAxis.Visible = 'off';
        %xlabel('Mean P [mm/m]','FontWeight','bold')
        box on
        set(ax,'ytick',[65:5:97])
        set(ax,'xtick',[1:5])
        for i=1:5
            xline(i-0.5,'color',[0.3,0.3,0.3])
        end
        set(ax, 'YGrid', 'on', 'XGrid', 'off');
        
        % plot precip transition
        %for i=1:length(idxs)
         %   hold on
            %p1 = plot(P_state(idxs(i),:),'color','black','LineWidth',0.8);
            %p1 = scatter(1:5,P_state(idxs(i),:),5,'black','filled','MarkerEdgeColor','black');
            %labs = string(P_state(idxs(i),:));
            %text([1:5]-0.01,P_state(idxs(i),:)+2,labs,'Fontsize', 8)
        %end
        
    
    if s == 2 && q ==1
        %h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
        %    'TickLabels',["Do Not\newlineExpand","Expand"]);
        h = colorbar('TicksMode','manual','Ticks',[min(stor)+(max(stor)-min(stor))/12:(max(stor)-min(stor))/4:max(stor)],...
           'TickLabels',[strcat(string(min(stor):10:150),"\newlineMCM")]);
        h.Location = 'eastoutside';
        hpos = get(h, 'Position');
        h.Position = [0.92 0.11 0.015 0.81];
    end
end

    title(t,"Infrastructure Expansion Policies",'FontWeight','bold','FontSize',15)
    xlabel(t, "Time Period",'FontWeight','bold')
    ylabel(t, "Mean Precipitation [mm/mo]",'FontWeight','bold')
end

%% Plot SDP Optimal Expansion Policies with Deterministic Temperatures

% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
% expansion_colors = [[200, 198, 198];[144, 170, 203];[255, 176, 133];[249, 213, 167];...
%     [254, 241, 230]]/255;

% expansion_colors = [[[87, 117, 144];[67, 170, 139];[144, 190, 109];[249, 199, 79];...
%     [248, 150, 30];[243, 114, 44];[249, 65, 68]]/255];

expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

for s=1:2 % adapt vs non-adapt
    f = figure;
    if s == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif s == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    for N=2:5 % for each time period
        
        %ax(N)=subplot(2,5,N+(s-1)*N);
        
        if (s==1) && (N==1) % non-adaptive
            ax(N)=subplot(2,5,[1;6]);
            imagesc(s_P_abs,s_T_abs(N),X(N,:,2,N))
            map = [[153,204,204]/255; [153, 153, 204]/255; [255, 102, 102]/255];
            caxis([1, 3]);
            h = colorbar('TicksMode','manual','Ticks',[1.33, 2, 2.66],'TickLabels',{'Static\newlineDam', 'Flexible\newlineDesign\newlineDam', 'Flexible\newlineDam\newlinePlan'});
           
            colormap(ax(N), map);
            set(gca,'YDir','normal')
            
            h.Label.FontSize = 5;
            ylabel('Mean T [degrees C]','FontWeight','bold')
            xlabel('Mean P [mm/m]','FontWeight','bold')
            title({'Initial Policy';'2000-2020'},'FontWeight','bold')
        elseif (s==2) && (N ==1) % adaptive
            ax(N)=subplot(2,5,[1,6])
            imagesc(s_P_abs,s_T_abs(N),X(N,:,2,N))
            map = [[204,255,255]/255; [204, 204, 255]/255; [255, 153, 153]/255];
            caxis([1, 3]);
            h = colorbar('TicksMode','manual','Ticks',[1.33, 2, 2.66],'TickLabels',{'Static\newlineDam', 'Flexible\newlineDesign\newlineDam', 'Flexible\newlinePlan\newlineDam'});
            
            colormap(ax(N), map);
            set(gca,'YDir','normal')
            h.Label.FontSize = 5;
            
            ylabel('Mean T [degrees C]','FontWeight','bold')
            xlabel('Mean P [mm/m]','FontWeight','bold')
            title({'Initial Policy';'2000-2020'},'FontWeight','bold')
        else
            for flex_type = 1:2 % (1) flex design (2) flex planning
                %ax(N)=subplot(2,5,N+(flex_type-1)*5);
                ax(N)=subplot(2,4,N-1+(flex_type-1)*4);
                if flex_type == 1 % flex design
                    %X(X(:,:,2,N) == 0) = 3;
                    X(X(:,:,2,N) ~= 0) = 1;
                    %imagesc(s_P_abs,s_T_abs,(X(:,:,2,N)-3)/(bestAct(4)+1))
                    imagesc(s_P_abs,s_T_abs(N),X(N,:,2,N))
                    map = expansion_colors([1,4],:);
                    %step = 1/(2*(1+bestAct(4)));
                    caxis([0, 1])
                    %h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
                    %    'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_flex),"\newlineMCM")]);
                    h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
                        'TickLabels',["Do Not\newlineExpand","Expand"]);
                    %             caxis([2,2+bestAct(4)])
                    title({"Flexible Design Expansion Policy"; strcat(decade{N}," (",string(s_T_abs(N)),'^oC)')},'FontWeight','bold')
                else % flexible planning
                    %X(X(:,:,3,N) == 0) = 3+bestAct(4);
                    X(X(:,:,3,N) ~= 0) = 1;
                    %imagesc(s_P_abs,s_T_abs,(X(:,:,3,N)-3-bestAct(4))/(bestAct(9)+1))
                    imagesc(s_P_abs,s_T_abs(N),X(N,:,3,N))
                    %map = expansion_colors(1:bestAct(9)+1,:);
                    map = expansion_colors([1,4],:);
                    step = 1/(2*(1+bestAct(9)));
                    caxis([0, 1])
%                     h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
%                         'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_plan),"\newlineMCM")]);
                    h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
                        'TickLabels',["Do Not\newlineExpand","Expand"]);
                    %             caxis([2,2+bestAct(4)])
                    title({"Flexible Plan Expansion Policy"; strcat(decade{N}," (",string(s_T_abs(N)),'^oC)')},'FontWeight','bold')
                end
                %caxis([2, 2+bestAct(4)]);
                %caxis([1,2])
                colormap(ax(N), map);
                set(gca,'YDir','normal')
                
                %ylabel('Mean T [degrees C]','FontWeight','bold')
                ax(N).YAxis.Visible = 'off';
                xlabel('Mean P [mm/m]','FontWeight','bold')
                box on
                set(ax(N),'xtick',[65:5:97])
                set(ax(N), 'YGrid', 'off', 'XGrid', 'on');
            end
        end
        ylim([s_T_abs(N)-0.25,s_T_abs(N)+0.25])
    end
    
    
    if s==1
        sgtitle({'Static Operations';strcat('Static Dam = ',...
            num2str(bestAct_nonadapt(2))," MCM , Flexible Design Dam = ", num2str(bestAct_nonadapt(3)),"-",...
            num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM , Flexible Planned Dam = ",...
            num2str(bestAct_nonadapt(8)),"-",...
            num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM")},'FontWeight','bold');
    else
        sgtitle({'Flexible Operations';strcat('Static Dam = ',...
            num2str(bestAct_adapt(2))," MCM , Flexible Design Dam = ", num2str(bestAct_adapt(3)),"-",...
            num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM , Flexible Planned Dam = ",...
            num2str(bestAct_adapt(8)),"-",...
            num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM")},'FontWeight','bold');
    end
    
    
    figure_width = 25;
    figure_height = 10;
    
    % DERIVED PROPERTIES (cannot be changed; for info only)
    screen_ppi = 72;
    screen_figure_width = round(figure_width*screen_ppi); % in pixels
    screen_figure_height = round(figure_height*screen_ppi); % in pixels
    
    % SET UP FIGURE SIZE
    set(gcf, 'Position', [50, 10, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [figure_width figure_height]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);
    
    % save figure
    if s == 1
        filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/nonadaptive_policy_comb.png'];
        %saveas(f, filename1)
        %exportgraphics(f,filename1,'Resolution',1200)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/adaptive_policy_comb.png'];
        %saveas(f, filename2)
        %exportgraphics(f,filename2,'Resolution',1200)
    end
    %close
    %pcolor(X_adapt(:,:,2,N)) % all T states, all P states, initial flex capacity, N time period
end


% stack figures
% fcomb = figure;
% out = imtile({filename1; filename2},'GridSize',[2,1],'BorderSize', 50,'BackgroundColor', 'white');
% imshow(out);
%title({'Infrastructure and Expansion Policies'},'FontSize',15)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/policyV2_g7_percFlex5_percExp15.png'];
%saveas(fcomb, filename)
%exportgraphics(fcomb,filename,'Resolution',1200);

%% Alternative policy visualization since T state is deterministic: [1,4]

% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...

expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

f = figure('WindowState','maximized');
t = tiledlayout(1,4);
t.TileSpacing = 'compact';
%t.Padding = 'compact';

for s=1:2 % adapt vs non-adapt
    if s == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif s == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    % create combined policy where each row is the next time period
    X_newFlex = zeros(4, length(s_P_abs));
    X_newPlan = zeros(4, length(s_P_abs));
    for N=2:5
        X_newFlex(N-1,:) = X(N,:,2,N);
        X_newPlan(N-1,:) = X(N,:,3,N);
    end
    % binary expand (1) vs. non-expand (0)
    X_newFlex(X_newFlex ~= 0) = 1;
    X_newPlan(X_newPlan ~= 0) = 1;
    
    % plot the newly formatted policies

    for q=1:2 % flex design and flex planning
        
        if q == 1
            %ax = subplot(1,4,1+2*(s-1));
            ax = nexttile(q + s - 1);
            imagesc(s_P_abs,1:4,X_newFlex)
            yticks(0.5:1:4.5)   
            
            if s == 1
                title("Flexible Design & Static Ops.",'FontWeight','bold');
                %yticklabels({decade_short{1:5}})
                yticklabels(2020:20:2100)
                %ylabel('Time Period','FontWeight','bold')
            else
                title("Flexible Design & Flexible Ops.",'FontWeight','bold')
                yticklabels([])
            end
        else
            %ax = subplot(1,4,2+2*(s-1));
            ax = nexttile(q + s);
            imagesc(s_P_abs,1:4,X_newPlan)
            %yticks(1:4)
            yticks(0.5:1:4.5)
            yticklabels([])
            %yticklabels(decade_short)
            if s == 1
                title("Flexible Planning & Static Ops.",'FontWeight','bold');
            else
                title("Flexible Planning & Flexible Ops.",'FontWeight','bold')
            end
        end
        map = expansion_colors([1,4],:);
        step = 1/(2*(1+bestAct(9)));
        caxis([0, 1])

        colormap(ax, map);
        set(gca,'YDir','normal')

        %ax(N).YAxis.Visible = 'off';
        %xlabel('Mean P [mm/m]','FontWeight','bold')
        box on
        set(ax,'xtick',[65:5:97])
        %set(ax,'ytick',[0:4])
%         for i=1:4
%             yline(i-0.5,'color',[0.3,0.3,0.3])
%         end
        set(ax, 'YGrid', 'on', 'XGrid', 'on');
    end
    
    if s == 2 && q ==2
        h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
            'TickLabels',["Do Not\newlineExpand","Expand"]);
    end

    title(t,"Infrastructure Expansion Policies",'FontWeight','bold','FontSize',15)
    ylabel(t, "Time Period",'FontWeight','bold')
    xlabel(t, "Mean Precipitation [mm/mo]",'FontWeight','bold')
end

%% Plot flexible infrastructure SDP optimal expansion decisions

% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
% expansion_colors = [[200, 198, 198];[144, 170, 203];[255, 176, 133];[249, 213, 167];...
%     [254, 241, 230]]/255;

% expansion_colors = [[[87, 117, 144];[67, 170, 139];[144, 190, 109];[249, 199, 79];...
%     [248, 150, 30];[243, 114, 44];[249, 65, 68]]/255];

expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

f = figure;
t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

for s=1:2 % adapt vs non-adapt
    if s == 1 % non-adapt
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    elseif s == 2 % adapt
        X = X_adapt;
        bestAct = bestAct_adapt;
    end
    
    expansions_flex = 10:10:10*bestAct(4); % expansion options available (MCM)
    expansions_plan = 10:10:10*bestAct(9);
    
    for N=1 % for each time period
        
        %ax(N)=subplot(2,5,N+(s-1)*N);
        
        if (s==1) && (N==1) % non-adaptive
            ax(N)=nexttile();
            imagesc(s_P_abs,s_T_abs,X(:,:,2,N))
            map = [[153,204,204]/255; [153, 153, 204]/255; [255, 102, 102]/255];
            caxis([1, 3]);
            h = colorbar('TicksMode','manual','Ticks',[1.33, 2, 2.66],'TickLabels',{'Static\newlineDam', 'Flex\newlineDes\newlineDam', 'Flex\newlinePlan\newlineDam'});
            
            colormap(ax(N), map);
            set(gca,'YDir','normal')
            
            h.Label.FontSize = 5;
            ylabel('Mean T [degrees C]','FontWeight','bold')
            %xlabel('Mean P [mm/m]','FontWeight','bold')
            title({'Initial Policy';'2000-2020'},'FontWeight','bold')
            
        elseif (s==2) && (N ==1) % adaptive
            ax(N)=nexttile();
            imagesc(s_P_abs,s_T_abs,X(:,:,2,N))
            map = [[204,255,255]/255; [204, 204, 255]/255; [255, 153, 153]/255];
            caxis([1, 3]);
            h = colorbar('TicksMode','manual','Ticks',[1.33, 2, 2.66],'TickLabels',{'Static\newlineDam', 'Flex\newlineDes.\newlineDam', 'Flex\newlinePlan\newlineDam'});
            
            colormap(ax(N), map);
            set(gca,'YDir','normal')
            h.Label.FontSize = 5;
            
%             ylabel('Mean T [degrees C]','FontWeight','bold')
%             xlabel('Mean P [mm/m]','FontWeight','bold')
            title({'Initial Policy';'2000-2020'},'FontWeight','bold')
        end
        %caxis([2, 2+bestAct(4)]);
        %caxis([1,2])
        colormap(ax(N), map);
        set(gca,'YDir','normal')
        
%         ylabel('Mean T [degrees C]','FontWeight','bold')
%         xlabel('Mean P [mm/m]','FontWeight','bold')
        box on
        ylim([s_T_abs(N)-0.25,s_T_abs(N)+0.25])
        
        if s==1
            title({'Static Operations';strcat('Static (',...
                num2str(bestAct_nonadapt(2))," MCM) , Flex Design(", num2str(bestAct_nonadapt(3)),"-",...
                num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM) , Flex Plan (",...
                num2str(bestAct_nonadapt(8)),"-",...
                num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)")},'FontWeight','bold','FontSize',10);
        else
            title({'Flexible Operations';strcat('Static (',...
                num2str(bestAct_adapt(2))," MCM) , Flex Design (", num2str(bestAct_adapt(3)),"-",...
                num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM) , Flex Plan (",...
                num2str(bestAct_adapt(8)),"-",...
                num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)")},'FontWeight','bold','FontSize',10);
        end
        ylabel(t,'Mean T [degrees C]','FontWeight','bold')
        xlabel(t,'Mean P [mm/m]','FontWeight','bold')
        
        
        figure_width = 9;
        figure_height = 10;
        
        % DERIVED PROPERTIES (cannot be changed; for info only)
        screen_ppi = 72;
        screen_figure_width = round(figure_width*screen_ppi); % in pixels
        screen_figure_height = round(figure_height*screen_ppi); % in pixels
        
        % SET UP FIGURE SIZE
        set(gcf, 'Position', [50, 10, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [figure_width figure_height]);
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);
        
        
    end
end

