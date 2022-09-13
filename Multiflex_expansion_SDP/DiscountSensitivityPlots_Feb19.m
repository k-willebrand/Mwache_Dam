%% DiscountSensitivityPlots_Feb19.m

%% Description (Feb 19, 2022):
% This script performs data analysis and creates plots for testing the
% sensitivity of the Mwache Dam project to the discount rate, considering
% different c' parameter values in the shortage cost economic model.

% As of Feb 2, 2022: c' values of interest are c' = 1.25e-6 and c'=5e-6. We
% test the followingdiscount rates: 0%, 3%, and 6% under these two
% different c' parameter values.

% *As of Feb 19, 2022:* we consider each climate (dry, moderate, and wet) as
% a range of climates rather than individual climate states (i.e.,
% previously 72, 79, and 87 mm/mo). Now use the following P ranges: dry is [66:1:76],
% moderate is [77:1:86], and wet is [87:97]

%% Setup and Loading Data

% specify file naming convensions
discounts = [0, 3, 6, 5];
cprimes = [2e-7 2.85e-7 1.25e-6 1E-7 2.85E-7 7E-7 1.8E-6 7.5E-7 3.5e-6 3.75e-6 6e-6 1.72 2.45]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Jan28optimal_dam_design_comb';
    %folder = 'May25optimal_dam_design_comb';
    %folder = 'Jun09optimal_dam_design_comb';
    %folder = 'Jun10optimal_dam_design_comb';
else
    folder = 'Feb7optimal_dam_design_comb';
end
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1%length(discounts)
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

   %% plot the expansion cost models for these different alternative
   % (annotate them)
   facecolors = [[153,204,204]; [191,223,223]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    figure()
    infracost = infra_cost_nonadaptive.flex(2,:) + infra_cost_nonadaptive.flex(2,1);
    infracost(1) = infracost(1) - infra_cost_nonadaptive.flex(2,1);
    plot(infra_cost_nonadaptive.flex(1,:),infracost,'-o','LineWidth',2,...
         'MarkerFaceColor',facecolors(3,:),'Color',facecolors(3,:),'MarkerSize',5,...
         'DisplayName','Flexible Design & Static Ops');
    hold on
    infracost = infra_cost_adaptive.flex(2,:) + infra_cost_adaptive.flex(2,1);
    infracost(1) = infracost(1) - infra_cost_adaptive.flex(2,1);    
    plot(infra_cost_adaptive.flex(1,:),infracost,'--','Marker','*','LineWidth',2,...
        'MarkerFaceColor',facecolors(4,:),'Color',facecolors(4,:),'MarkerSize',5,...
        'DisplayName','Flexible Design & Flexible Ops');   
    hold on
    infracost = infra_cost_nonadaptive.plan(2,:) + infra_cost_nonadaptive.plan(2,1);
    infracost(1) = infracost(1) - infra_cost_nonadaptive.plan(2,1);    
    plot(infra_cost_nonadaptive.plan(1,:),infracost,'-o','LineWidth',2,...
        'MarkerFaceColor',facecolors(5,:),'Color',facecolors(5,:),'MarkerSize',5,...
        'DisplayName','Flexible Planning & Static Ops');
    hold on
    infracost = infra_cost_adaptive.plan(2,:) + infra_cost_adaptive.plan(2,1);
    infracost(1) = infracost(1) - infra_cost_adaptive.plan(2,1);    
    plot(infra_cost_adaptive.plan(1,:),infracost,'--','Marker','*','LineWidth',2,...
        'MarkerFaceColor',facecolors(6,:),'Color',facecolors(6,:),'MarkerSize',5,...
        'DisplayName','Flexible Planning & Flexible Ops');
    hold on
        infracost = infra_cost_nonadaptive.static(2,:) + infra_cost_nonadaptive.static(2,1);
    infracost(1) = infracost(1) - infra_cost_nonadaptive.static(2,1);
    plot(infra_cost_nonadaptive.static(1,:),infracost,'-o',...
        'MarkerFaceColor',facecolors(1,:),'Color',facecolors(1,:),'LineWidth',2,...
        'MarkerSize',7,'DisplayName', 'Static Design & Static Ops');
    hold on
    infracost = infra_cost_adaptive.static(2,:) + infra_cost_adaptive.static(2,1);
    infracost(1) = infracost(1) - infra_cost_adaptive.static(2,1);
    p=plot(infra_cost_adaptive.static(1,:),infracost,'--*',...
        'MarkerFaceColor',facecolors(2,:),'Color',facecolors(2,:),'LineWidth',2,...
        'DisplayName','Static Design & Flexible Ops','MarkerSize',5)
    p.Marker = '*';
    xlabel('Installed Dam Capacity (MCM)','FontWeight','bold')
    ylabel('Installed Infrastructure Cost (M$)','FontWeight','bold')
    legend('location','northwest')
    grid 'minor'
    grid 'on'
    xlim([105,155])
    title('Installed Infrastructure Cost vs. Installed Dam Capacity',...
        'FontWeight','bold','FontSize',13)
    
    %% Bar plot: Optimal Dam Design Capacities
    
    facecolors = [[90, 90, 90]; [153,204,204]; [191,223,223]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    facecolors_exp = [[90, 90, 89]; [153,204,203]; [191,223,223]; [153, 153, 203]; [204, 204, 254];...
        [255, 102, 101]; [255, 153, 152]]/255;
    
    capacities = [[0 bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3) bestAct_adapt(3) ...
        bestAct_nonadapt(8) bestAct_adapt(8)];[0 0 0 bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
        bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
        bestAct_adapt(9)*bestAct_adapt(10)]]';
    
    f = figure;
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
    title(strcat("Discount Rate: ", disc, "%"), 'FontSize',22)
    
    % add lables with intial dam cost (not discounted)
    xtips = [1 2 3 4 5 6]+1;
    ytips = [bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
        bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
        bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)];
    
    if discountCost
        % use discounted cost labels:
        labels = {strcat('$',string(round(damCostTime_nonadapt(1,1,2)/1E6,1)),'M'),...
            strcat('$',string(round(damCostTime_adapt(1,1,2)/1E6,1)),'M'),...
            strcat('$',string(round(damCostTime_nonadapt(1,1,1)/1E6,1)),'M'),...
            strcat('$',string(round(damCostTime_adapt(1,1,1)/1E6,1)),'M'),...
            strcat('$',string(round(damCostTime_nonadapt(1,1,3)/1E6,1)),'M'),...
            strcat('$',string(round(damCostTime_adapt(1,1,3)/1E6,1)),'M')};
    else
        % use non-discounted cost labels:
        labels = { strcat('$',string(round((Vd_static_nonadapt(1,12,1,1)+Vs_static_nonadapt(1,12,1,1))/1E6,1)),'M'),...
             strcat('$',string(round((Vd_static_adapt(1,12,1,1)+Vs_static_adapt(1,12,1,1))/1E6,1)),'M'),...
             strcat('$',string(round((Vd_flex_nonadapt(1,12,1,1)+Vs_flex_nonadapt(1,12,1,1))/1E6,1)),'M'),...
             strcat('$',string(round((Vd_flex_adapt(1,12,1,1)+Vs_flex_adapt(1,12,1,1))/1E6,1)),'M'),...
             strcat('$',string(round((Vd_plan_nonadapt(1,12,1,1)+Vs_plan_nonadapt(1,12,1,1))/1E6,1)),'M'),...
            strcat('$',string(round((Vd_plan_adapt(1,12,1,1)+Vs_plan_adapt(1,12,1,1))/1E6,1)),'M')};
