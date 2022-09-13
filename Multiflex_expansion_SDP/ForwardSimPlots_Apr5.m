% DESCRIPTION: break down forward sims based on if flexible design or
% flexible planning performs better, then test different summary statistics
% about precipitation state changes (e.g., mean, min, max, final P state,
% initial P state, etc.)

%% Load the Data
discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 3.5e-6 3.75e-6 6e-6]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Jan28optimal_dam_design_comb';
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
    %end
    
    % set different decade label parameters for use in plotting
    decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
    decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
    decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};
end 

%% Box and whisker plots comparing precipitaiton state statistics for 
% flexible planning vs. flexible design

facecolors = [[133,193,193]; [160,207,207];[153, 153, 204]; [180, 180, 231];...
    [255, 102, 102]; [255, 153, 153]]/255;

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

boxplot([max(P_state_adapt(Idx_bestFlex_nonadapt,:),[],2)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', 1)

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1),'Color','k');
set(whisks(1),'Color',facecolors(3,:));
set(outs(1),'MarkerEdgeColor',facecolors(3,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(3,:),'LineWidth',30);

hold on
boxplot([max(P_state_adapt(Idx_bestPlan_nonadapt,:),[],2)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', 1.5)

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1),'Color','k');
set(whisks(1),'Color',facecolors(5,:));
set(outs(1),'MarkerEdgeColor',facecolors(5,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(5,:),'LineWidth',30);

hold on
p1=plot(1,mean(max(P_state_adapt(Idx_bestFlex_nonadapt,:),[],2)), 'k.');
plot(1.5,mean(max(P_state_adapt(Idx_bestPlan_nonadapt,:),[],2)), 'k.')

xticks([1,1.5])
xticklabels({'Flexible Design', 'Flexible Planning'});
xlim([0.75,1.75])
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
boxplot([max(P_state_adapt(Idx_bestFlex_adapt,:),[],2)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', 1)

whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
set(meds(1),'Color','k');
set(whisks(1),'Color',facecolors(4,:));
set(outs(1),'MarkerEdgeColor',facecolors(4,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(4,:),'LineWidth',30);

hold on
boxplot([max(P_state_adapt(Idx_bestPlan_adapt,:),[],2)], 'Widths',0.2,'OutlierSize',5,'Symbol','.','BoxStyle','filled','positions', 1.5)
whisks = findobj(gca,'Tag','Whisker');
outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
meds = findobj(gca, 'type', 'line', 'Tag', 'Median');

set(meds(1),'Color','k');
set(whisks(1),'Color',facecolors(6,:));
set(outs(1),'MarkerEdgeColor',facecolors(6,:));
a = findobj(gca,'Tag','Box');
set(a(1),'Color',facecolors(6,:),'LineWidth',30);

hold on
p1=plot(1,mean(max(P_state_adapt(Idx_bestFlex_adapt,:),[],2)), 'k.');
plot(1.5,mean(max(P_state_adapt(Idx_bestPlan_adapt,:),[],2)), 'k.');

xticks([1,1.5])
xticklabels({'Flexible Design','Flexible Planning'});
ax=gca;
ax.XAxis.FontSize = 8;
xlabel('Time Period','FontWeight','bold')
ylim([66,97])
xlim([0.75,1.75])

%ylim([0,17])
set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
legend([p1, meds(1) a(1) a(2)],{'Mean of Maximum Precipitation State','Median of Maximum Precipitation State',...
    'Flexible Planning','Flexible Design'},'Location','northwest')

title('Flexible Operations',...
    'FontWeight','bold')
title(t, 'Box Plot of Maximum Simulated Precipitation State','Fontweight','bold')


%% Histogram of simulated mean climate states

% Actions: select associated simulations

% map actions to dam capacity of time (fill actions with value 0)
% == FLEXIBLE DESIGN ==
actionPnowFlex_adapt = action_adapt(:,:,1);
for r = 1:size(actionPnowFlex_adapt,1) % each forward simulation
    for ia = 2:size(actionPnowFlex_adapt,2) % each subsequent time period
        if actionPnowFlex_adapt(r,ia) == 0
            actionPnowFlex_adapt(r,ia) = actionPnowFlex_adapt(r,ia-1);
        end
    end
end

actionPnowFlex_nonadapt = action_nonadapt(:,:,1);
for r = 1:size(actionPnowFlex_nonadapt,1)
    for ia = 2:size(actionPnowFlex_nonadapt,2)
        if actionPnowFlex_nonadapt(r,ia) == 0
            actionPnowFlex_nonadapt(r,ia) = actionPnowFlex_nonadapt(r,ia-1);
        end
    end
end

% == FLEXIBLE PLANNING ==
actionPnowPlan_adapt = action_adapt(:,:,3);
for r = 1:size(actionPnowPlan_adapt,1)
    for ia = 2:size(actionPnowPlan_adapt,2)
        if actionPnowPlan_adapt(r,ia) == 0
            actionPnowPlan_adapt(r,ia) = actionPnowPlan_adapt(r,ia-1);
        end
    end
end

actionPnowPlan_nonadapt = action_nonadapt(:,:,3);
for r = 1:size(actionPnowPlan_nonadapt,1)
    for ia = 2:size(actionPnowPlan_nonadapt,2)
        if actionPnowPlan_nonadapt(r,ia) == 0
            actionPnowPlan_nonadapt(r,ia) = actionPnowPlan_nonadapt(r,ia-1);
        end
    end
end

% == STATIC DAM ==
actionPnowStatic_adapt = action_adapt(:,:,2);
for r = 1:size(actionPnowStatic_adapt,1) % each forward simulation
    for ia = 2:size(actionPnowStatic_adapt,2) % each subsequent time period
        if actionPnowStatic_adapt(r,ia) == 0
            actionPnowStatic_adapt(r,ia) = actionPnowStatic_adapt(r,ia-1);
        end
    end
end

actionPnowStatic_nonadapt = action_nonadapt(:,:,2);
for r = 1:size(actionPnowStatic_nonadapt,1)
    for ia = 2:size(actionPnowStatic_nonadapt,2)
        if actionPnowStatic_nonadapt(r,ia) == 0
            actionPnowStatic_nonadapt(r,ia) = actionPnowStatic_nonadapt(r,ia-1);
        end
    end
end

% Indices Unexpand:
IdxUnexpStatic_nonadapt = actionPnowStatic_nonadapt(:,1) == actionPnowStatic_nonadapt(:,5);
IdxUnexpStatic_adapt = actionPnowStatic_adapt(:,1) == actionPnowStatic_adapt(:,5);
IdxUnexpFlex_nonadapt = actionPnowFlex_nonadapt(:,1) == actionPnowFlex_nonadapt(:,5);
IdxUnexpFlex_adapt = actionPnowFlex_adapt(:,1) == actionPnowFlex_adapt(:,5);
IdxUnexpPlan_nonadapt = actionPnowPlan_nonadapt(:,1) == actionPnowPlan_nonadapt(:,5);
IdxUnexpPlan_adapt = actionPnowPlan_adapt(:,1) == actionPnowPlan_adapt(:,5);


% for each flexible dam type, count number of observations that
% don't expand for each final climate state
figure()
t = tiledlayout(2,2);
t.Padding = 'compact';
t.TileSpacing = 'none';
nexttile
h1 = histogram(mean(P_state_adapt,2),'BinEdges',[66:1:97],'FaceColor',facecolors(3,:),'FaceAlpha',1);

hold on
finalP = mean(P_state_adapt(IdxUnexpFlex_nonadapt,:),2);
h2 = histogram(finalP,'BinEdges',[66:1:97],'FaceColor',[210,210,210]/255,'FaceAlpha',1);
legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
grid on
%xlim([65,77])
xlim([65,98])
xlabel('Mean Precip. State (mm/mo)','FontWeight','bold')
ylabel('Frequency','FontWeight','bold')
title('Flexible Design & Static Ops')
nexttile
h1 = histogram(mean(P_state_adapt,2),'BinEdges',[66:1:97],'FaceColor',facecolors(4,:),'FaceAlpha',1);
hold on
finalP = mean(P_state_adapt(IdxUnexpFlex_adapt,:),2);
h2 = histogram(finalP,'BinEdges',[66:1:97],'FaceColor',[210,210,210]/255,'FaceAlpha',1);
legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
grid on
%xlim([65,77])
xlim([65,98])
xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
ylabel('Frequency','FontWeight','bold')
title('Flexible Design & Flexible Ops')
nexttile
h1 = histogram(mean(P_state_adapt,2),'BinEdges',[66:1:97],'FaceColor',facecolors(5,:),'FaceAlpha',1);
hold on
finalP = mean(P_state_adapt(IdxUnexpPlan_nonadapt,:),2);
h2 = histogram(finalP,'BinEdges',[66:1:97],'FaceColor',[210,210,210]/255,'FaceAlpha',1);
%xlim([65,77])
xlim([65,98])
legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
grid on
xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
ylabel('Frequency','FontWeight','bold')
title('Flexible Planning & Static Ops')
nexttile
h1 = histogram(mean(P_state_adapt,2),'BinEdges',[66:1:97],'FaceColor',facecolors(6,:),'FaceAlpha',1);
hold on
finalP = mean(P_state_adapt(IdxUnexpPlan_adapt,:),2);
h2 = histogram(finalP,'BinEdges',[66:1:97],'FaceColor',[210,210,210]/255,'FaceAlpha',1);
legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
grid on
xlim([65,98])
xlabel('Mean Precip. State (mm/mo)','FontWeight','bold')
ylabel('Frequency','FontWeight','bold')
title('Flexible Planning & Flexible Ops')
title(t,'Frequency of Unexpanded Flexible Alternatives by Mean Precip. State', 'FontWeight','bold')
subtitle(t,'Counts of Mean Climate State Given Flexible Alternative is Never Expanded')


%% Histogram of Mean P vs. best Alternative (minimum total cost)

% barcolors
facecolors = [[255, 102, 102]; [255, 153, 153]; [153, 153, 204]; [180, 180, 231];[133,193,193]; [160,207,207];[255, 102, 106]]/255;
%[133,193,193]; [160,207,207]

% Total Cost: nonadapt flex, adapt flex, nonadapt plan, adapt plan,...
% nonadapt static, adapt static,
TotalCost_combined = [sum(totalCostTime_nonadapt(:,:,3),2), sum(totalCostTime_adapt(:,:,3),2),...
    sum(totalCostTime_nonadapt(:,:,1),2), sum(totalCostTime_adapt(:,:,1),2),...
    sum(totalCostTime_nonadapt(:,:,2),2), sum(totalCostTime_adapt(:,:,2),2)]/1E6;
    
Action_combined = [sum(action_nonadapt(:,2:5,3),2), sum(action_adapt(:,2:5,3),2),...
    sum(action_nonadapt(:,2:5,1),2), sum(action_adapt(:,2:5,1),2),...
    sum(action_nonadapt(:,2:5,2),2), sum(action_adapt(:,2:5,2),2)];

% index the alternative that minimizes the total cost
[M, IdxAlt] = min(TotalCost_combined, [], 2);
IdxAlt = TotalCost_combined == M;
%IdxAlt((Action_combined(:,2) == 0) & (IdxAlt(:,2) == 1), 2) = 0;
IdxAlt(((IdxAlt(:,2) == 1) & (IdxAlt(:,6) == 1)), 7) = 1;
IdxAlt(((IdxAlt(:,2) == 1) & (IdxAlt(:,6) == 1)), 1:6) = 0;
A = repmat(1:7,10000,1);
Idx = NaN(10000,1);
for i=1:10000
    Idx(i) = A(i,IdxAlt(i,:));
% [~,IdxAlt] = find(IdxAlt == 1);
end

[counts,edges,binned] = histcounts(mean(P_state_adapt,2),'BinEdges',[66:1:97]);

count = NaN(length(counts),7);
for i=1:length(counts)
    for j=1:7
        %count(i,j) = sum(IdxAlt(binned == i)==j);
        count(i,j) = sum(Idx(binned == i)==j);
    end
end
% 
figure()
b = bar(67:97, count,'stacked','FaceColor','flat');
for i=1:7
    b(i).CData = facecolors(i,:);
    %b = histogram(edges(1:end-1),count,'stacked');
end
xlabel('Mean Precipitation Bin (mm/mo)','FontWeight','bold')
ylabel('Frequency','FontWeight','bold')
title('Frequency of Simulated Best Infrastructure Alternative vs. Mean P State','FontWeight','bold')
legend([b(1:6)],{'Flexible Planning & Static Ops','Flexible Planning & Flexible Ops',...
    'Flexible Design & Static Ops','Flexible Design & Flexible Ops',...
    'Static Design & Static Ops','Static Design & Flexible Ops'})

im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
         makehatch_plus('\',1), makehatch_plus('\',1),makehatch_plus('\',1),...
        makehatch_plus('\',1),makehatch_plus('\\40',50)},...
        [facecolors(1:7,:)],[],300);
    

% figure()
% for i=7:-1:1
%     b(i) = histogram('BinEdges',edges,'BinCounts',sum([count(:,1:i)],2),'FaceColor',facecolors(i,:),'FaceAlpha',1);
%     hold on
%     %b = histogram(edges(1:end-1),count,'stacked');
% end
%b(1) = histogram('BinEdges',edges,'BinCounts',count(:,1),'FaceColor',facecolors(1,:),'FaceAlpha',1);


%% Scatter plot of total costs vs. mean precipitation states for alternatives


facecolors = [[153,204,204]; [187,221,221]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

meanP = mean(P_state_adapt,2);
%meanP = P_state_adapt(:,5);

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

totalCosts = NaN(10000,6);
damCosts = NaN(10000,6);
expCosts = NaN(10000,6);
shortageCosts = NaN(10000,6);

totalCosts(:,[3,1,5]) = squeeze(sum(totalCost_nonadapt,2));
totalCosts(:,[4,2,6]) = squeeze(sum(totalCost_adapt,2));
damCosts(:,[3,1,5]) = squeeze(damCost_nonadapt(:,1,:));
damCosts(:,[4,2,6]) = squeeze(damCost_adapt(:,1,:));
expCosts(:,[3,1,5]) = squeeze(sum(damCost_nonadapt(:,2:5,:),2));
expCosts(:,[4,2,6]) = squeeze(sum(damCost_adapt(:,2:5,:),2));
shortageCosts(:,[3,1,5]) = totalCosts(:,[3,1,5]) - damCosts(:,[3,1,5]);
shortageCosts(:,[4,2,6]) = totalCosts(:,[4,2,6]) - damCosts(:,[4,2,6]);

% scatter of total costs
figure()
t = tiledlayout(3,4,'TileSpacing','compact');
title(t,"Simulated Costs vs. Mean Precipiation State",'FontWeight','bold')
for j=1:4
    if j==1
        nexttile([3 2])
        for i=1:6
            %order = [1 2 5 6 3 4];
            %i = order(k); 
            if ismember(i,[2,4,6])==0
                scatter(meanP,totalCosts(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(meanP,totalCosts(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        legend({'Static Design & Static Ops','Static Design & Flexible Ops',...
            'Flexible Design & Static Ops','Flexible Design & Flexible Ops',...
            'Flexible Planning & Static Ops','Flexible Planning & Flexible Ops'})
        ylabel('Simulated Cost (M$)','FontWeight','bold')
        xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Total Cost vs. Mean Precipitation State')
        %ylim([0,900])
    elseif j==2 % dam costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(meanP,damCosts(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(meanP,damCosts(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Initial Dam Cost (M$)','FontWeight','bold')
        %xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Initial Dam Cost vs. Mean Precipitation State')
    elseif j==3 % expansion costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(meanP,expCosts(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(meanP,expCosts(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Dam Expansion Cost (M$)','FontWeight','bold')
        %xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Dam Expansion Cost vs. Mean Precipitation State')
        
    elseif j==4 % shortage costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(meanP,shortageCosts(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(meanP,shortageCosts(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Shortage Cost (M$)','FontWeight','bold')
        xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Shortage Cost vs. Mean Precipitation State')
    end
box on
grid('minor')
grid on
end

%% Scatter plot of *mean* total costs vs. mean precipitation states for alternatives

meanP = mean(P_state_adapt,2);

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

totalCosts = NaN(10000,6);
damCosts = NaN(10000,6);
expCosts = NaN(10000,6);
shortageCosts = NaN(10000,6);

totalCosts(:,[3,1,5]) = squeeze(sum(totalCost_nonadapt,2));
totalCosts(:,[4,2,6]) = squeeze(sum(totalCost_adapt,2));
damCosts(:,[3,1,5]) = squeeze(damCost_nonadapt(:,1,:));
damCosts(:,[4,2,6]) = squeeze(damCost_adapt(:,1,:));
expCosts(:,[3,1,5]) = squeeze(sum(damCost_nonadapt(:,2:5,:),2));
expCosts(:,[4,2,6]) = squeeze(sum(damCost_adapt(:,2:5,:),2));
shortageCosts(:,[3,1,5]) = totalCosts(:,[3,1,5]) - damCosts(:,[3,1,5]);
shortageCosts(:,[4,2,6]) = totalCosts(:,[4,2,6]) - damCosts(:,[4,2,6]);

unqMeanP = unique(meanP);
totalCosts_mean = NaN(length(unqMeanP),6);
damCosts_mean = NaN(length(unqMeanP),6);
expCosts_mean = NaN(length(unqMeanP),6);
shortageCosts_mean = NaN(length(unqMeanP),6);

for i = 1:length(unqMeanP)
    indP = (meanP == unqMeanP(i));
    totalCosts_mean(i,:) = mean(totalCosts(indP,:));
    damCosts_mean(i,:) = mean(damCosts(indP,:));
    expCosts_mean(i,:) = mean(expCosts(indP,:));
    shortageCosts_mean(i,:) = mean(shortageCosts(indP,:));
end

% scatter of total costs
figure()
t = tiledlayout(3,4,'TileSpacing','compact');
title(t,"Simulated Costs vs. Mean Precipiation State",'FontWeight','bold')
for j=1:4
    if j==1
        nexttile([3 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(unqMeanP,totalCosts_mean(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(unqMeanP,totalCosts_mean(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        legend({'Flexible Planning & Static Ops','Flexible Planning & Flexible Ops',...
            'Flexible Design & Static Ops','Flexible Design & Flexible Ops',...
            'Static Design & Static Ops','Static Design & Flexible Ops'})
        ylabel('Simulated Cost (M$)','FontWeight','bold')
        xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Total Cost vs. Mean Precipitation State')
        ylim([0,900])
    elseif j==2 % dam costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(unqMeanP,damCosts_mean(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(unqMeanP,damCosts_mean(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Initial Dam Cost (M$)','FontWeight','bold')
        %xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Initial Dam Cost vs. Mean Precipitation State')
    elseif j==3 % expansion costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(unqMeanP,expCosts_mean(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(unqMeanP,expCosts_mean(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Dam Expansion Cost (M$)','FontWeight','bold')
        %xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Dam Expansion Cost vs. Mean Precipitation State')
        
    elseif j==4 % shortage costs
        nexttile([1 2])
        for i=1:6
            if ismember(i,[2,4,6])==0
                scatter(unqMeanP,shortageCosts_mean(:,i),15,'filled','MarkerFaceColor',facecolors(i,:),'MarkerFaceAlpha',1);
            else
                scatter(unqMeanP,shortageCosts_mean(:,i),15,'filled','MarkerEdgeColor',facecolors(i,:),'Marker','*','MarkerEdgeAlpha',1);
            end
            hold on
        end
        %ylabel('Shortage Cost (M$)','FontWeight','bold')
        xlabel('Mean Precipitation State (mm/mo)','FontWeight','bold')
        title('Simulated Shortage Cost vs. Mean Precipitation State')
    end
box on
grid('minor')
grid on
end

%% Repartitioning total cost stacked bar plots from before with mean precipitation

% dry region: 66-73 mm/mo
% transitional region: 74-77 mm/mo
% wet region: 78-97 mm/mo

f=figure();
    t = tiledlayout(3,1);
    P_ranges = {[66 73];[73 77];[77 97]}; % reference mean climates
    %P_ranges = {[72];[79];[87]};
    %P_ranges = {[66:1:72];[73:1:86];[87:97]};
    
     s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    
    for p = 1:length(P_ranges)
        % re-initialize mean cost arrays:
        totalCost_P = NaN(6,1);
        damCost_P = NaN(6,1);
        expCost_P = NaN(6,1);
        shortageCost_P = NaN(6,1);
        
        % calculate the average shortage, dam, and expansion costs for each
        % climate state:
        %ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        P_rangeNow = P_ranges{p};
        if p == 1
            ind_P = ((mean(P_state_adapt,2)<=P_rangeNow(2))&(mean(P_state_adapt,2)>=P_rangeNow(1)));
        else
            ind_P = ((mean(P_state_adapt,2)<=P_rangeNow(2))&(mean(P_state_adapt,2)>P_rangeNow(1)+eps));
        end
        
        % find climate subset from data for adaptive and non-adaptive
        % operations
        totalCost_P([3,1,5]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
        damCost_P([3,1,5]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
        expCost_P([3,1,5]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
        shortageCost_P([3,1,5]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));    
        
        totalCost_P([4,2,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
        damCost_P([4,2,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
        expCost_P([4,2,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
        shortageCost_P([4,2,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));    

        costs = [damCost_P, expCost_P, shortageCost_P];
        
        % bar plot of average costs from simulations:
        %subplot(3,1,p)
        nexttile
        c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
        b = bar(costs,'stacked','FaceColor',"flat");
        if p == 1
        title({strcat("Discount Rate: ", disc,'%');strcat("Dry Climate (", string(P_ranges{p}(1)),'-',string(P_ranges{p}(end))," mm/mo)")},'FontSize',13)
        set(gca, 'XTick',[],'FontSize',10)
        else
            title({"";strcat("Wet Climate (", string(P_ranges{p}(1)),'-',string(P_ranges{p}(end))," mm/mo)")},'FontSize',13)
            if p==2
                title({"";strcat("Moderate Climate (", string(P_ranges{p}(1)),'-',string(P_ranges{p}(end))," mm/mo)")},'FontSize',13)
            end
            set(gca, 'XTick',[],'FontSize',10)         
        end
        grid('on')

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
        end
        
        ax = gca;
        ax.LineWidth = 1.5;

        ylabel('Mean Simulated Cost (M$)','FontWeight','bold','FontSize',12)
        xlim([0.5,6.5])
        
          % add lables with intial dam cost (not discounted)
         xtips = [1 2 3 4 5 6];
 
         % total cost labels
         ytips = sum(costs,2);
         labels = strcat('$',string(round(ytips,1)),"M");
         text(xtips,ytips,labels,'HorizontalAlignment','center',...
             'VerticalAlignment','bottom','FontSize',10,'FontWeight','bold')
 
         % dam cost labels
         ytips = 0.5* costs(:,1);
         labels = strcat('$',string(round(costs(:,1),1)),"M");
         text(xtips,ytips,labels,'HorizontalAlignment','center',...
             'VerticalAlignment','middle','FontSize',9)
         
%         % dam expansion cost labels
%         ytips = costs(3:end,1)+ 0.5* costs(3:end,2);
%         labels = strcat('$',string(round(costs(3:end,2),1)),"M");
%         text(xtips(3:end),ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','top','FontSize',9)
% 
%         % shortage cost labels
%         ytips = costs(:,1)+costs(:,2)+costs(:,3)*0.5;
%         labels = strcat('$',string(round(costs(:,3),1)),"M");
%         text(xtips,ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','FontSize',9)
        
        yl = ylim;
        ylim([0, yl(2)+0.2*yl(2)])

        if p == 3
        legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')

        set(gca, 'XTick', [1 2 3 4 5 6])

        set(gca,'XTickLabel',{strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.')});        
        end
        set(gca, 'YMinorGrid','on')
    end
    
    %sgtitle(strcat("Discount Rate: ", disc, "%"), 'FontSize',22)
    t.Padding = 'compact';
    t.TileSpacing = 'none';
    %font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    %set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    figure_width = 8;
    figure_height = 10;
    
    % DERIVED PROPERTIES (cannot be changed; for info only)
    screen_ppi = 72;
    screen_figure_width = round(figure_width*screen_ppi); % in pixels
    screen_figure_height = round(figure_height*screen_ppi); % in pixels
    
    % SET UP FIGURE SIZE
    set(gcf, 'Position', [100, 0, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [figure_width figure_height]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

    %end