%                 labels = {strcat('$',string(round(infra_cost_nonadaptive.static(2))),'M'),...
%             strcat('$',string(round(infra_cost_adaptive.static(2))),'M'),...
%             strcat('$',string(round(infra_cost_nonadaptive.flex(2))),'M'),...
%             strcat('$',string(round(infra_cost_adaptive.flex(2))),'M'),...
%             strcat('$',string(round(infra_cost_nonadaptive.plan(2))),'M'),...
%             strcat('$',string(round(infra_cost_adaptive.plan(2))),'M')};
    end
    
    text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom','FontSize',18)
    
    font_size = 26;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    grid('on')
    
    figure_width = 25;
    figure_height = 5;
    
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
    
    im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
        makehatch_plus('\\40',50), makehatch_plus('\',1), makehatch_plus('\\40',50), ...
        makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1),...
        makehatch_plus('\\40',50),makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1)},...
        [facecolors(2:4,:); facecolors_exp(4,:); facecolors(5,:); facecolors_exp(5,:); facecolors(6,:); facecolors_exp(6,:);...
        facecolors(7,:); facecolors_exp(7,:);facecolors(1,:); facecolors_exp(1,:)],[],300);
    
    %% SDP Best Value by Infrastructure and Dam Cost (Vd and Vs)
    % use the expected costs from 77 mm/mo for expected costs
        
    expInfra = zeros(2,3);
    expShort = zeros(2,3);
    expDam = zeros(2,3);
    expExpand = zeros(2,3);
    for s=1:2 % for non-adaptive and adaptive operations
        if s==1 % nonadaptive
            %if discountCost == 1 % if using discounted costs, use Vd and Vs
                expInfra(s,:) = [Vd_static_nonadapt(1, 12, 1, 1); Vd_flex_nonadapt(1, 12, 1, 1); Vd_plan_nonadapt(1, 12, 1, 1)];
                expDam(s,:) = infra_cost_nonadaptive_lookup(2:4);
                expExpand(s,:) = expInfra(s,:)-expDam(s,:);
                expShort(s,:) = [Vs_static_nonadapt(1, 12, 1, 1); Vs_flex_nonadapt(1, 12, 1, 1); Vs_plan_nonadapt(1, 12, 1, 1)];
           % end
        else
           % if discountCost == 1 % if using discounted costs, use Vd and Vs
                expInfra(s,:) = [Vd_static_adapt(1, 12, 1, 1); Vd_flex_adapt(1, 12, 1, 1); Vd_plan_adapt(1, 12, 1, 1)];
                expDam(s,:) = infra_cost_adaptive_lookup(2:4);
                expExpand(s,:) = expInfra(s,:)-expDam(s,:);
                expShort(s,:) = [Vs_static_adapt(1, 12, 1, 1); Vs_flex_adapt(1, 12, 1, 1); Vs_plan_adapt(1, 12, 1, 1)];
           % end     
        end
    end
    
    % create bar plot of expected dam and shortage costs:
    f=figure();
    costs = [reshape(expDam,[],1),reshape(expExpand,[],1),reshape(expShort,[],1)]/1E6;
    c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
    b = bar(costs,'stacked','FaceColor',"flat");
    legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')
    for k = 1:size(b,2)
        b(k).CData = c(k,:);
    end
    
    set(gca, 'XTick', [1 2 3 4 5 6])
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
    
    ylabel('Expected Cost (M$)','FontWeight','bold','FontSize',20)
    xlim([0.5,6.5])
    title(strcat("Discount Rate: ", disc, "%"), 'FontSize',22)
    
     % add lables with intial dam cost (not discounted)
    xtips = [1 2 3 4 5 6];
    
    % total cost labels
    ytips = sum(costs,2);
    labels = strcat('$',string(round(ytips,1)),"M");
    text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom','FontSize',15,'FontWeight','bold')
    
    % dam cost labels
    ytips = 0.5* costs(:,1);
    labels = strcat('$',string(round(costs(:,1),1)),"M");
    text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','middle','FontSize',12)
    
    % dam expansion cost labels
    ytips = costs(3:end,1)+ 0.5* costs(3:end,2);
    labels = strcat('$',string(round(costs(3:end,2),1)),"M");
    text(xtips(3:end),ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','top','FontSize',12)
    
    % shortage cost labels
    ytips = costs(:,1)+costs(:,2)+costs(:,3)*0.5;
    labels = strcat('$',string(round(costs(:,3),1)),"M");
    text(xtips,ytips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','middle','FontSize',12)
    
    font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    %set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    grid('on')
    
    figure_width = 25;
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
    
     %% Mean simulated dam and shortage cost breakdown (stacked bar)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    f=figure();
    t = tiledlayout(1,1);
    P_ranges = {[66:97]}; % reference dry, moderate, and wet climates
    
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
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
        title({strcat("Discount Rate: ", disc,'%');strcat("Mean Simulated Total Cost by 2100 (", string(P_ranges{p}(1)),"-",string(P_ranges{p}(end))," mm/mo)")},'FontSize',13)
        set(gca, 'XTick',[],'FontSize',10)
        
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
%        text(xtips(3:end),ytips,labels,'HorizontalAlignment','center',...
%            'VerticalAlignment','top','FontSize',9)
% 
%         % shortage cost labels
%         ytips = costs(:,1)+costs(:,2)+costs(:,3)*0.5;
%         labels = strcat('$',string(round(costs(:,3),1)),"M");
%         text(xtips,ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','FontSize',9)
        
        yl = ylim;
        ylim([0, yl(2)+0.2*yl(2)])

        legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')

        set(gca, 'XTick', [1 2 3 4 5 6])

        set(gca,'XTickLabel',{strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.')});        
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
    
    
    %% Mean simulated dam and shortage cost breakdown (stacked bar)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    f=figure();
    t = tiledlayout(1,1);
     P_ranges = {[66:97]}; % reference dry, moderate, and wet climates
    
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
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
        title({strcat("Discount Rate: ", disc,'%');strcat("Mean Simulated Total Cost by 2100 (", string(P_ranges{p}(1)),"-",string(P_ranges{p}(end))," mm/mo)")},'FontSize',13)
        set(gca, 'XTick',[],'FontSize',10)
        
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
%        text(xtips(3:end),ytips,labels,'HorizontalAlignment','center',...
%            'VerticalAlignment','top','FontSize',9)
% 
%         % shortage cost labels
%         ytips = costs(:,1)+costs(:,2)+costs(:,3)*0.5;
%         labels = strcat('$',string(round(costs(:,3),1)),"M");
%         text(xtips,ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','FontSize',9)
        
        yl = ylim;
        ylim([0, yl(2)+0.2*yl(2)])

        legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')

        set(gca, 'XTick', [1 2 3 4 5 6])

        set(gca,'XTickLabel',{strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flexible Ops.')});        
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
    %% Extent of Volume Expansion by End of Planning Period
    % (Highlights from Jenny's Plots using same blue colors)
    
    f = figure;
    
    % use consistent stacked color bar convention based on volume expanded
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
        
        % Plot final expansions for flexible alternatives:
        s_C_bins = s_C - 0.01;
        s_C_bins(end+1) = s_C(end)+0.01;
        
        clear cPnowCounts cPnowCounts_test
        
        for type = 1:2 % flexible design and flexible planning
            if type == 1
                t = 1; % index of flexible design
            else
                t= 3; % index for flexible planning
            end
            
            for k=1:5
                cPnowCounts(k,:) = histcounts(action(:,k,t), s_C_bins);
                cPnowCounts_test(k,:) = histcounts(action(:,k,t), s_C_bins);
            end
            
            for j=2:5
                cPnowCounts(j,1) = cPnowCounts(1,1); % static
                cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4))); % flexible design (unexp)
                cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end)); % flexible planning (unexp)
                cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
            end
            cPnowCounts = cPnowCounts./10000.*100; % convert counts to percent of simulations
            
            colormap(cmap);
            %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
            b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat',...
                'LineWidth',1); % expansion by the final time period
            for i=1:length(b1) % recolor
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
        
        % create legend labels based on either flex design  or flex
        % planning (whichever has more expansion options)
        if s == 1 % non-adaptive
            if bestAct(4)>bestAct(9) % use labels from flex design
                for z = 1:bestAct(4)
                    labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5))," MCM")};
                end
                h=get(gca,'Children');
                capState = ["Unexpanded{   }", labels{:}];
                l = legend([b1([1 4:3+bestAct(4)])],capState,'Orientation','horizontal',...
                    'Location','southoutside','FontSize',10,'AutoUpdate','off');
            else
                for z = 1:bestAct(9) % use labels from flex planning
                    labels(z) = {strcat("+", num2str(z*bestAct(10))," MCM{   }")};
                end
                h=get(gca,'Children');
                capState = ["Unexpanded{   }", labels{:}];
                l = legend([b1([1 4+bestAct(4):end])],capState,'Orientation','horizontal',...
                    'Location','southoutside','FontSize',10,'AutoUpdate','off');
            end
        end
        l.ItemTokenSize(1) = 60;
        l.Position = l.Position + [-0.15 -0.15 0 0.05];
        box on
        
        ax = gca;
        ax.LineWidth = 1.5;
        ax.XGrid = 'off';
        ax.YGrid = 'on';
        box on
        allaxes = findall(f, 'type', 'axes');
        title({strcat("Discount Rate: ", string(discounts(d)),"%")},'FontSize',25)
        
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
    end
    
    %%  Total Capacity by End of Planning Period
    
    f = figure;
    t = tiledlayout(1,1);
    
    % colormap of volume 50-150 MCM:
    total_colors = [[0,0,0];[241, 251, 255];[239, 247, 255];[198, 219, 233];[160, 196, 216];[111, 162, 191];[69, 131, 189];[36, 105, 171];[0, 70, 135];[9, 56, 100];[0, 33, 61];[0, 14, 25]]/255;
    caps = 40:10:150; % lookup vector for total colors
    
    % use consistent stacked color bar convention based on volume expanded
    nonadapt_plan_colors = [[0,0,0];[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    nonadapt_flex_colors = [[0,0,0];[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    adapt_plan_colors = [[0,0,0];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    adapt_flex_colors = [[0,0,0];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    
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
        % range of total capacity installed for adaptive and non-adaptive
        minCap = min([bestAct_nonadapt(3), bestAct_nonadapt(8), ...
            bestAct_adapt(3), bestAct_adapt(8)]);
        maxCap = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5), ...
            bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10),...
            bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),...
            bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)]);
        maxPlan = max([bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10),...
            bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)]);
        maxFlex = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5), ...
            bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)]);
        
        clear cmap1
        if s == 1 % nonadaptive
            %cmap1 = [[150, 150, 150]; [150, 150, 150]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
            cmap1 = [total_colors(caps==bestAct_nonadapt(3),:); total_colors(caps==bestAct_nonadapt(8),:); total_colors(ismember(caps,bestAct_nonadapt(3)+10:10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))),:); total_colors(ismember(caps,bestAct_nonadapt(8)+10:10:(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))),:)];
        else % adaptive
            %cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
            cmap1 = [total_colors(caps==bestAct_adapt(3),:); total_colors(caps==bestAct_adapt(8),:); total_colors(ismember(caps,bestAct_adapt(3)+10:10:(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))),:); total_colors(ismember(caps,bestAct_adapt(8)+10:10:(bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10))),:)];
        end
        cmap2 = cbrewer('div', 'Spectral',11);
        cmap = cbrewer('qual', 'Set3', n);
        
        % Define range capacity states to consider for optimal flexible dam
        s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
        
        % Plot final expansions for flexible alternatives:
        s_C_bins = s_C - 0.01;
        s_C_bins(end+1) = s_C(end)+0.01;
        
        clear cPnowCounts; clear cPnowCounts_test;
        
        for type = 1:2 % flexible design and flexible planning
            if type == 1
                t = 1; % index of flexible design
            else
                t= 3; % index for flexible planning
            end
            
            for k=1:5
                cPnowCounts(k,:) = histcounts(action(:,k,t), s_C_bins);
                cPnowCounts_test(k,:) = histcounts(action(:,k,t), s_C_bins);
            end
            
            for j=2:5
                cPnowCounts(j,1) = cPnowCounts(1,1); % static
                cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4))); % flexible design (unexp)
                cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end)); % flexible planning (unexp)
                %cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
                cPnowCounts(j,4:3+bestAct(4)) = cPnowCounts(j-1,4:3+bestAct(4)) + cPnowCounts(j,4:3+bestAct(4)); % flex design (exp)
                cPnowCounts(j,4+bestAct(4):end) = cPnowCounts(j-1,4+bestAct(4):end) + cPnowCounts(j,4+bestAct(4):end); % flex planning (exp)
            end
            cPnowCounts = cPnowCounts./10000.*100; % convert counts to percent of simulations
            
            colormap(cmap);
            nexttile(1)
            %b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat');
            b1 = bar(1+(2*(type-1)+s),cPnowCounts(5,2:end)', 'stacked','FaceColor','flat',...
                'LineWidth',1); % expansion by the final time period
            for i=1:length(b1) % recolor
                    b1(i).FaceColor = cmap1(i,:);
            end
            hold on
        end
        
        xlim([1.5 5.5])
        %xline(3.5,'LineWidth',.8)
        set(gca, 'XTick', [2 3 4 5])
        %set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
        %    'Static Ops.';'Flexible Ops.'},'FontSize',22)
        %ylabel('Simulations (%)','FontSize',22);
        set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
            'Static Ops.';'Flexible Ops.'},'FontSize',10)
        ylabel('Simulations (%)','FontSize',10);
        
        % create legend labels based on either flex design  or flex
        % planning (whichever has more expansion options)
        %if s == 1 % non-adaptive
        
    end
    
    % make legend from psuedo-bar containing all possible values
    b1 = bar(6, [minCap:10:max(maxFlex, maxPlan)]', 'stacked','FaceColor','flat',...
        'LineWidth',1); % expansion by the final time period
    
    for i=1:length(b1) % recolor
        b1(i).FaceColor = total_colors(caps == minCap+(i-1)*10,:);
    end
    h=get(gca,'Children');
    capState = strcat(string([minCap:10:max([maxPlan, maxFlex])]), " MCM");
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    l.ItemTokenSize(1) = 60;
    %l.Position = l.Position + [-0.15 -0.15 0 0.05];
    box on
    
    xlim([1.5, 5.5])
    ylim([0,100])
    
    ax = gca;
    ax.LineWidth = 1.5;
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    box on
    allaxes = findall(f, 'type', 'axes');
    title({strcat("Discount Rate: ", string(discounts(d)),"%")},'FontSize',12) %25
    %title({strcat("Discount Rate: ", string(discounts(d)),"%");strcat("Total Installed Capacity by 2100 (66-97 mm/mo)")},'FontSize',12) %25
    
    % set figure size
    figure_width = 15; %25;
    figure_height = 4; %5;
    %figure_width = 8;
    %figure_height = 10;
    
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
    
    %%  Bar Timing of Expansion by End of Planning Period
    
    f = figure;
    
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
        
        % number of forward simulations:
        R = size(action,1);
        
        % frequency of 1st decision (flexible or static)
        act1 = action(:,1,end);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % count timing of of exp decisions
        for type = 1:2 % flexible design and flexible planning
            
            if type == 1
                t = 1; % index of flexible design
            else
                t= 3; % index for flexible planning
            end
            
            % count percent of expansions in each time period
            actexp = action(:,2:end,t);
            exp1((2*(type-1)+s)) = sum(actexp(:,1) ~= 0,'all')/R*100; % in 1st time period, count any expansions
            exp2((2*(type-1)+s)) = sum(actexp(:,2) ~= 0,'all')/R*100; % in 2nd time period, count any expansions
            exp3((2*(type-1)+s)) = sum(actexp(:,3) ~= 0,'all')/R*100;
            exp4((2*(type-1)+s)) = sum(actexp(:,4) ~= 0,'all')/R*100; % any expansion s_C >=4
            %expnever((2*(type-1)+s)) = 100 - exp1((2*(type-1)+s)) - exp2((2*(type-1)+s)) - exp3((2*(type-1)+s)) - exp4((2*(type-1)+s)); % never expanded by end of planning period
            expnever((2*(type-1)+s)) = sum(sum(actexp(:,:),2)==0)/R*100; % never expanded by end of planning period
        end
    end
    
    % plot bars
    colormap(cmap)
    b = bar([expnever' exp1' exp2' exp3' exp4'; nan(4,5)], .8, 'stacked'); % single stacked bar: frequency of timing of expansion
    hold on
    b(1).FaceColor = cmap2(10,:);
    for i = 2:5
        b(i).FaceColor = cmap2(i+4,:);
    end
    
    xlim([0.5 4.5])
    ylim([0, 100])
    xticklabels({'Static Ops.', 'Flexible Ops.', 'Static Ops.', 'Flexible Ops.'})
    %title('Timing of Expansion Decisions','FontSize',12)
    ylabel('Simulations (%)')
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 12)
    grid on
    
    l = legend({'never' decade{1,2:end}}, 'FontSize', 12, 'Orientation','horizontal', 'Location',"southoutside");
    l.ItemTokenSize(1) = 60;
    l.Position = l.Position + [-0.15 -0.15 0 0.05];
    box on
    
    % title
    title({strcat("Discount Rate: ", string(discounts(d)),"%")},'FontSize',25)
    
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
    
    %% Line Timing of Expansion by End of Planning Period
    
    f = figure;
    facecolors = [[153,204,204]; [191,223,223]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
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
        
        % number of forward simulations:
        R = size(action,1);
        
        % frequency of 1st decision (flexible or static)
        act1 = action(:,1,end);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % count timing of of exp decisions
        for type = 1:2 % flexible design and flexible planning
            
            if type == 1
                t = 1; % index of flexible design
            else
                t= 3; % index for flexible planning
            end
            
            clear exp1; clear exp2; clear exp3; clear exp4; clear expnever
            % count percent of expansions in each time period
            actexp = action(:,2:end,t);
            exp1 = sum(actexp(:,1) ~= 0,'all')/R*100; % in 1st time period, count any expansions
            exp2 = sum(actexp(:,2) ~= 0,'all')/R*100; % in 2nd time period, count any expansions
            exp3 = sum(actexp(:,3) ~= 0,'all')/R*100;
            exp4 = sum(actexp(:,4) ~= 0,'all')/R*100; % any expansion s_C >=4
            %expnever((2*(type-1)+s)) = 100 - exp1((2*(type-1)+s)) - exp2((2*(type-1)+s)) - exp3((2*(type-1)+s)) - exp4((2*(type-1)+s)); % never expanded by end of planning period
            expnever = sum(sum(actexp(:,:),2)==0)/R*100; % never expanded by end of planning period
            
            % plot
            expanded = cumsum([0 exp1' exp2' exp3' exp4'],2); % cumulative expansions over time
            if s==1 % non-adaptive
                plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s)+2,:),'LineWidth',2)
            else
                plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s)+2,:),'LineWidth',2,'LineStyle','--')
            end
            hold on
        end
    end

    xlim([1 5])
    ylim([0, 100])
    
    set(gca, 'XTick', [1 2 3 4 5])
    set(gca,'XTickLabel',{'2020', '2030','2040','2060','2080','2100'},'FontSize',9.5)
    xlabel('Time','FontWeight','bold');
    labels = {'Flexible Design & Static Ops.', 'Flexible Planning & Static Ops.', 'Flexible Design & Flexible Ops.','Flexible Planning & Flexible Ops.'};
    legend(labels, 'Location','northwest')
    
    %title('Timing of Expansion Decisions','FontSize',12)
    ylabel('Simulations Expanded (%)')
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 12)
    grid on
    
    box on
    
    % title
    title({strcat("Discount Rate: ", string(discounts(d)),"%")},'FontSize',25)
    
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
    
    
    %%  Frequency and Extent of Expansion by Decade
    
    nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    
    f = figure;
    
    clear cPnowCounts cPnowCounts_test
    cPnowCounts = cell(2,2);
    for s = 1:2 % for non-adaptive and adaptive operations
        %clear cPnowCounts cPnowCounts_test
        
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
        
        cmap1 = [adapt_flex_colors]/255;
        cmap2 = cbrewer('div', 'Spectral',11);
        cmap = cbrewer('qual', 'Set3', n);
        
        % Define range capacity states to consider for optimal flexible dam
        s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
        
        s_C_bins = s_C - 0.01;
        s_C_bins(end+1) = s_C(end)+0.01;
        
        for type = 1:2 % flex design and flex planning
            
            if type == 1
                t = 1; % column index of flexible design (action)
                st = 2; % column index for flexible design (cPnowCounts)
            else
                t= 3; % column index for flexible planning (action)
                st=3; % index for flexible planning (cPnowCounts)
            end
            
            % make counts of expansions over time
            cPnowCounts{type,s} = zeros(5,length(s_C));
            for k=1:5
                cPnowCounts{type,s}(k,:) = histcounts(action(:,k,t), s_C_bins);
                cPnowCounts_test{type,s}(k,:) = histcounts(action(:,k,t), s_C_bins)/R*100;
            end
            
            for j=2:5
                cPnowCounts{type,s}(j,1) = cPnowCounts{type,s}(1,1);
                cPnowCounts{type,s}(j,st) = cPnowCounts{type,s}(j-1,st)- sum(cPnowCounts{type,s}(j,4:end));
                %cPnowCounts(j,3,type,s) = cPnowCounts(j-1,3,type,s) - sum(cPnowCounts(j,4+bestAct(4):end,type,s));
                cPnowCounts{type,s}(j,4:end) = cPnowCounts{type,s}(j-1,4:end) + cPnowCounts{type,s}(j,4:end);
            end
        end
        
    end
    
    %colormap(cmap);
    for type = 1:2  % flex design and flex planning
        subplot(2,1,type)
        if type == 1
            % pad matrix dimensions to be consistent:
            rdiff = size(cPnowCounts{1, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)]),2)-size(cPnowCounts{1, 2}(2:5, [2, 4:3+bestAct_adapt(4)]),2);
            if rdiff > 0
                data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)])]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)]),zeros(4,rdiff)]'];
            elseif rdiff < 0
                data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)]),zeros(4,rdiff)]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)])]'];
            else
                data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)])]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)])]'];
            end
            
            % stacked bar
            b1 = bar(data'/R*100, 'stacked');
            for i=1:length(b1) % recolor
                b1(i).FaceColor = cmap1(i,:);
            end
            title({'Flexible Design',''},'FontSize',13)
        else
            % pad matrix dimensions to be consistent:
            rdiff = size(cPnowCounts{2, 1}(2:5,[3, 4+bestAct_nonadapt(4):end]),2)-size(cPnowCounts{2, 2}(2:5, [3, 4+bestAct_adapt(4):end]),2);
            if rdiff > 0
                data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end])]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end]),zeros(4,rdiff)]'];
            elseif rdiff < 0
                data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end]),zeros(4,rdiff)]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end])]'];
            else
                data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end])]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end])]'];
            end
            
            % stacked bar
            b1 = bar(data'/R*100, 'stacked');
            for i=1:length(b1) % recolor
                b1(i).FaceColor = cmap1(i,:);
            end
            title({'Flexible Planning';''},'FontSize',13)
        end
        xticklabels(repmat(decade_short(2:end),2));
        annotation('textbox', [0.28 0.88 0.1 0], 'string', 'Static Operations','EdgeColor','none','FontSize',11,'FontName','Arial', 'FontWeight','bold')
        annotation('textbox', [0.66 0.88 0.1 0], 'string', 'Flexible Operations','EdgeColor','none','FontSize',11,'FontName','Futura', 'FontWeight','bold')
        annotation('textbox', [0.28 0.44 0.1 0], 'string', 'Static Operations','EdgeColor','none','FontSize',11,'FontName','Arial', 'FontWeight','bold')
        annotation('textbox', [0.66 0.44 0.1 0], 'string', 'Flexible Operations','EdgeColor','none','FontSize',11,'FontName','Futura', 'FontWeight','bold')
        
        xlim([0.5,8.5])
        xline(4.5, 'black', 'LineWidth',1)
        grid on
        ylim([0,100])
        
        ylabel('Simulations (%)','FontWeight','bold');
        box('on')
    end
    
    % create legend labels based on either flex design  or flex
    % planning (whichever has more expansion options)
    
    xlabel('Time Period', 'FontWeight','bold');
    largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
    
    for z = 1:largest_dS
        labels(z) = {strcat("Exp:+", num2str(z*10)," MCM")};
    end
    h=get(gca,'Children');
    capState = ["Unexpanded{   }", labels{:}];
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    
    l.ItemTokenSize(1) = 60;
    l.Position = [0.28820166055601 0 0.458419963711265 0];
    
    % title
    sgtitle(strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',14, 'FontWeight','bold')
    
    % set figure size
    figure_width = 25;
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

    %% Final Climate State Histogram
    
    % percentile limits
s_P_abs = 66:1:97;
%lb = prctile(P_state_adapt(:,5),5);
lb = 76;
%ub =  prctile(P_state_adapt(:,5),95);
ub = 87;

[counts,center] = hist(P_state_adapt(:,5),length(s_P_abs));
figure()
for i = 1:length(s_P_abs)
    b(i) = bar(s_P_abs(i),counts(i),1,'FaceColor','flat');
    hold on
end
xlim([65,98])
xticks([66:2:98])
xticklabels('auto')

for i=1:length(s_P_abs)
    if b(i).XData <= lb
        b(i).FaceColor =[179, 87, 61]/255 ;
        ldry = b(i);
        %set(b(i),'FaceColor',[53, 138, 177]/255);
    elseif b(i).XData >= ub
        b(i).FaceColor = [53, 138, 177]/255;
        lwet = b(i);
    else
        b(i).FaceColor = [221, 221, 221]/255;
        lmod = b(i);
    end
end
grid on
legend([ldry, lmod, lwet],"Dry Final Climate States","Moderate Final Climate States","Wet Final Climate States")
xlabel('Final Precipitation State (mm/mo)')
ylabel('Frequency')
title('Histogram of Simulated Final Precipitation States')


    %% Extent of Volume Expansion by End of Planning Period CLIMATE TRANSITION
    
    f = figure;
    
    nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    
    %P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
    P_ranges = {[66:1:72];[73:1:86];[87:97]};
    
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
        
        %clear cPnowCounts cPnowCounts_test

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
                
                ind_P = logical(sum((P_state_adapt(:,end) == P_regret),2));
                action_P = action(ind_P,:,:);

                [R,~,~] = size(action_P); %size(action{1});

                cmap1 = [nonadapt_flex_colors(:,:)]/255;

                % Define range capacity states to consider for optimal flexible dam
                s_C = [1:3,4:3+bestAct(4)+bestAct(9)];

                % Plot final expansions for flexible alternatives:
                s_C_bins = s_C - 0.01;
                s_C_bins(end+1) = s_C(end)+0.01;

                for type = 1:2 % flexible design and flexible planning
                    if type == 1
                        t = 1; % index of flexible design
                    else
                        t= 3; % index for flexible planning
                    end

                    clear cPnowCounts cPnowCounts_test
                    for k=1:5
                        cPnowCounts(k,:) = histcounts(action_P(:,k,t), s_C_bins);
                        cPnowCounts_test(k,:) = histcounts(action_P(:,k,t), s_C_bins);
                    end

                    for j=2:5
                        cPnowCounts(j,1) = cPnowCounts(1,1); % static
                        cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4))); % flexible design (unexp)
                        cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end)); % flexible planning (unexp)
                        cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
                    end
                    cPnowCounts = cPnowCounts./R.*100; % convert counts to percent of simulations

                    % plot
                    subplot(3,1,p)
                    colormap(cmap);
                    if type == 1 % flex design
                        b1 = bar(1+(2*(type-1)+s), [cPnowCounts(5,[2, 4:3+bestAct(4)])]', 'stacked');
                        for i=1:length(b1) % recolor
                            b1(i).FaceColor = cmap1(i,:);
                        end
                    else
                        b1 = bar(1+(2*(type-1)+s),[cPnowCounts(5,[3, 4+bestAct(4):end])]', 'stacked');
                        for i=1:length(b1) % recolor
                            b1(i).FaceColor = cmap1(i,:);
                        end
                    end
                    ax = gca;
                    allaxes = findall(f, 'type', 'axes');
                    ax.YGrid = 'on';
                    hold on
                    ylim([0,100])
                    ylabel('Simulations (%)','FontSize',12);
                end

                xlim([1.5 5.5])
                if j == 3
                    set(gca, 'XTick', [2 3 4 5])
                    set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
                        'Static Ops.';'Flexible Ops.'},'FontSize',9.5)
                else
                    set(gca, 'XTick',[],'FontSize',9.5)
                end

                if p == 1
                    title(strcat('Dry Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
                elseif p == 2
                    title(strcat('Moderate Final Climate State (',  string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
                elseif p == 3
                    title(strcat('Wet Final Climate State (',  string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
                    % create legend labels based on either flex design  or flex
                    % planning (whichever has more expansion options)
                    largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
                    clear labels
                    for z = 1:largest_dS
                        labels(z) = {strcat("Exp:+", num2str(z*10)," MCM")};
                    end
                    h=get(gca,'Children');
                    capState = ["Unexpanded{   }", labels{:}];
                    l = legend(b1,capState,'Location','northeast','FontSize',9.5,'AutoUpdate','off');
                end
            end
        end

        sgtitle(strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',14, 'FontWeight','bold')

        % set figure size
        figure_width = 25;
        figure_height = 15;

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

    %% Total Capacity by End of Planning Period CLIMATE TRANSITION
    
    f = figure;
    til=tiledlayout(3,1);
    
    total_colors = [[241, 251, 255];[239, 247, 255];[198, 219, 233];[160, 196, 216];[111, 162, 191];[69, 131, 189];[36, 105, 171];[0, 70, 135];[9, 56, 100];[0, 33, 61];[0, 14, 25]]/255;
    caps = 50:10:150; % lookup vector for total colors
    
    % use consistent stacked color bar convention based on volume expanded
    nonadapt_plan_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    nonadapt_flex_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    adapt_plan_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    adapt_flex_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
    %P_ranges = {[66:1:72];[73:1:86];[87:97]};
    
    % range of total capacity installed for adaptive and non-adaptive
    minCap = min([bestAct_nonadapt(3), bestAct_nonadapt(8), ...
        bestAct_adapt(3), bestAct_adapt(8)]);
    maxCap = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5), ...
        bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10),...
        bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),...
        bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)]);
    maxPlan = max([bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10),...
        bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)]);
    maxFlex = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5), ...
        bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)]);
    
    %clear cPnowCounts cPnowCounts_test
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
        
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
            
            ind_P = logical(sum((P_state_adapt(:,end) == P_regret),2));
            action_P = action(ind_P,:,:);
            
            [R,~,~] = size(action_P); %size(action{1});
            
            
            clear cmap
            if s == 1 % nonadaptive
                %cmap1 = [[150, 150, 150]; [150, 150, 150]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
                cmap = [total_colors(caps==bestAct_nonadapt(3),:); total_colors(caps==bestAct_nonadapt(8),:); total_colors(ismember(caps,bestAct_nonadapt(3)+10:10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))),:); total_colors(ismember(caps,bestAct_nonadapt(8)+10:10:(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))),:)];
            else % adaptive
                %cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
                cmap = [total_colors(caps==bestAct_adapt(3),:); total_colors(caps==bestAct_adapt(8),:); total_colors(ismember(caps,bestAct_adapt(3)+10:10:(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))),:); total_colors(ismember(caps,bestAct_adapt(8)+10:10:(bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10))),:)];
            end
            
            %cmap1 = [nonadapt_flex_colors(:,:)]/255;
            
            % Define range capacity states to consider for optimal flexible dam
            s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
            
            % Plot final expansions for flexible alternatives:
            s_C_bins = s_C - 0.01;
            s_C_bins(end+1) = s_C(end)+0.01;
            
            for type = 1:2 % flexible design and flexible planning
                if type == 1
                    t = 1; % index of flexible design
                else
                    t= 3; % index for flexible planning
                end
                
                clear cPnowCounts cPnowCounts_test
                for k=1:5
                    cPnowCounts(k,:) = histcounts(action_P(:,k,t), s_C_bins);
                    cPnowCounts_test(k,:) = histcounts(action_P(:,k,t), s_C_bins);
                end
                
                for j=2:5
                    cPnowCounts(j,1) = cPnowCounts(1,1); % static
                    cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4))); % flexible design (unexp)
                    cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end)); % flexible planning (unexp)
                    %cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
                    cPnowCounts(j,4:3+bestAct(4)) = cPnowCounts(j-1,4:3+bestAct(4)) + cPnowCounts(j,4:3+bestAct(4)); % flex design (exp)
                    cPnowCounts(j,4+bestAct(4):end) = cPnowCounts(j-1,4+bestAct(4):end) + cPnowCounts(j,4+bestAct(4):end); % flex planning (exp)
                end
                cPnowCounts = cPnowCounts./R.*100; % convert counts to percent of simulations
                
                % plot
                %subplot(3,1,p)
                nexttile(p)
                colormap(cmap);
                if type == 1 % flex design
                    b1 = bar(1+(2*(type-1)+s), [cPnowCounts(5,[2, 4:3+bestAct(4)])]', 'stacked');
                    cmap1 = cmap([1 3:2+bestAct(4)],:);
                    for i=1:length(b1) % recolor
                        b1(i).FaceColor = cmap1(i,:);
                    end
                else
                    b1 = bar(1+(2*(type-1)+s),[cPnowCounts(5,[3, 4+bestAct(4):end])]', 'stacked');
                    cmap1 = cmap([2 3+bestAct(4):end],:);
                    for i=1:length(b1) % recolor
                        b1(i).FaceColor = cmap1(i,:);
                    end
                end
                ax = gca;
                allaxes = findall(f, 'type', 'axes');
                ax.YGrid = 'on';
                hold on
                ylim([0,100])
                ylabel('Simulations (%)','FontSize',12);
            end
            
            xlim([1.5 5.5])
            if p == 3
                set(gca, 'XTick', [2 3 4 5])
                set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
                    'Static Ops.';'Flexible Ops.'},'FontSize',9.5)
            else
                set(gca, 'XTick',[],'FontSize',9.5)
            end
            
            if p == 1
                title({strcat("Discount Rate: ", string(discounts(d)),"%");strcat('Dry Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)')},'FontSize',10)
            elseif p == 2
                title({"";strcat('Moderate Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)')},'FontSize',10)
            else
                title({"";strcat('Wet Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)')},'FontSize',10)
                % create legend labels based on either flex design  or flex
                % planning (whichever has more expansion options)
                largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
            end
        end
    end
    
    
    % make legend from psuedo-bar containing all possible values
    b1 = bar(6, [minCap:10:max(maxFlex, maxPlan)]', 'stacked','FaceColor','flat',...
        'LineWidth',1); % expansion by the final time period
    
    for i=1:length(b1) % recolor
        b1(i).FaceColor = total_colors(caps == minCap+(i-1)*10,:);
    end
    h=get(gca,'Children');
    capState = strcat(string([minCap:10:max([maxPlan, maxFlex])]), " MCM");
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    l.ItemTokenSize(1) = 60;
    %l.Position = l.Position + [-0.15 -0.15 0 0.05];
    box on
    
    xlim([1.5, 5.5])
    ylim([0,100])
    
    % create legend labels based on either flex design  or flex
    % planning (whichever has more expansion options)
    %     largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
    %     clear labels
    %     for z = 1:largest_dS
    %         labels(z) = {strcat("Exp:+", num2str(z*10)," MCM")};
    %     end
    %     h=get(gca,'Children');
    %     capState = ["Unexpanded{   }", labels{:}];
    %     l = legend(b1,capState,'Orientation','horizontal',...
    %         'Location','southoutside','FontSize',10,'AutoUpdate','off');
    %
    %     l.ItemTokenSize(1) = 60;
    %     l.Position == l.Position + [-0.15 -0.15 0 0.05];
    
    %sgtitle(strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',14, 'FontWeight','bold')
    %title(til,strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',10, 'FontWeight','bold')
    til.Padding = 'compact';
    til.TileSpacing = 'none';
    
    % set figure size
%     figure_width = 25;
%     figure_height = 15;
    figure_width = 8;
    figure_height = 10;
    
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
    
    %% Bar Timing of Expansion by End of Planning Period by CLIMATE
    
    f = figure;
        
    clear cPnowCounts cPnowCounts_test

    P_ranges = {[66:1:72];[73:1:86];[87:97]}; % reference dry, moderate, and wet climates
    
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
        
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
            
            ind_P = logical(sum((P_state_adapt(:,end) == P_regret),2));
            action_P = action(ind_P,:,:);
            
            [R,~,~] = size(action_P); %size(action{1});
            
            % frequency of 1st decision (flexible or static)
            act1 = action_P(:,1,end);
            static = sum(act1 == 1);
            flex = sum(act1 == 2);
            plan = sum(act1 == 3);
            
            for type = 1:2 % flexible design and flexible planning
                if type == 1
                    t = 1; % index of flexible design
                else
                    t= 3; % index for flexible planning
                end
                
                % count percent of expansions in each time period
                actexp = action_P(:,2:end,t);
                exp1((2*(type-1)+s)) = sum(actexp(:,1) ~= 0,'all')/R*100; % in 1st time period, count any expansions
                exp2((2*(type-1)+s)) = sum(actexp(:,2) ~= 0,'all')/R*100; % in 2nd time period, count any expansions
                exp3((2*(type-1)+s)) = sum(actexp(:,3) ~= 0,'all')/R*100;
                exp4((2*(type-1)+s)) = sum(actexp(:,4) ~= 0,'all')/R*100; % any expansion s_C >=4
                %expnever((2*(type-1)+s)) = 100 - exp1((2*(type-1)+s)) - exp2((2*(type-1)+s)) - exp3((2*(type-1)+s)) - exp4((2*(type-1)+s)); % never expanded by end of planning period
                expnever((2*(type-1)+s)) = sum(sum(actexp(:,:),2)==0)/R*100; % never expanded by end of planning period
            end
        end
        % plot
        subplot(3,1,p)
        colormap(cmap)
        cmap2 = cbrewer('div', 'Spectral',11);
        b = bar([expnever' exp1' exp2' exp3' exp4'; nan(4,5)], .8, 'stacked'); % single stacked bar: frequency of timing of expansion
        hold on
        
        b(1).FaceColor = cmap2(10,:);
        for i = 2:5
            b(i).FaceColor = cmap2(i+4,:);
        end
        
        ax = gca;
        allaxes = findall(f, 'type', 'axes');
        ax.YGrid = 'on';
        hold on
        ylim([0,100])
        ylabel('Simulations (%)','FontSize',12);
        
        xlim([0.5 4.5])
        if p == 3
            set(gca, 'XTick', [1 2 3 4])
            set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
                'Static Ops.';'Flexible Ops.'},'FontSize',9.5)
        else
            set(gca, 'XTick',[],'FontSize',9.5)
        end
        
        if p == 1
            title(strcat('Dry Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
        elseif p == 2
            title(strcat('Moderate Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
        else
            title(strcat('Wet Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
            labels = {'Never' decade{:}};
            legend(b, labels, 'Location','northeast')
        end
    end
    
    sgtitle(strcat("Discount Rate: ", disc,"%"),'FontSize',14, 'FontWeight','bold')
    
    % set figure size
    figure_width = 25;
    figure_height = 15;
    
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
    
    %% Line Timing of Expansion by End of Planning Period by CLIMATE
    
    f = figure;
        
    facecolors = [[153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    clear cPnowCounts cPnowCounts_test
    P_ranges = {[66:1:72];[73:1:86];[87:97]}; % reference dry, moderate, and wet climates
    
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
     
        
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
            
            ind_P = logical(sum((P_state_adapt(:,end) == P_regret),2));
            action_P = action(ind_P,:,:);
            
            [R,~,~] = size(action_P); %size(action{1});
            
            % frequency of 1st decision (flexible or static)
            act1 = action_P(:,1,end);
            static = sum(act1 == 1);
            flex = sum(act1 == 2);
            plan = sum(act1 == 3);
            
            for type = 1:2 % flexible design and flexible planning
                if type == 1
                    t = 1; % index of flexible design
                else
                    t= 3; % index for flexible planning
                end
                
                clear exp1; clear exp2; clear exp3; clear exp4; clear expnever
                % count percent of expansions in each time period
                actexp = action_P(:,2:end,t);
                exp1 = sum(actexp(:,1) ~= 0,'all')/R*100; % in 1st time period, count any expansions
                exp2 = sum(actexp(:,2) ~= 0,'all')/R*100; % in 2nd time period, count any expansions
                exp3 = sum(actexp(:,3) ~= 0,'all')/R*100;
                exp4 = sum(actexp(:,4) ~= 0,'all')/R*100; % any expansion s_C >=4
                expnever = sum(sum(actexp(:,:),2)==0)/R*100; % never expanded by end of planning period
            
                % plot
                subplot(3,1,p)
                expanded = cumsum([0 exp1' exp2' exp3' exp4'],2); % cumulative expansions over time
                if s==1 % non-adaptive
                    plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s),:),'LineWidth',2)
                else
                    plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s),:),'LineWidth',2,'LineStyle','--')
                end
                hold on
            end
        end
        
        ax = gca;
        allaxes = findall(f, 'type', 'axes');
        ax.YGrid = 'on';
        %grid('minor')
        hold on
        ylim([0,100])
        ylabel('Simulations Expanded (%)','FontSize',12);
        
        xlim([1, 5])
        set(gca, 'XTick', [1 2 3 4 5])
        set(gca,'XTickLabel',{'2020', '2030','2040','2060','2080','2100'},'FontSize',9.5)
        
        if p == 1
            title(strcat('Dry Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
        elseif p == 2
            title(strcat('Moderate Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
        else
            title(strcat('Wet Final Climate State (', string(P_regret(1)),'-',string(P_regret(end)),'mm/mo)'),'FontSize',12)
            xlabel('Time','FontWeight','bold');
            labels = {'Flexible Design & Static Ops.', 'Flexible Planning & Static Ops.', 'Flexible Design & Flexible Ops.','Flexible Planning & Flexible Ops.'};
            legend(labels, 'Location','northeast')
        end
    end
    
    sgtitle({strcat("Discount Rate: ", disc,"%"),'Simulated Dam Expansion vs. Time'},'FontSize',14, 'FontWeight','bold')
    
    % set figure size
    figure_width = 10;
    figure_height = 12;
    
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
     
    %% Frequency and Extent of Expansion by Decade by CLIMATE
    
    nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    
    f = figure;
        
    clear cPnowCounts cPnowCounts_test
    cPnowCounts = cell(2,2);
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
    
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
     
        for s = 1:2 % for non-adaptive and adaptive operations
            %clear cPnowCounts cPnowCounts_test
            
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
            
            ind_P = logical(sum((P_state_adapt(:,end) == P_regret),2));
            action_P = action(ind_P,:,:);
            
            [R,~,~] = size(action_P);
            
            %cmap1 = cbrewer('qual', 'Set2', n);
            
            cmap1 = [adapt_flex_colors]/255;
            cmap2 = cbrewer('div', 'Spectral',11);
            cmap = cbrewer('qual', 'Set3', n);
            
            % Define range capacity states to consider for optimal flexible dam
            s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
            
            s_C_bins = s_C - 0.01;
            s_C_bins(end+1) = s_C(end)+0.01;
            
            for type = 1:2 % flex design and flex planning
                
                if type == 1
                    t = 1; % column index of flexible design (action)
                    st = 2; % column index for flexible design (cPnowCounts)
                else
                    t= 3; % column index for flexible planning (action)
                    st=3; % index for flexible planning (cPnowCounts)
                end
                
                % make counts of expansions over time
                cPnowCounts{type,s} = zeros(5,length(s_C));
                for k=1:5
                    cPnowCounts{type,s}(k,:) = histcounts(action_P(:,k,t), s_C_bins);
                    cPnowCounts_test{type,s}(k,:) = histcounts(action_P(:,k,t), s_C_bins)/R*100;
                end
                
                for j=2:5
                    cPnowCounts{type,s}(j,1) = cPnowCounts{type,s}(1,1);
                    cPnowCounts{type,s}(j,st) = cPnowCounts{type,s}(j-1,st)- sum(cPnowCounts{type,s}(j,4:end));
                    %cPnowCounts(j,3,type,s) = cPnowCounts(j-1,3,type,s) - sum(cPnowCounts(j,4+bestAct(4):end,type,s));
                    cPnowCounts{type,s}(j,4:end) = cPnowCounts{type,s}(j-1,4:end) + cPnowCounts{type,s}(j,4:end);
                end
            end
            
        end
        
        %colormap(cmap);
        for type = 1:2  % flex design and flex planning
            subplot(3,2,type+2*(p-1))
            if type == 1
                % pad matrix dimensions to be consistent:
                rdiff = size(cPnowCounts{1, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)]),2)-size(cPnowCounts{1, 2}(2:5, [2, 4:3+bestAct_adapt(4)]),2);
                if rdiff > 0
                    data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)])]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)]),zeros(4,rdiff)]'];
                elseif rdiff < 0
                    data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)]),zeros(4,rdiff)]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)])]'];
                else
                    data = [[cPnowCounts{type, 1}(2:5,[2, 4:3+bestAct_nonadapt(4)])]', [cPnowCounts{type, 2}(2:5, [2, 4:3+bestAct_adapt(4)])]'];
                end
                
                % stacked bar
                b1 = bar(data'/R*100, 'stacked');
                for i=1:length(b1) % recolor
                    b1(i).FaceColor = cmap1(i,:);
                end
                title({strcat("Flexible Design (", string(P_regret(1)),'-',string(P_regret(end))," mm/mo)"),''},'FontSize',13)
            else
                % pad matrix dimensions to be consistent:
                rdiff = size(cPnowCounts{2, 1}(2:5,[3, 4+bestAct_nonadapt(4):end]),2)-size(cPnowCounts{2, 2}(2:5, [3, 4+bestAct_adapt(4):end]),2);
                if rdiff > 0
                    data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end])]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end]),zeros(4,rdiff)]'];
                elseif rdiff < 0
                    data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end]),zeros(4,rdiff)]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end])]'];
                else
                    data = [[cPnowCounts{type, 1}(2:5,[3, 4+bestAct_nonadapt(4):end])]', [cPnowCounts{type, 2}(2:5, [3, 4+bestAct_adapt(4):end])]'];
                end
                
                % stacked bar
                b1 = bar(data'/R*100, 'stacked');
                for i=1:length(b1) % recolor
                    b1(i).FaceColor = cmap1(i,:);
                end
                title({strcat("Flexible Planning (", string(P_regret(1)),'-',string(P_regret(end))," mm/mo)");''},'FontSize',13)
            end
            xticklabels(repmat(decade_short(2:end),2)');
            
            xlab_loc = [0.17, 0.61; 0.33, 0.77];
            ylab_loc = [0.86 0.58 0.3];
            labs = {'Static Operations'; 'Flexible Operations'};
            
            for xlab = 1:2
                for lr = 1:2
                    annotation('textbox', [xlab_loc(1,xlab) ylab_loc(p) 0.1 0], 'string', 'Static Operations','EdgeColor','none','FontSize',11, 'FontWeight','bold')
                    annotation('textbox', [xlab_loc(2,xlab) ylab_loc(p) 0.1 0], 'string', 'Flexible Operations','EdgeColor','none','FontSize',11,'FontWeight','bold')
                end
            end
            
            xlim([0.5,8.5])
            xline(4.5, 'black', 'LineWidth',1)
            grid on
            ylim([0,100])
            
            ylabel('Simulations (%)','FontWeight','bold');
            box('on')
            if p == 3
                xlabel('Time Period', 'FontWeight','bold');
            end
        end
    end
    
    % create legend labels based on either flex design  or flex
    % planning (whichever has more expansion options)
    
    largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
    
    for z = 1:largest_dS
        labels(z) = {strcat("Exp:+", num2str(z*10)," MCM")};
    end
    h=get(gca,'Children');
    capState = ["Unexpanded{   }", labels{:}];
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    
    l.ItemTokenSize(1) = 60;
    l.Position = [0.28820166055601 0 0.458419963711265 0];
    
    % title
    sgtitle(strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',16, 'FontWeight','bold')
    
    % set figure size
    figure_width = 25;
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
    
    %% Mean simulated dam and shortage cost breakdown by CLIMATE (V1 stacked)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    f=figure();
    t = tiledlayout(3,1);
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
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

    %% Mean simulated dam and shortage cost breakdown by CLIMATE (V2 stacked)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    f=figure();
    t = tiledlayout(3,1);
    %t.Padding = 'compact';
    t.TileSpacing = 'none';
    
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
        % find climate subset from data for adaptive and non-adaptive
        % operations
        totalCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
        damCost_P([2,1,3]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
        expCost_P([2,1,3]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
        shortageCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));    
        
        totalCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
        damCost_P([5,4,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
        expCost_P([5,4,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
        shortageCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));    

        costs = [damCost_P, expCost_P, shortageCost_P];
        
        % bar plot of average costs from simulations:
        %subplot(3,1,p)
        nexttile
        c = [[230,230,230];[110, 110, 110];[177,89,89]; [114,114,114];[90,90,90];[44,44,44]]/255;
        b = bar([1,2,3,4.2,5.2,6.2],costs,'stacked','FaceColor',"flat");
        if p == 1
        title({strcat("Dry Final Climates")},'FontSize',13)
        set(gca, 'XTick',[],'FontSize',10)
        legend('Initial Dam Cost','Dam Expansion Cost','Shortage Cost','FontSize',10);
        else
            title({strcat("Wet Final Climates")},'FontSize',13)
            if p==2
                title({strcat("Moderate Final Climates")},'FontSize',13)
            end
            set(gca, 'XTick',[],'FontSize',10)         
        end
        %grid('on')
        ax = gca;
        %ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.FontSize = 12;

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
        end
        
        ax = gca;
        ax.LineWidth = 1.5;

        xlim([0.5,6.7])
        
          % add lables with intial dam cost (not discounted)
         xtips = [1,2,3,4.2,5.2,6.2];
 
         % total cost labels
         ytips = sum(costs,2);
         %labels = strcat('$',string(round(ytips,1)),"M");
         %text(xtips,ytips,labels,'HorizontalAlignment','center',...
         %    'VerticalAlignment','bottom','FontSize',10,'FontWeight','bold')
 
         % dam cost labels
         ytips = 0.5* costs(:,1);
         labels = strcat('$',string(round(costs(:,1),1)),"M");
%          text(xtips,ytips,labels,'HorizontalAlignment','center',...
%              'VerticalAlignment','middle','FontSize',9)
%          
        
        yl = ylim;
        ylim([0, yl(2)+0.2*yl(2)])

        if p == 3
        %legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')

        set(gca, 'XTick', [1,2,3,4.2,5.2,6.2])

        set(gca,'XTickLabel',{strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning'),...
            strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning')})
        
        text(1.5, -35, "Static Operations",'FontSize',15,'FontWeight','bold')
        text(4.45, -35, "Flexible Operations",'FontSize',15,'FontWeight','bold')
              
        end
    end
    
    ylabel(t,'Mean Simulated Cost (M$)','FontWeight','bold','FontSize',15)
    %title(t,strcat("Discount Rate: ", disc,'%'),'FontWeight','bold','FontSize',11)
    title(t,strcat("Mean Simulated Costs by 2100"),'FontWeight','bold','FontSize',13)

    %sgtitle(strcat("Discount Rate: ", disc, "%"), 'FontSize',22)
    %font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    %set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    figure_width = 12;
    figure_height = 8;
    
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

     %% Mean simulated dam and shortage cost breakdown by CLIMATE (compact)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    f=figure();
    t = tiledlayout(1,2,'TileSpacing','compact');
    bgAx = axes(t,'Xtick',[],'Ytick',[]);
    bgAx.Layout.TileSpan = [1 2];
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
    %P_ranges = {[66:1:76]};
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
        % find climate subset from data for adaptive and non-adaptive
        % operations
        totalCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
        damCost_P([2,1,3]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
        expCost_P([2,1,3]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
        shortageCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));    
        
        totalCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
        damCost_P([5,4,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
        expCost_P([5,4,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
        shortageCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));    

        costs = [damCost_P, expCost_P];
        
        % bar plot of average costs from simulations:
        %subplot(3,1,p)
        climate_cols = [[214, 84, 58];[27, 67, 50];[50,82,123]]/255; %[47, 79,79]
        c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
        
        b = bar([1,2,3,4.2,5.2,6.2], costs,'stacked','FaceColor',"flat");
        ax = gca;
        ax.YMinorGrid = 'on';

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
            
            if k==1
                b(k).EdgeColor = 'k';
                b(k).LineWidth = 1.5;
                b1 = b(k);
            else
                b(k).EdgeColor = climate_cols(p,:);
                b(k).LineWidth = 1.5;
                if p == 1
                    b_dry = b(k);
                elseif p ==2
                    b_mod = b(k);
                else
                    b_wet = b(k);
                end    
            end
        end
        hold on
        l(p) = scatter([1,2,3,4.2,5.2,6.2],damCost_P + expCost_P + shortageCost_P,...
            75,climate_cols(p,:),'filled');
%         l(p) = plot([1,2,3,4.2,5.2,6.2],damCost_P + expCost_P + shortageCost_P,...
%             'color',climate_cols(p,:),'Marker','.','Markersize',22,'LineWidth',2.5);
        
        ax = gca;
        %ax.XAxis.MinorTick = 'off';
        ax.LineWidth = 1.5;

        ylabel('Mean Simulated Cost (M$)','FontWeight','bold','FontSize',12)
        xlim([0.5,6.7])
        
        
          % add lables with intial dam cost (not discounted)
         xtips = [1,2,3,4.2,5.2,6.2];
         
         % dam cost labels
         ytips = 0.5* costs(:,1);
         labels = strcat('$',string(round(costs(:,1),1)),"M");
         text(xtips,ytips,labels,'HorizontalAlignment','center',...
             'VerticalAlignment','middle','FontSize',11)
         
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



    end
    
    title({strcat("Discount Rate: ", disc, "%");'Mean Simulated Costs by 2100'}, 'FontSize',12)
    %t.Padding = 'compact';
    t.TileSpacing = 'none';
    font_size = 13;
    ax = gca;
    %ax.XGrid = 'on';
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    %legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')
    hold on
    b_null = plot([0 0.25],[0 0], 'LineStyle', 'none');
    leg1 = legend([b1 b_dry b_mod b_wet],{'Initial Dam Cost',...
            'Expansion Cost (Dry)','Expansion Cost (Moderate)',...
            'Expansion Cost (Wet)'},'Location','northeast','autoupdate','off');
        title(leg1,'Mean Infrastructure Costs')

        set(gca, 'XTick', [1,2,3,4.2,5.2,6.2])

        set(gca,'XTickLabel',{strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning'),...
            strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning')})
        
        text(1.5, -35, "Static Operations",'FontSize',15,'FontWeight','bold')
        text(4.66, -35, "Flexible Operations",'FontSize',15,'FontWeight','bold')
        
        hold on
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1,[l(1) l(2) l(3)],{'Total Cost (Dry)',...
            'Total Cost (Moderate)','Total Cost (Wet)',},'Location',...
            'northeast','autoupdate','off','LineWidth', 1.5,'FontSize',13);
        title(leg2,'Mean Total Costs')
        leg2.Position = [0.737517388673317,0.589274599647711,0.155370372948823,0.126736113760206];
        
        
    figure_width = 15;
    figure_height = 8;
    
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

    
    %% Sample forward simulation by CLIMATE
    
    f = figure();
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [72 79 87]; % dry, moderate, wet
    
    s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    
    for p = 1:length(P_regret) % for each transition to drier or wetter climate
        
        % Index realizations where final P state is 72, 79, or 87 mm/mo
        [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(p));
        [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(p));
        
        % P state time series: select associated time series
        Pnow_adapt = P_state_adapt(ind_P_adapt,:);
        Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
        
        % Actions: select associated simulations
        ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
        ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
        
        % map actions to dam capacity of time (fill actions with value 0)
        % == FLEXIBLE DESIGN ==
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
        [uP, uPIdxs, ~] = unique(Pnow_adapt, 'rows','stable'); % use these when calling subsetted matrix
        uPIdxAll = ind_P_adapt(uPIdxs); % use these indices when calling 10000 matrix
        
        % PLOTS
        if p==1 % dry plot index
            idxP = uPIdxs(179); %(2) (179) Stable: 85
            idxPall = uPIdxAll(179);
        elseif p == 2 % moderate plot index
            idxP = uPIdxs(29); %(5);
            idxPall = uPIdxAll(29);
        else % wet plot index
            idxP = uPIdxs(25); %(3);
            idxPall = uPIdxAll(25);
        end
        
        if discountCost == 1 || disc == "0" % use discounted costs
            % Dam Cost Time: select associated simulations for given P state
            damCostPnowFlex_adapt = damCost_adapt(idxPall,:,1);
            damCostPnowFlex_nonadapt = damCost_nonadapt(idxPall,:,1);
            damCostPnowStatic_adapt = damCost_adapt(idxPall,:,2);
            damCostPnowStatic_nonadapt = damCost_nonadapt(idxPall,:,2);
            damCostPnowPlan_adapt = damCost_adapt(idxPall,:,3);
            damCostPnowPlan_nonadapt = damCost_nonadapt(idxPall,:,3);
            
            % Shortage Cost Time: select associated simulations
            shortageCostPnowFlex_adapt = totalCost_adapt(idxPall,:,1)-damCost_adapt(idxPall,:,1);
            shortageCostPnowFlex_nonadapt = totalCost_nonadapt(idxPall,:,1)-damCost_nonadapt(idxPall,:,1);
            shortageCostPnowStatic_adapt = totalCost_adapt(idxPall,:,2)-damCost_adapt(idxPall,:,2);
            shortageCostPnowStatic_nonadapt = totalCost_nonadapt(idxPall,:,2)-damCost_nonadapt(idxPall,:,2);
            shortageCostPnowPlan_adapt = totalCost_adapt(idxPall,:,3)-damCost_adapt(idxPall,:,3);
            shortageCostPnowPlan_nonadapt = totalCost_nonadapt(idxPall,:,3)-damCost_nonadapt(idxPall,:,3);
            
        else % non-discounted:use shortage cost files
            for i=1:5
                Ps = [66:1:97]; % P states indexed for 18:49 (Keani)
                P_now = Pnow_nonadapt(idxP,i); % current P state
                
                % dam capacity at that time
                staticCap_adapt = s_C_adapt(actionPnowStatic_adapt(idxP,i));
                staticCap_nonadapt = s_C_nonadapt(actionPnowStatic_nonadapt(idxP,i));
                flexCap_adapt = s_C_adapt(actionPnowFlex_adapt(idxP,i));
                flexCap_nonadapt = s_C_nonadapt(actionPnowFlex_nonadapt(idxP,i));
                planCap_adapt = s_C_adapt(actionPnowPlan_adapt(idxP,i));
                planCap_nonadapt = s_C_nonadapt(actionPnowPlan_nonadapt(idxP,i)); % flex plan capacity at N=i
                
                % dam cost based on capacity at that time (infra_cost tables)
                
                % damCostPnowStatic_adapt = interp1(infra_cost_adaptive.static(1,:), infra_cost_adaptive.static(2,:), staticCap_adapt);
                damCostPnowStatic_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,2)+1)/1E6;
                damCostPnowStatic_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,2)+1)/1E6;
                damCostPnowFlex_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,1)+1)/1E6;
                damCostPnowFlex_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,1)+1)/1E6;
                damCostPnowPlan_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,3)+1)/1E6;
                damCostPnowPlan_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,3)+1)/1E6;
                
                % corresponding shortage cost at that time and P state
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(staticCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
                
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(flexCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
                
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(planCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp/1E6;
            end
        end
        
        % plot dam capacity vs time:
        subplot(3,3,p)
        damCap_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
            s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
            s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
        %yyaxis left
        b = bar(1:5, damCap_comb,'facecolor','flat');
        for i = 1:6
            b(i).CData = repmat(facecolors(i,:),[5,1]);
        end
        ylim([0,160])
        xticklabels([])
        grid on
        ylabel('Capacity (MCM)','FontWeight','bold')
        title({strcat(string(P_regret(p))," mm/mo");'Dam Capacity vs. Time'},'FontWeight','bold')
        hold on
        yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
        hold on
        yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
        hold on
        yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
        hold on
        yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
        hold on
        
        % plot dam infrastructure costs over time:
        subplot(3,3,p+3)
        damCosts_comb = zeros(5,6);
        for i = 1:5
            damCosts_comb(i,1:6) = [damCostPnowStatic_nonadapt(i), damCostPnowStatic_adapt(i),...
                damCostPnowFlex_nonadapt(i), damCostPnowFlex_adapt(i), damCostPnowPlan_nonadapt(i), damCostPnowPlan_adapt(i)];
        end
        yyaxis left
        if discountCost == 1
            h = bar(1:5, damCosts_comb);
        else
            h = bar(1:5, damCosts_comb);
        end
        for i = 1:6
            h(i).FaceColor = facecolors(i,:);
        end
        xticklabels([])
        ylabel('Cost (M$)','FontWeight','bold')
        title('Infrastructure Cost vs. Time','FontWeight','bold')
        grid on
        
        % add line for precipitation state over time on secondary axis:
        yyaxis right
        hold on
        p1 = plot(P_state(idxPall,:),'color','black','LineWidth',1.5);
        ylabel('P State (mm/mo)')
        ylim([65,95]);
        xlim([0.5,5.5])
        box on
        
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        % Plot shortage cost vs time
        subplot(3,3,p+6)
        yyaxis left
        shortageCosts_comb = zeros(5,6);
        for i = 1:5
            shortageCosts_comb(i,1:6) = [ shortageCostPnowStatic_nonadapt(i), shortageCostPnowStatic_adapt(i),...
                shortageCostPnowFlex_nonadapt(i), shortageCostPnowFlex_adapt(i), shortageCostPnowPlan_nonadapt(i), shortageCostPnowPlan_adapt(i)];
        end
        if discountCost == 1
            h = bar(1:5, shortageCosts_comb);
        else
            %h = bar(1:5, damCosts_comb/1E6);
            h = bar(1:5, [zeros(1,6); shortageCosts_comb(2:5,:)]);
        end
        for i = 1:6
            %h(i).FaceColor = [211,211,211]/255;
            h(i).FaceColor = facecolors(i,:);
        end
        hold on
%         l1 = yline(infra_cost_adaptive_lookup(5)/1E6, '--', 'color', facecolors(3,:), 'LineWidth',2);
%         hold on
%         l2 = yline(infra_cost_nonadaptive_lookup(5)/1E6, 'color',facecolors(3,:), 'LineWidth',2);
%         hold on
%         l3=yline(infra_cost_adaptive_lookup(5+bestAct_adapt(4))/1E6, '--','color', facecolors(5,:), 'LineWidth',2);
%         hold on
%         l4=yline(infra_cost_nonadaptive_lookup(5+bestAct_nonadapt(4))/1E6,'color', facecolors(5,:), 'LineWidth',2);        
%         xticklabels(decade_short)
        grid on
        ylim([0,10])
        xlabel('Time Period','FontWeight','bold')
        ylabel('Cost (M$)','FontWeight','bold')
        title('Simulated Shortage Cost vs. Time','FontWeight','bold')
        xticklabels(decade_short);
        
        
        % add line for precipitation state over time on secondary axis:
        yyaxis right
        hold on
        p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5);
        ylabel('P State (mm/mo)')
        ylim([65,95]);
        xlim([0.5,5.5])
        box on
        
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        
        % add legend:
        if p == 1
            hL = legend([h(1), h(2), h(3), h(4), h(5), h(6), p1],{strcat("Static Dam"),strcat("Flexible Ops & Static Design"),...
                strcat("Static Ops & Flexible Design"),...
                strcat("Flexible Ops & Flexible Design"),strcat("Static Ops & Flexible Planning"),...
                strcat("Flexible Ops & Flexible Planning"),"Precip. state"},'Orientation','horizontal', 'FontSize', 9);
            
            % Programatically move the Legend
            newPosition = [0.4 0.05 0.2 0];
            newUnits = 'normalized';
            set(hL,'Position', newPosition,'Units', newUnits);
        end
    end
    
    sgtitle(strcat("Discount Rate: ", string(discounts(d)),"%"),'FontSize',16, 'FontWeight','bold')
    
    figure_width = 25;%20;
    figure_height = 10;%6;
    
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
    
    %% Plot the CDF of total simulated costs
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
    
    % == ZOOM IN OF DRY CLIMATE COSTS ==
    f = figure;
    percentiles = [95;100];
    
    for i = 1
        ptile = percentiles(2,i);
        p1 = patch( [minCostPnow_all(1) minCostPnow_all(1) maxCostPnow_all(1) maxCostPnow_all(1)],  [0 1 1 0], [232,232,232]/255,'LineStyle','none');
        p1.FaceVertexAlphaData = 0.0001;
        p1.FaceAlpha = 'flat';
        hold on
        
        %         c1 = cdfplot(totalCostStatic_nonadapt/1E6);
        %         c1.LineWidth = 3;
        %         c1.Color = facecolors{1};
        %         hold on
        %         c2 = cdfplot(totalCostStatic_adapt/1E6);
        %         c2.LineWidth = 3;
        %         c2.Color = facecolors{2};
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
        title('Zoomed CDF: Dry Climate')
        box on
        grid off
        ax = gca;
        ax.LineWidth = 2;
        
        %xlim([150,1800])
        
        font_size = 18;
        allaxes = findall(f, 'type', 'axes');
        set(allaxes,'FontSize', font_size)
        set(findall(allaxes,'type','text'),'FontSize', font_size)
        
        % == ZOOM IN OF WET CLIMATE COSTS ==
        f = figure;
        percentiles = [0;50];
        
        for i = 1
            ptile = percentiles(2,i);
            p3 = patch( [minCostPnow_all(3) minCostPnow_all(3) maxCostPnow_all(3) maxCostPnow_all(3)],  [0 1 1 0], [154,154,154]/255,'LineStyle','none');
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
            xlim([prctile(totalCostStatic_adapt/1E6, percentiles(1,i)),103])
            title('Zoomed CDF: Wet Climate')
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
    end
    %% Flex Planning vs. Design Plots including box plot:
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
    nexttile([2,2])
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
    ylabel('Precipitation State (mm/mo)','FontWeight','bold')
    
    %ylim([0,17])
    set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
    legend([a(1) a(6) p1, meds(1)],{'Flexible Planning','Flexible Design',...
        'Mean','Median'},'Location','northwest')
    
    title('Precipitation States by Time Period for Best 10 Percentile Simulations','Fontweight','bold')
    
end

%% Shortage Cost Plot (not subplots, use T state =1)

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storages = [50 70 90 110 130 150]; % MCM
cprime = 1.25E-6;

% set the shortagecost folder path
%folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/'
folder = 'Data/Nov02post_process_sdp_reservoir_results/';
scost_adapt = zeros(length(s_P_abs),length(storages));
scost_nonadapt = zeros(length(s_P_abs),length(storages));

% make data matrix for plots
for s=1:length(storages)
    s_now = storages(s);
    
    for t=1
        tidx = t;
        load(strcat(folder,'sdp_adaptive_shortage_cost_s',string(s_now),'.mat'));    
        % save shortage cost in new matrix
        scost_adapt(:,s) = shortageCost(1,:).*cprime;
        
        load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
        % save shortage cost in new matrix
        scost_nonadapt(:,s) = shortageCost(1,:).*cprime;
    end
end

f=figure();
t = tiledlayout(1,2,'Padding','compact');
for i=1:2
    %nexttile()
    if i==1 % nonadaptive ops
        p = plot(s_P_abs,scost_nonadapt/1E6,'LineWidth',1.2);
    else % adaptive ops
        p = plot(s_P_abs,scost_adapt/1E6,'--','LineWidth',1.2);
    end
    
    colors = {[0.6350, 0.0780, 0.1840]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250];...
        [0.4660 0.6740 0.1880]; [0 0.4470 0.7410]; [0.4940 0.1840 0.5560]};
    for j=1:length(storages)
        p(j).Color = colors{j};
    end
    
    xlabel('Precipitation State (mm/mo)','FontWeight','bold')
    ylabel('Shortage Cost (M$)','FontWeight','bold')
    %xlim([s_P_abs(1),s_P_abs(end)]);
    xlim([66, 80]);
    hold on
end
title({'Shortage Cost vs. Precipitation State'},'FontWeight','bold')

% add legend
leg1 = legend(strcat(string(storages), " MCM"),'Location','NorthEast','AutoUpdate','off');
l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--');
title(leg1,'Dam Capacity')
leg1.Title.Visible = 'on';
grid('minor')
grid 'on'
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, [l1 l2], "Static", "Flexible",'Location','SouthEast');
title(leg2,'Dam Operations')
leg2.Title.Visible = 'on';


%% c' Senstivity: optimal design vs. c' value (scatter)

% Make scatter plots of values
folder = 'Nov02_cprimes'; % folder to load
facecolors = [[153,204,204]; [153, 153, 204]; ...
        [255, 102, 102]; [255, 153, 153]]/255;

f=figure;
for des = 1:3 % (1) static design (2) flexible design (3) flexible planning
    for ops = 1:2 % (1) static ops (2) flexible ops
        load(strcat(folder,'/Nov02cprimes_des',string(des),'_ops',string(ops),'_disc0.mat'))
        if ops == 1 % flexible ops
            %             s(des,ops)=scatter(round_min_cprimes,60:10:140,'o','LineWidth',1,...
            %                 'MarkerEdgeColor',facecolors(des,:),'MarkerFaceColor',facecolors(des,:));
            s(des,ops)=scatter(round_min_cprimes,60:10:140,50,'o','LineWidth',1,...
                'MarkerEdgeColor',facecolors(des,:));
            if des == 1 % for static ops, add point to 150 MCM
                hold on
                %scatter(2.6E-6,150,'o','LineWidth',1,...
                %'MarkerEdgeColor',facecolors(des,:),'MarkerFaceColor',facecolors(des,:));
            end
        else
            %             s(des,ops)=scatter(round_min_cprimes,60:10:140,'*','LineWidth',1,...
            %                 'MarkerEdgeColor',facecolors(des,:),'MarkerFaceColor',facecolors(des,:));
            s(des,ops)=scatter(round_min_cprimes,60:10:140,50,'*','LineWidth',1,...
                'MarkerEdgeColor',facecolors(des,:));
            if des == 1 % for static ops, add point to 150 MCM
                hold on
                %scatter(3.5E-6,150,'*','LineWidth',1,...
                %'MarkerEdgeColor',facecolors(des,:),'MarkerFaceColor',facecolors(des,:));
            end
        end
        hold on
    end
end
l1 = xline(1.25E-6,'--','DisplayName',"c'=1.25E-6 $/m^6",'LineWidth',1.5);
%l1.Label = "c'=1.25E-6";
hold on
l2 = xline(1.00E-7,'-.','DisplayName',"c'=1.00E-7 $/m^6",'LineWidth',1.5);
%l2.Label = "c'=1.00E-7";
labels=["c'=1.00E-7","c'=1.25E-6"];
t = text([1.00E-7+0.15E-6, 1.25E-6+0.15E-6],[130, 55],labels,"HorizontalAlignment","left","VerticalAlignment","bottom",'FontSize',12);
set(t,'Rotation',90);

% legend([s(1,1),s(2,1),s(3,1),s(1,2),s(2,2),s(3,2),l1,l2],'Static Design & Static Ops.','Flexible Design & Static Ops.',...
%     'Flexible Planning & Static Ops.','Static Design & Flexible Ops.','Flexible Design & Flexible Ops.',...
%     'Flexible Planning & Flexible Ops.',"Baseline c'=1.25E-6 $/m^6","Scenario c'=1.00E-7 $/m^6")
ylim([50,145])
xlim([1E-8, 3E-6])
%grid 'minor'
grid 'on'
xlabel("c' ($/m^6)",'FontWeight','bold')
ylabel("Optimal Initial Dam Capacity (MCM)",'FontWeight','bold')
%title("Optimal Initial Dam Capacity vs. c'",'Fontweight','bold','FontSize',13)
box on
ax=gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
ax.LineWidth = 1.5;

hold on
pt(1)=scatter(-10,-10,'*','LineWidth',1,...
                'MarkerEdgeColor',[0 0 0]/255);
hold on
pt(2)=scatter(-10,-10,'o','LineWidth',1,...
                'MarkerEdgeColor',[0 0 0]);
hold on
dtype(1) = bar(-10,-10);
dtype(1).FaceColor = facecolors(1,:);
hold on
dtype(2) = bar(-10,-10);
dtype(2).FaceColor = facecolors(2,:);
hold on
dtype(3) = bar(-10,-10);
dtype(3).FaceColor = facecolors(3,:);

leg1 = legend([pt(1), pt(2)],'Static Operations','Flexible Operations');
leg1.FontSize = 10;
title(leg1,'Infrastructure Operation')

ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1,[dtype(1) dtype(2) dtype(3)],'Static Design','Flexible Design', 'Flexible Planning');
leg2.FontSize = 10;
leg2.LineWidth = 1.5;
title(leg2, 'Infrastructure Design')

%% c' senstivity: Comparison of Mean Shortage Cost by Climate (c'=1.25E-6 vs 1E-7)

f=figure();

% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [1.25e-6 1E-7]; %[1.25e-6, 5e-6];

% specify file path for data
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1 %length(discounts)
    disc = string(discounts(d));
    for cs = 1:2 %4%length(cprimes)
        cp = cprimes(cs);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        % load adaptive operations files:
        if cs == 1
            folder = 'Jan28optimal_dam_design_comb';
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
        else
            folder = 'Jun10optimal_dam_design_comb';
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
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
        if cs == 1
            folder = 'Jan28optimal_dam_design_comb';
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'.mat'))
        else
            folder = 'Jun10optimal_dam_design_comb';
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr150.mat'))
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
        
        P_ranges = {[66:76],[77:86],[87:97]}; % reference dry, moderate, and wet climates
        
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
            ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
            
            % find climate subset from data for adaptive and non-adaptive
            % operations
            totalCost_P([3,1,5]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
            damCost_P([3,1,5]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
            expCost_P([3,1,5]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
            shortageCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));
            
            totalCost_P([4,2,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
            damCost_P([4,2,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
            expCost_P([4,2,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
            shortageCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));
            
            %climate_cols = [[214, 84, 58];[110,110,110];[50,82,123]]/255; %[47, 79,79]
            climate_cols = [[214, 84, 58];[110,110,110];[55,114,204]]/255; 
            
            hold on
            if cs == 1
            l(p,cs) = scatter([1,2,3,4.2,5.2,6.2],shortageCost_P,...
                100,climate_cols(p,:),'square','LineWidth',1.5);
            elseif cs == 2
                l(p,cs) = scatter([1,2,3,4.2,5.2,6.2],shortageCost_P,...
                100,climate_cols(p,:),'x','LineWidth',1.5);
            end
            
            hold on
            
            ax = gca;
            %ax.XAxis.MinorTick = 'off';
            ax.LineWidth = 1.5;
            ax.YAxis.FontSize = 22;
        end
    end
    
end
    
    ylabel('Mean Shortage Cost (M$)','FontWeight','bold','FontSize',12)
    xlim([0.5,6.7])
    ylim([-8, 300])
    %title('Mean Simulated Shortage Cost vs. Infrastructure Alternative by Final Climate','FontWeight','bold','FontSize',22)
    set(gca, 'YMinorGrid','on')
    %set(gca, 'YGrid','on')
    box on
        
    set(gca,'XTick',[1,2,3,4.2,5.2,6.2])
    set(gca,'XTickLabel',{strcat('Static Design'),...
        strcat('Flexible Design.'),...
        strcat('Flexible Planning'),...
        strcat('Static Design'),...
        strcat('Flexible Design'),...
        strcat('Flexible Planning')},'FontSize',12);
    
    hold on
    mkrType(1) = scatter(-1,1,75,[0 0 0]/255,'square','LineWidth',1.5,'DisplayName',"c'=1.25E-6 $/m^6");
    hold on
    mkrType(2) = scatter(-1,1,75,[0 0 0]/255,'x','LineWidth',1,'DisplayName',"c'=1.00E-7 $/m^6");
    
    leg1 = legend([mkrType(1) mkrType(2)],'Location','northeast','autoupdate','off','FontSize',10);
    title(leg1,"c' Scenario")
    
    hold on
    mkrColor(1) = bar(-1,1,'FaceColor',climate_cols(1,:),'DisplayName','Dry');
    hold on
    mkrColor(2) = bar(-1,1,'FaceColor',climate_cols(2,:),'DisplayName','Moderate');
    hold on
    mkrColor(3) = bar(-1,1,'FaceColor',climate_cols(3,:),'DisplayName','Wet');
    hold on
    ah1=axes('position',get(gca,'position'),'visible','off');
    leg2 = legend(ah1,[mkrColor(1) mkrColor(2) mkrColor(3)],'Location',...
        'northeast','autoupdate','off','FontSize',10,'LineWidth',1.5);
    title(leg2,'Final Climate')
    text(0.15, -0.06, "Static Operations",'FontSize',12,'FontWeight','bold')
    text(0.65, -0.06, "Flexible Operations",'FontSize',12,'FontWeight','bold')
        
    figure_width = 12;
    figure_height = 15;
    
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
    
    
%% c' senstivity: difference in mean total costs (c'=1.25E-6 vs 3.5E-6)

f=figure();
t = tiledlayout(4,7);

% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [1.25e-6 3.5e-6]; %[1.25e-6, 5e-6];

% specify file path for data
folder = 'Jan28optimal_dam_design_comb';
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=2 %length(discounts)
    disc = string(discounts(d));
    for cs = 1:2 %4%length(cprimes)
        cp = cprimes(cs);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        % load adaptive operations files:
        load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))

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
        load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))

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
        
        P_ranges = {[66:97]}; % reference dry, moderate, and wet climates
    
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
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
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
        %subplot(4,7,[1,2,3,4,5,8,9,10,11,12,15,16,17,18,19,22,23,24,25,26])
        %subplot(4,6,1:21)
        nexttile(1,[4 5]);
        c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
        b = bar(repmat((cs-1)*6+1:1:6+(cs-1)*6,3,1)',costs,'stacked','FaceColor',"flat");
        title({strcat("Mean Simulated Total Cost by 2100 (", string(P_ranges{p}(1)),"-",string(P_ranges{p}(end))," mm/mo)");""},'FontSize',13)
        set(gca, 'XTick',[],'FontSize',10)
        hold on
        set(gca, 'YGrid', 'on', 'XGrid', 'off')

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
        end
        
        ax = gca;
        ax.LineWidth = 1.5;
        plot([6.5,6.5],[0,200],'-k');

        ylabel('Mean Simulated Cost (M$)','FontWeight','bold','FontSize',12)
        xlim([0.5,12.5])
        ylim([0,160])
        
         % add lables with intial dam cost (not discounted)
         xtips = (cs-1)*6+1:1:6+(cs-1)*6;
 
         % total cost labels
%         ytips = sum(costs,2);
%         labels = strcat(string(round(ytips,1)));
%         text(xtips,ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','bottom','FontSize',9,'FontWeight','bold')
% 
%          % dam cost labels
%          ytips = 0.5* costs(:,1);
%          labels = strcat(string(round(costs(:,1),1)));
%          text(xtips,ytips,labels,'HorizontalAlignment','center',...
%              'VerticalAlignment','middle','FontSize',9)
 
%          % dam expansion cost labels
%          ytips = costs(3:end,1)+ 0.5* costs(3:end,2);
%          labels = strcat(string(round(costs(3:end,2),1)));
%          text(xtips(3:end),ytips,labels,'HorizontalAlignment','center',...
%             'VerticalAlignment','middle','FontSize',9)
%  
%          % shortage cost labels
%          ytips = costs(:,1)+costs(:,2)+costs(:,3)*0.5;
%          labels = strcat(string(round(costs(:,3),1)));
%          text(xtips,ytips,labels,'HorizontalAlignment','center',...
%              'VerticalAlignment','middle','FontSize',9)
        
        if cs==2
        legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')

        set(gca, 'XTick', 1:12)

        set(gca,'XTickLabel',{strcat('Static Ops.'),...
            strcat('Flex. Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flex. Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flex. Ops.'),strcat('Static Ops.'),...
            strcat('Flex. Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flex. Ops.'),...
            strcat('Static Ops.'),...
            strcat('Flex. Ops.')},'FontSize',9);
        end
    end
    
    %P_ranges = {[66:1:76]}; % reference dry, moderate, and wet climates
    P_ranges = {[66:1:76],[87:1:97]};
    
     s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    
        % re-initialize mean cost arrays:
        totalCost_P = NaN(6,1);
        damCost_P = NaN(6,1);
        expCost_P = NaN(6,1);
        shortageCost_P = NaN(6,1);
        
        % calculate the average shortage, dam, and expansion costs for each
        % climate state:
        ind_P = ismember(P_state_adapt(:,5),P_ranges{1});
        
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
        if cs ==1
            %subplot(4,7,[6,7,13,14]);
            nexttile(6,[2 2]);
        else
             %subplot(4,7,[20,21,27,28]);
             nexttile(20,[2 2]);
        end
       
        c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
        b = bar(costs,'stacked','FaceColor',"flat");
        hold on
        
        if cs == 1
            title({strcat("Mean Simulated Costs by 2100(",string(P_ranges{p}(1)),'-',string(P_ranges{p}(end))," mm/mo)");strcat("c' :", string(cprimes(cs)))},'FontSize',10)
            set(gca, 'XTick',[],'FontSize',10)
        else
            title({strcat("c' :", string(cprimes(cs)))},'FontSize',10)
        end
        set(gca, 'YGrid', 'on', 'XGrid', 'off')

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
        end
        
        ax = gca;
        ax.LineWidth = 1.5;

        ylabel('Mean Simulated Cost (M$)','FontWeight','bold','FontSize',10)
        xlim([0.5,6.5])
        ylim([0,300])
        
        if cs==2
            set(gca, 'XTick', 1:6)
            set(gca,'XTickLabel',{strcat('Static Ops.'),...
                strcat('Flex. Ops.'),...
                strcat('Static Ops.'),...
                strcat('Flex. Ops.'),...
                strcat('Static Ops.'),...
                strcat('Flex. Ops.')},'FontSize',9);
        end
 
    end
end
    %end
t.Padding = 'compact';
    t.TileSpacing = 'none';
    %font_size = 20;
    ax = gca;
    allaxes = findall(f, 'type', 'axes');
    %set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    figure_width = 25;
    figure_height = 6;
    
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
   
%% Discount sensitivity: boxplot Nondiscounted Total Costs vs. Time (compact line plot)
    
%Setup and Loading Data
    
% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 7.5E-7 3.5e-6 3.75e-6 6e-6 1.72 2.45]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for datw
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1:3%length(discounts)
    disc = string(discounts(d));
    for c = 3 %4%length(cprimes)
        cp = cprimes(c);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        if fixInitCap == 0
            folder = 'Jan28optimal_dam_design_comb';
            folder = 'May25optimal_dam_design_comb';
            %folder = 'Jun09optimal_dam_design_comb';
        else
            folder = 'Feb7optimal_dam_design_comb';
        end
        
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
            infra_cost_nonadaptive_lookup = infra_cost/1E6;
        else
            infra_cost_adaptive = struct();
            infra_cost_adaptive.static = [storage(1); infra_cost(2)/1E6];
            infra_cost_adaptive.flex = [[storage(2), storage(4:3+optParam.numFlex)]; [infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6];
            infra_cost_adaptive.plan = [[storage(3), storage(4+optParam.numFlex:end)]; [infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6];
            infra_cost_adaptive_lookup = infra_cost/1E6;
        end
        end
    
        %% Non-discounted Boxplot of costs over time for dry climates
    if d==1
        f = figure();
    end
    folder = 'Nov02post_process_sdp_reservoir_results';
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [{66:76}]; % dry, moderate, wet
    
    s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    
    for p = 1:length(P_regret) % for each transition to drier or wetter climate
        
        % Index realizations where final P state is 72, 79, or 87 mm/mo
        [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret{1});
        [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret{1});
        
        % P state time series: select associated time series
        Pnow_adapt = P_state_adapt(ind_P_adapt,:);
        Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
        
        % Actions: select associated simulations
        ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
        ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
        
        % map actions to dam capacity of time (fill actions with value 0)
        % == FLEXIBLE DESIGN ==
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
        
        
        if discountCost == 1 || disc == "0" % use discounted costs
            % Dam Cost Time: select associated simulations for given P state
            damCostPnowFlex_adapt = damCost_adapt(ind_P_adapt,:,1);
            damCostPnowFlex_nonadapt = damCost_nonadapt(ind_P_adapt,:,1);
            damCostPnowStatic_adapt = damCost_adapt(ind_P_adapt,:,2);
            damCostPnowStatic_nonadapt = damCost_nonadapt(ind_P_adapt,:,2);
            damCostPnowPlan_adapt = damCost_adapt(ind_P_adapt,:,3);
            damCostPnowPlan_nonadapt = damCost_nonadapt(ind_P_adapt,:,3);
            
            % Shortage Cost Time: select associated simulations
            shortageCostPnowFlex_adapt = totalCost_adapt(ind_P_adapt,:,1)-damCost_adapt(ind_P_adapt,:,1);
            shortageCostPnowFlex_nonadapt = totalCost_nonadapt(ind_P_adapt,:,1)-damCost_nonadapt(ind_P_adapt,:,1);
            shortageCostPnowStatic_adapt = totalCost_adapt(ind_P_adapt,:,2)-damCost_adapt(ind_P_adapt,:,2);
            shortageCostPnowStatic_nonadapt = totalCost_nonadapt(ind_P_adapt,:,2)-damCost_nonadapt(ind_P_adapt,:,2);
            shortageCostPnowPlan_adapt = totalCost_adapt(ind_P_adapt,:,3)-damCost_adapt(ind_P_adapt,:,3);
            shortageCostPnowPlan_nonadapt = totalCost_nonadapt(ind_P_adapt,:,3)-damCost_nonadapt(ind_P_adapt,:,3);
            
        else % non-discounted:use shortage cost files
            for i=1:5  
                
                % dam capacity at that time
                staticCap_adapt = s_C_adapt(actionPnowStatic_adapt(:,i));
                staticCap_nonadapt = s_C_nonadapt(actionPnowStatic_nonadapt(:,i));
                flexCap_adapt = s_C_adapt(actionPnowFlex_adapt(:,i));
                flexCap_nonadapt = s_C_nonadapt(actionPnowFlex_nonadapt(:,i));
                planCap_adapt = s_C_adapt(actionPnowPlan_adapt(:,i));
                planCap_nonadapt = s_C_nonadapt(actionPnowPlan_nonadapt(:,i)); % flex plan capacity at N=i
                
                % dam cost based on capacity at that time (infra_cost tables)
                
                % damCostPnowStatic_adapt = interp1(infra_cost_adaptive.static(1,:), infra_cost_adaptive.static(2,:), staticCap_adapt);
                damCostPnowStatic_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,2)+1);
                damCostPnowStatic_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,2)+1);
                damCostPnowFlex_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,1)+1);
                damCostPnowFlex_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,1)+1);
                damCostPnowPlan_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,3)+1);
                damCostPnowPlan_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,3)+1);
                
                % corresponding shortage cost at that time and P state
                if i==1
                    shortageCostPnowStatic_nonadapt(:,i)=0;
                    shortageCostPnowStatic_adapt(:,i)=0;
                    shortageCostPnowFlex_nonadapt(:,i)=0;
                    shortageCostPnowFlex_adapt(:,i)=0;
                    shortageCostPnowPlan_nonadapt(:,i)=0;
                    shortageCostPnowPlan_adapt(:,i)=0;
                else
                    for j=1:length(staticCap_nonadapt)
                        Ps = [66:1:97]; % P states indexed for 18:49 (Keani)
                        P_now = Pnow_adapt(j,i);
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowStatic_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(staticCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowStatic_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowFlex_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(flexCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowFlex_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowPlan_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(planCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowPlan_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                    end
                end
            end
        end
        
        % =================================================================
        % line plot mean non-discounted cost over time (only for flexible planning):
        nondisc_DamCostTime = damCostPnowPlan_adapt + shortageCostPnowPlan_adapt;
        cols = [[132 169 140]; [82 121 111]; [53 79 82]]/255;
        
        hold on
        p1(d)=plot((1:5),mean(nondisc_DamCostTime), '-','Marker','.','MarkerSize',20,'LineWidth',2,...
            'Color',cols(d,:),'MarkerEdgeColor',cols(d,:));
        
        if d==3
            xticks([1 2 3 4 5])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
            ylabel('Non-Discounted Cost (M$)','FontWeight','bold')
            
            l = legend([p1(1) p1(2) p1(3)],{'0%','3%','6%'},'Location','northwest');
            title(l,'Discount Rate')
        end

        title(strcat("Mean Non-Discounted Costs vs. Time Period"),'Fontweight','bold')
        box on
        
        ax = gca;
        ax.YAxis.Color = 'k';
        grid 'on'
        ax.YMinorGrid = 'on';
        if d==3
            xticks([1, 2, 3, 4, 5])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
        else
            xticks([0, 1, 2, 3, 4])
            xticklabels([])
        end
    end
        
    figure_width = 8;%20;
    figure_height = 10;%6;
    xlim([0.75, 5.25])
    ylim([0,100])
    
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

%% Discount sensitivity: boxplot Nondiscounted Total Costs vs. Time (box plot)
    
%Setup and Loading Data
    
% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 7.5E-7 3.5e-6 3.75e-6 6e-6 1.72 2.45]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for datw
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1:3%length(discounts)
    disc = string(discounts(d));
    for c = 3 %4%length(cprimes)
        cp = cprimes(c);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        if fixInitCap == 0
            folder = 'Jan28optimal_dam_design_comb';
            folder = 'May25optimal_dam_design_comb';
            %folder = 'Jun09optimal_dam_design_comb';
        else
            folder = 'Feb7optimal_dam_design_comb';
        end
        
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
            infra_cost_nonadaptive_lookup = infra_cost/1E6;
        else
            infra_cost_adaptive = struct();
            infra_cost_adaptive.static = [storage(1); infra_cost(2)/1E6];
            infra_cost_adaptive.flex = [[storage(2), storage(4:3+optParam.numFlex)]; [infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6];
            infra_cost_adaptive.plan = [[storage(3), storage(4+optParam.numFlex:end)]; [infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6];
            infra_cost_adaptive_lookup = infra_cost/1E6;
        end
        end
    
        %% Non-discounted Boxplot of costs over time for dry climates
    if d==1
        f = figure();
        t = tiledlayout(3,1);
    end
    folder = 'Nov02post_process_sdp_reservoir_results';
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [{66:76}]; % dry, moderate, wet
    
    s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
    
    for p = 1:length(P_regret) % for each transition to drier or wetter climate
        
        % Index realizations where final P state is 72, 79, or 87 mm/mo
        [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret{1});
        [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret{1});
        
        % P state time series: select associated time series
        Pnow_adapt = P_state_adapt(ind_P_adapt,:);
        Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
        
        % Actions: select associated simulations
        ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
        ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
        
        % map actions to dam capacity of time (fill actions with value 0)
        % == FLEXIBLE DESIGN ==
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
        
        
        if discountCost == 1 || disc == "0" % use discounted costs
            % Dam Cost Time: select associated simulations for given P state
            damCostPnowFlex_adapt = damCost_adapt(ind_P_adapt,:,1);
            damCostPnowFlex_nonadapt = damCost_nonadapt(ind_P_adapt,:,1);
            damCostPnowStatic_adapt = damCost_adapt(ind_P_adapt,:,2);
            damCostPnowStatic_nonadapt = damCost_nonadapt(ind_P_adapt,:,2);
            damCostPnowPlan_adapt = damCost_adapt(ind_P_adapt,:,3);
            damCostPnowPlan_nonadapt = damCost_nonadapt(ind_P_adapt,:,3);
            
            % Shortage Cost Time: select associated simulations
            shortageCostPnowFlex_adapt = totalCost_adapt(ind_P_adapt,:,1)-damCost_adapt(ind_P_adapt,:,1);
            shortageCostPnowFlex_nonadapt = totalCost_nonadapt(ind_P_adapt,:,1)-damCost_nonadapt(ind_P_adapt,:,1);
            shortageCostPnowStatic_adapt = totalCost_adapt(ind_P_adapt,:,2)-damCost_adapt(ind_P_adapt,:,2);
            shortageCostPnowStatic_nonadapt = totalCost_nonadapt(ind_P_adapt,:,2)-damCost_nonadapt(ind_P_adapt,:,2);
            shortageCostPnowPlan_adapt = totalCost_adapt(ind_P_adapt,:,3)-damCost_adapt(ind_P_adapt,:,3);
            shortageCostPnowPlan_nonadapt = totalCost_nonadapt(ind_P_adapt,:,3)-damCost_nonadapt(ind_P_adapt,:,3);
            
        else % non-discounted:use shortage cost files
            for i=1:5  
                
                % dam capacity at that time
                staticCap_adapt = s_C_adapt(actionPnowStatic_adapt(:,i));
                staticCap_nonadapt = s_C_nonadapt(actionPnowStatic_nonadapt(:,i));
                flexCap_adapt = s_C_adapt(actionPnowFlex_adapt(:,i));
                flexCap_nonadapt = s_C_nonadapt(actionPnowFlex_nonadapt(:,i));
                planCap_adapt = s_C_adapt(actionPnowPlan_adapt(:,i));
                planCap_nonadapt = s_C_nonadapt(actionPnowPlan_nonadapt(:,i)); % flex plan capacity at N=i
                
                % dam cost based on capacity at that time (infra_cost tables)
                
                % damCostPnowStatic_adapt = interp1(infra_cost_adaptive.static(1,:), infra_cost_adaptive.static(2,:), staticCap_adapt);
                damCostPnowStatic_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,2)+1);
                damCostPnowStatic_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,2)+1);
                damCostPnowFlex_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,1)+1);
                damCostPnowFlex_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,1)+1);
                damCostPnowPlan_adapt(:,i) = infra_cost_adaptive_lookup(ActionPnow_adapt(:,i,3)+1);
                damCostPnowPlan_nonadapt(:,i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(:,i,3)+1);
                
                % corresponding shortage cost at that time and P state
                if i==1
                    shortageCostPnowStatic_nonadapt(j,i)=0;
                    shortageCostPnowStatic_adapt(j,i)=0;
                    shortageCostPnowFlex_nonadapt(j,i)=0;
                    shortageCostPnowFlex_adapt(j,i)=0;
                    shortageCostPnowPlan_nonadapt(j,i)=0;
                    shortageCostPnowPlan_adapt(j,i)=0;
                else
                    for j=1:length(staticCap_nonadapt)
                        Ps = [66:1:97]; % P states indexed for 18:49 (Keani)
                        P_now = Pnow_adapt(j,i);
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowStatic_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(staticCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowStatic_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowFlex_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(flexCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowFlex_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        
                        s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowPlan_nonadapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                        s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(planCap_adapt(j)),'.mat');
                        shortageCostDir = load(s_state_filename,'shortageCost');
                        shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                        shortageCostPnowPlan_adapt(j,i) = shortageCost_s_state(i, Ps == P_now)*cp;
                    end
                end
            end
        end
        
        % =================================================================
        % boxplot of cost over time (only for flexible planning):
        nexttile
        nondisc_DamCostTime = damCostPnowPlan_adapt + shortageCostPnowPlan_adapt;
        
        boxplot(nondisc_DamCostTime,'Widths',0.3,'OutlierSize',7,'Symbol','.','BoxStyle','filled');
        whisks = findobj(gca,'Tag','Whisker');
        outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
        meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
        
        set(meds(1:5),'Color','k');
        set(whisks(1:5),'Color',facecolors(5,:));
        set(outs(1:5),'MarkerEdgeColor',facecolors(5,:));
        a = findobj(gca,'Tag','Box');
        set(a(1:5),'Color',facecolors(5,:));
        
        hold on
        p1=plot((1:5),mean(nondisc_DamCostTime), 'k--','Marker','.','MarkerSize',10);
        %plot((1:5),mean(nondisc_DamCostTime), 'k.')
        
        if d==3
            xticks([1 2 3 4 5])
            xticklabels(decade_short)
            xlabel(t,'Time Period','Fontweight','bold')
            ylabel(t,'Non-Discounted Cost (M$)','FontWeight','bold')
            
            legend([p1 meds(1)],{'Mean','Median'},'Location','northwest')
        else
            xticks([1, 2, 3, 4 5])
            xticklabels([])
        end

        title(strcat("Discount Rate: ",string(discounts(d)),"%"),'Fontweight','bold')
        box on
        
        ax = gca;
        ax.YAxis.Color = 'k';
        grid 'on'
        ax.YMinorGrid = 'on';
        if d==3
            xticks([0, 1, 2, 3, 4])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
        else
            xticks([0, 1, 2, 3, 4])
            xticklabels([])
        end
    end
    
    title(t,strcat("Non-Discounted Costs vs. Time for Dry Final Climates"),'FontSize',13, 'FontWeight','bold')
    
    figure_width = 25;%20;
    figure_height = 10;%6;
    
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

%% Discount Senstivity: Discounted Costs by 2100 (compact)

% Setup and Loading Data

% specify file naming convensions
discounts = [0, 3, 6, 5];
cprimes = [1.25e-6]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Jun09optimal_dam_design_comb';
else
    folder = 'Feb7optimal_dam_design_comb';
end
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

f=figure();
t = tiledlayout(3,1,'TileSpacing','compact');

for d=1:3 %length(discounts)
    disc = string(discounts(d));
    for c = 1 %4%length(cprimes)
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
    
    %% Mean simulated dam and shortage cost breakdown by CLIMATE (compact)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
    %P_ranges = {[66:1:76]};
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
    
    nexttile()
    for p = 1:length(P_ranges)
        % re-initialize mean cost arrays:
        totalCost_P = NaN(6,1);
        damCost_P = NaN(6,1);
        expCost_P = NaN(6,1);
        shortageCost_P = NaN(6,1);
        
        % calculate the average shortage, dam, and expansion costs for each
        % climate state:
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
        % find climate subset from data for adaptive and non-adaptive
        % operations
        totalCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
        damCost_P([2,1,3]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
        expCost_P([2,1,3]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
        shortageCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));    
        
        totalCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
        damCost_P([5,4,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
        expCost_P([5,4,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
        shortageCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));    

        costs = [damCost_P, expCost_P];
        
        % bar plot of average costs from simulations:
        %subplot(3,1,p)
        climate_cols = [[214, 84, 58];[27, 67, 50];[50,82,123]]/255; %[47, 79,79]
        c = [[230,230,230];[200,200,200];[114,114,114];[90,90,90];[44,44,44]]/255;
        
        b = bar([1,2,3,4.2,5.2,6.2], costs,'stacked','FaceColor',"flat");
        ax = gca;
        ax.YMinorGrid = 'on';

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
            
            if k==1
                b(k).EdgeColor = 'k';
                b(k).LineWidth = 1;
                b1 = b(k);
            else
                b(k).EdgeColor = climate_cols(p,:);
                b(k).LineWidth = 1.5;
                if p == 1
                    b_dry = b(k);
                elseif p ==2
                    b_mod = b(k);
                else
                    b_wet = b(k);
                end    
            end
        end
        hold on
        l(p) = scatter([1,2,3,4.2,5.2,6.2],damCost_P + expCost_P + shortageCost_P,75,climate_cols(p,:),'filled');
        
        ax = gca;
        %ax.XAxis.MinorTick = 'off';
        %ax.LineWidth = 1.5;
        xlim([0.5,6.7])
        ylim([0,400])
        
        
          % add lables with intial dam cost (not discounted)
         xtips = [1,2,3,4.2,5.2,6.2];
         
         % dam cost labels
         ytips = 0.5* costs(:,1);
         labels = strcat('$',string(round(costs(:,1),1)),"M");
         text(xtips,ytips,labels,'HorizontalAlignment','center',...
             'VerticalAlignment','middle','FontSize',9)

    end
    
    title({strcat("Discount Rate: ", disc, "%")}, 'FontSize',10)
    %t.Padding = 'compact';
    t.TileSpacing = 'none';
    font_size = 10;
    ax = gca;
    %ax.XGrid = 'on';
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    %legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')
    hold on
    if d==3
        b_null = plot([0 0.25],[0 0], 'LineStyle', 'none');
        leg1 = legend([b1 b_dry b_mod b_wet],{'Initial Dam Cost',...
            'Expansion Cost (Dry)','Expansion Cost (Moderate)',...
            'Expansion Cost (Wet)'},'Location','northeast','autoupdate','off','LineWidth', 1,'FontSize',8);
        title(leg1,'Mean Infrastructure Costs')
        
        set(gca, 'XTick', [1,2,3,4.2,5.2,6.2])
        
        set(gca,'XTickLabel',{strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning'),...
            strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning')})
        
        text(1.5, -80, "Static Operations",'FontSize',12,'FontWeight','bold')
        text(4.66, -80, "Flexible Operations",'FontSize',12,'FontWeight','bold')
        
        hold on
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1,[l(1) l(2) l(3)],{'Total Cost (Dry)',...
            'Total Cost (Moderate)','Total Cost (Wet)',},'Location',...
            'northeast','autoupdate','off','LineWidth', 1,'FontSize',8);
        title(leg2,'Mean Total Costs')
        leg2.Position = [0.737517388673317,0.589274599647711,0.155370372948823,0.126736113760206];
    else
            xticks([1,2,3,4.2,5.2,6.2])
            xticklabels([])
    end
end
        
    title(t,'Mean Simulated Discounted Costs by 2100','FontWeight','bold','Fontsize',13)
    ylabel(t,'Mean Discounted Simulated Cost (M$)','FontWeight','bold','FontSize',12)

    
    figure_width = 15;
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

    
%% Discount Senstivity: Discounted Costs by 2100 (stacked V2)

% Setup and Loading Data

% specify file naming convensions
discounts = [0, 3, 6, 5];
cprimes = [1.25e-6]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Jun09optimal_dam_design_comb';
else
    folder = 'Feb7optimal_dam_design_comb';
end
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

f=figure();
t = tiledlayout(3,1,'TileSpacing','compact');

for d=1:3 %length(discounts)
    disc = string(discounts(d));
    for c = 1 %4%length(cprimes)
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
    
    %% Mean simulated dam and shortage cost breakdown by CLIMATE (stacked V2)
    
    %if disc == "0" 

    % create bar plot of expected dam and shortage costs:
    P_ranges = {[66:1:76]}; % reference dry, moderate, and wet climates
    %P_ranges = {[66:1:76]};
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
    
    nexttile()
    for p = 1:length(P_ranges)
        % re-initialize mean cost arrays:
        totalCost_P = NaN(6,1);
        damCost_P = NaN(6,1);
        expCost_P = NaN(6,1);
        shortageCost_P = NaN(6,1);
        
        % calculate the average shortage, dam, and expansion costs for each
        % climate state:
        ind_P = ismember(P_state_adapt(:,5),P_ranges{p});
        
        % find climate subset from data for adaptive and non-adaptive
        % operations
        totalCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,:,:),2)));
        damCost_P([2,1,3]) = squeeze(mean(damCost_nonadapt(ind_P,1,:)));
        expCost_P([2,1,3]) = squeeze(mean(sum(damCost_nonadapt(ind_P,2:5,:),2)));
        shortageCost_P([2,1,3]) = squeeze(mean(sum(totalCost_nonadapt(ind_P,2:5,:)- damCost_nonadapt(ind_P,2:5,:),2)));    
        
        totalCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,:,:),2)));
        damCost_P([5,4,6]) = squeeze(mean(damCost_adapt(ind_P,1,:)));
        expCost_P([5,4,6]) = squeeze(mean(sum(damCost_adapt(ind_P,2:5,:),2)));
        shortageCost_P([5,4,6]) = squeeze(mean(sum(totalCost_adapt(ind_P,2:5,:)- damCost_adapt(ind_P,2:5,:),2)));    

        costs = [damCost_P, expCost_P, shortageCost_P];
        
        % bar plot of average costs from simulations:
        %subplot(3,1,p)
        climate_cols = [[214, 84, 58];[27, 67, 50];[50,82,123]]/255; %[47, 79,79]
        c = [[230,230,230];[110, 110, 110];[177,89,89]; [114,114,114];[90,90,90];[44,44,44]]/255;
        
        b = bar([1,2,3,4.2,5.2,6.2], costs,'stacked','FaceColor',"flat");
        ax = gca;
        %ax.YMinorGrid = 'on';

        for k = 1:size(b,2)
            b(k).CData = c(k,:);
            
            if k==1
                b(k).LineWidth = 1.5;
                b1 = b(k);
            else
                b(k).LineWidth = 1.5;
                if p == 1
                    b_dry = b(k);
                elseif p ==2
                    b_mod = b(k);
                else
                    b_wet = b(k);
                end    
            end
        end
        
        ax = gca;
        %ax.XAxis.MinorTick = 'off';
        ax.LineWidth = 1.5;
        xlim([0.5,6.7])
        ylim([0,400])
        
        
          % add lables with intial dam cost (not discounted)
         xtips = [1,2,3,4.2,5.2,6.2];
         
         % dam cost labels
         ytips = 0.5* costs(:,1);
         labels = strcat('$',string(round(costs(:,1),1)),"M");
         %text(xtips,ytips,labels,'HorizontalAlignment','center',...
         %    'VerticalAlignment','middle','FontSize',12)

    end
    
    title({strcat("Discount Rate: ", disc, "%")}, 'FontSize',14)
    %t.Padding = 'compact';
    t.TileSpacing = 'none';
    font_size = 15;
    ax = gca;
    %ax.XGrid = 'on';
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size,'TitleFontSizeMultiplier',1.2)
    %set(allaxes,'FontSize', font_size)
    %set(findall(allaxes,'type','text'),'FontSize', font_size)
    
    %legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','southoutside','Orientation','horizontal')
    hold on
    if d==3
        b_null = plot([0 0.25],[0 0], 'LineStyle', 'none');
        legend({'Initial Dam Cost','Dam Expansion Cost','Shortage Cost'},'Location','northwest','FontSize',11)
        
        set(gca, 'XTick', [1,2,3,4.2,5.2,6.2])
        
        set(gca,'XTickLabel',{strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning'),...
            strcat('Static Design'),...
            strcat('Flexible Design'),...
            strcat('Flexible Planning')})
        
        text(1.5, -80, "Static Operations",'FontSize',15,'FontWeight','bold')
        text(4.66, -80, "Flexible Operations",'FontSize',15,'FontWeight','bold')
        
        hold on
        ah1=axes('position',get(gca,'position'),'visible','off');
        
    else
            xticks([1,2,3,4.2,5.2,6.2])
            xticklabels([])
    end
end
        
    title(t,{'Mean Simulated Discounted Costs by 2100 for Dry Final Climates (66-76 mm/mo)'},'FontWeight','bold','Fontsize',15)
    ylabel(t,'Mean Discounted Simulated Cost (M$)','FontWeight','bold','FontSize',14)

    
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

    


%% NOT USED PLOTS BELOW
% ========================================================================
    %%  Average total infrastructure by 2100 by CLIMATE

if discountCost == 0
    
    f = figure();
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
    for p = 1:length(P_regret)
            
            s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
                (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
            
            s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
                (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
            
            [R,~,~] = size(action_P); %size(action{1});
            % forward simulations of shortage and infrastructure costs
            totalCost_adapt = squeeze(mean(sum(totalCostTime_adapt(ind_P,:,1:3),2)))/1E6;% 1 is flex, 2 is static
            totalCost_nonadapt = squeeze(mean(sum(totalCostTime_nonadapt(ind_P,:,1:3),2)))/1E6;% 1 is flex, 2 is static
            damCost_adapt = squeeze(mean(sum(damCostTime_adapt(ind_P,:,1:3),2)))/1E6;% 1 is flex, 2 is static
            damCost_nonadapt = squeeze(mean(sum(damCostTime_nonadapt(ind_P,:,1:3),2)))/1E6;% 1 is flex, 2 is static
            initCost_adapt = squeeze(mean(damCostTime_adapt(ind_P,1,1:3))/1E6);
            initCost_nonadapt = squeeze(mean(damCostTime_nonadapt(ind_P,1,1:3))/1E6);
            expCost_adapt = damCost_adapt - squeeze(mean(damCostTime_adapt(ind_P,1,1:3))/1E6);
            expCost_nonadapt = damCost_nonadapt - squeeze(mean(damCostTime_nonadapt(ind_P,1,1:3))/1E6);

            % Shortage Cost Time: select associated simulations
            shortageCost_adapt = totalCost_adapt(:,:,:)-damCost_adapt(:,:,:);
            shortageCost_nonadapt = totalCost_nonadapt(:,:,:)-damCost_nonadapt(:,:,:);
            
            % PLOT
            subplot(2,3,p)
%             allRows_comb = zeros(5,6,2);
%             for i = 1:5
%                 allRows_comb(i,1:6,1) = mean([damCost_nonadapt(:,i,2), damCost_adapt(:,i,2),...
%                     damCost_nonadapt(:,i,1), damCost_adapt(:,i,1), damCost_nonadapt(:,i,3), damCost_adapt(:,i,3)]);
%                 allRows_comb(i,1:6,2) = mean([ shortageCost_nonadapt(:,i,2), shortageCost_adapt(:,i,2),...
%                     shortageCost_nonadapt(:,i,1), shortageCost_adapt(:,i,1), shortageCost_nonadapt(:,i,3), shortageCost_adapt(:,i,3)]);
%             end
              hd = bar([[initCost_nonadapt(2), initCost_adapt(2),initCost_nonadapt(1), initCost_adapt(1), initCost_nonadapt(3), initCost_adapt(3)];[expCost_nonadapt(2), expCost_adapt(2),expCost_nonadapt(1), expCost_adapt(1), expCost_nonadapt(3), expCost_adapt(3)]]','stacked')
              ylim([0, 150])
              subplot(2,3,p+3)
              hs = bar([shortageCost_nonadapt(2), shortageCost_adapt(2),shortageCost_nonadapt(1), shortageCost_adapt(1), shortageCost_nonadapt(3), shortageCost_adapt(3)])
                ylim([0,400])
              %h = plotBarStackGroups(allRows_comb,decade_short);
%             for i = 1:6
%                 h(i,1).FaceColor = facecolors(i,:);
%                 h(i,2).FaceColor = [211,211,211]/255;
%             end
            %xticklabels(decade_short)
            xlabel('Time Period','FontWeight','bold')
            ylabel('Expected Cost (M$)','FontWeight','bold')
            %ylim([0, 110])
            title(strcat("Discount Rate: ", disc_vals(d),"%"),'FontWeight','bold')
            box on
            grid on
            
            if p == 1
                title(strcat('Dry Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            elseif p == 2
                title(strcat('Moderate Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            else
                title(strcat('Wet Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
                labels = {'Never' decade{:}};
                legend(b, labels, 'Location','northeast')
            end
            
        end
        sgtitle("Expected Cost vs. Time")
        ax = gca;
        
end
    
%% Overall total dam and shortage costs for each discount rate and flexible alternative (I THINK THIS DOES NOT MAKE SENSE...)

if discountCost == 1
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
end

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



%% Load data: update data to load

% change default font style
set(groot,'defaultAxesFontName','Futura')

folder = 'Nov02optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam')
mkdir('Plots/multiflex_comb')

load(strcat(folder,'/BestFlex_adaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15.mat'))
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


load(strcat(folder,'/BestFlex_nonadaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15.mat'))
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

% == ZOOM IN OF DRY CLIMATE COSTS ==
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
title('Zoomed CDF: Dry Climate')
box on
grid off
ax = gca;
ax.LineWidth = 2;

%xlim([150,1800])

font_size = 18;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)

% == ZOOM IN OF WET CLIMATE COSTS ==
f = figure;
percentiles = [0;50];

for i = 1
ptile = percentiles(2,i);
p3 = patch( [minCostPnow_all(3) minCostPnow_all(3) maxCostPnow_all(3) maxCostPnow_all(3)],  [0 1 1 0], [154,154,154]/255,'LineStyle','none');
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
xlim([prctile(totalCostStatic_adapt/1E6, percentiles(1,i)),103])
title('Zoomed CDF: Wet Climate')
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

%% Plot the CDF (full and zoomed for 95th percentile). Also show range of 

set(groot,'defaultAxesFontName','Futura')

folder = 'Jan28optimal_dam_design_comb'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam')
mkdir('Plots/multiflex_comb')

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
   
    % Find simulations with this level of precip
    ind_P_adapt = logical(sum((P_state_adapt(:,end) == P_regret),2));
    ind_P_nonadapt = logical(sum((P_state_nonadapt(:,end) == P_regret),2));
       
    % total costs
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:);
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:);
   
    % min total costs
    minCostPnow_adapt = min(totalCostPnow_adapt,[],'all');
    minCostPnow_nonadapt = min(totalCostPnow_nonadapt,[],'all');
    minCostPnow_all(j) = min([minCostPnow_adapt,minCostPnow_nonadapt])/1E6;
    
    % max total costs
    maxCostPnow_adapt = max(totalCostPnow_adapt,[],'all');
    maxCostPnow_nonadapt = max(totalCostPnow_nonadapt,[],'all');
    maxCostPnow_all(j) = max([maxCostPnow_adapt,maxCostPnow_nonadapt])/1E6;
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
title('Zoomed CDF: Wet Climates', 'FontWeight','bold')
box on
grid off
ax = gca;
ax.LineWidth = 2;

%xlim([150,1800])

font_size = 18;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)

% == ZOOM IN OF 5- PERCENTILE COSTS ==
f = figure;
percentiles = [0;40];

for i = 1
ptile = percentiles(1,i);
p1 = patch( [minCostPnow_all(3) minCostPnow_all(3) maxCostPnow_all(3) maxCostPnow_all(3)],  [0 1 1 0], [154,154,154]/255,'LineStyle','none');
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
xlim([minCostPnow_all(3), maxCostPnow_all(3)])
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
title('Zoomed CDF: Dry Climates', 'FontWeight','bold')
end
end

%% C' senstivity: optimal dam design vs. c' with 3% discounting

folder = 'Jan28_cprime_sens'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

cps = [1e-8:1e-7:1e-6, 1e-6:2e-6:2.3e-5];
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

bestAct_Cprimes = zeros(length(cps),15,2); % first is non-adaptive, second is adaptive;
f = figure();

for d=1:3
    disc = string(discounts(d));
    for i=1:length(cps)
        c_prime = cps(i);
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        bestAct_Cprimes(i,:,1) = bestAct; % non-adaptive ops
        load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex75_percExp15_disc',disc,'.mat'))
        bestAct_Cprimes(i,:,2) = bestAct; % adaptive ops
    end
    
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
    title(strcat("Discount Rate: ",disc,"%"))
end

sgtitle("Optimal Dam Capacity vs. c'")
