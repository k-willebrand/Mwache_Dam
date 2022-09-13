%% Load the data
%% Setup and Loading Data

% specify file naming convensions

discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 7.5E-7 3.5e-6 3.75e-6 6e-6 1.72 2.45]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for dat
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
    
    %% Sample forward simulation by CLIMATE (non-discounted line)
    if d==1
        f = figure();
    end
    folder = 'Nov02post_process_sdp_reservoir_results';
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [{72}]; % dry, moderate, wet
    
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
        
        % == UNIQUE P STATE TRANSITIONS ==
        [uP, uPIdxs, ~] = unique(Pnow_adapt, 'rows','stable'); % use these when calling subsetted matrix
        uPIdxAll = ind_P_adapt(uPIdxs); % use these indices when calling 10000 matrix
        
        % PLOTS
        if p==1 % dry plot index
            idxP = uPIdxs(83); % 199 %(2) (179) Stable: 85
            idxPall = uPIdxAll(83);
        elseif p == 2 % moderate plot index
            idxP = uPIdxs(85); %(5);
            idxPall = uPIdxAll(85);
        elseif p == 3 % wet plot index
            idxP = uPIdxs(60); %(3); 25
            idxPall = uPIdxAll(60); % 25 199
        else
            idxP = uPIdxs(179); %(3); 25
            idxPall = uPIdxAll(179); % 25 199
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
                damCostPnowStatic_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,2)+1);
                damCostPnowStatic_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,2)+1);
                damCostPnowFlex_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,1)+1);
                damCostPnowFlex_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,1)+1);
                damCostPnowPlan_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,3)+1);
                damCostPnowPlan_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,3)+1);
                
                % corresponding shortage cost at that time and P state
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(staticCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(flexCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(planCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49)/1E6; % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
            end
        end
        
        % plot dam capacity vs time:
        subplot(3,3,1+(d-1)*3)
        damCap_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
            s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
            s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
        %yyaxis left
        %b = bar(1:5, damCap_comb,'facecolor','flat');
        for i = 1:6
            if mod(i,2) == 0
                plot(0:4, damCap_comb(i,:),'color',facecolors(i,:),'LineStyle','--','LineWidth',2);
            else
                plot(0:4, damCap_comb(i,:),'color',facecolors(i,:),'LineStyle','-','LineWidth',2);
            end
            hold on
        end
        ylim([30,160])
        if d==3
            xticks([0, 1, 2, 3, 4])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
        else
            xticks([0, 1, 2, 3, 4])
            xticklabels([])
        end
        ylabel('Capacity (MCM)','FontWeight','bold')
                if d == 1
            title({'Dam Capacity vs. Time',strcat("Discount Rate: ",string(discounts(d)),"%")},'FontWeight','bold')
        else
            title(strcat("Discount Rate: ",string(discounts(d)),"%"),'Fontweight','bold')
        end
        grid on
        
        % plot dam infrastructure costs over time:
        subplot(3,3,2+(d-1)*3)
        damCosts_comb = zeros(5,6);
        for i = 1:5
            damCosts_comb(i,1:6) = [damCostPnowStatic_nonadapt(i), damCostPnowStatic_adapt(i),...
                damCostPnowFlex_nonadapt(i), damCostPnowFlex_adapt(i), damCostPnowPlan_nonadapt(i), damCostPnowPlan_adapt(i)];
        end
        yyaxis left
        if discountCost == 1
            h = bar(1:5, damCosts_comb);
            for i = 1:6
                h(i).FaceColor = facecolors(i,:);
            end
        else
            for i=1:6
                if mod(i,2) == 0 % adaptive ops
                    plot(0:4, damCosts_comb(:,i), 'color', facecolors(i,:), 'LineWidth', 2, 'LineStyle','--','Marker', 'none');
                else
                    plot(0:4, damCosts_comb(:,i), 'color', facecolors(i,:), 'LineWidth', 2, 'LineStyle','-','Marker', 'none');
                end
                hold on
            end
        end
        if d==3
            xticks([0, 1, 2, 3, 4])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
        else
            xticks([0, 1, 2, 3, 4])
            xticklabels([])
        end
        ylabel('Cost (M$)','FontWeight','bold')
        if d == 1
            title({'Infrastructure Cost vs. Time',strcat("Discount Rate: ",string(discounts(d)),"%")},'FontWeight','bold')
        else
            title(strcat("Discount Rate: ",string(discounts(d)),"%"),'Fontweight','bold')
        end
        grid on
        ylim([0,102])
        
        % add line for precipitation state over time on secondary axis:
        yyaxis right
        hold on
        p1 = plot(0:4, P_state(idxPall,:),'color','black','LineWidth',1.5);
        ylabel('P State (mm/mo)')
        ylim([65,95]);
        legend(p1,"Precip. state",'Box','off')
        %xlim([0.5,5.5])
        box on
        
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        % Plot shortage cost vs time
        subplot(3,3,3+(d-1)*3)
        yyaxis left
        shortageCosts_comb = zeros(5,6);
        for i = 1:5
            shortageCosts_comb(i,1:6) = [ shortageCostPnowStatic_nonadapt(i), shortageCostPnowStatic_adapt(i),...
                shortageCostPnowFlex_nonadapt(i), shortageCostPnowFlex_adapt(i), shortageCostPnowPlan_nonadapt(i), shortageCostPnowPlan_adapt(i)];
        end
        if discountCost == 1
            h = bar(1:5, shortageCosts_comb);
            for i = 1:6
                %h(i).FaceColor = [211,211,211]/255;
                h(i).FaceColor = facecolors(i,:);
            end
        else
            %h = bar(1:5, damCosts_comb/1E6);
            for i=1:6
                if mod(i,2) == 0 % adaptive ops
                    h(i) = plot(0:4, shortageCosts_comb(:,i), 'Color', facecolors(i,:), 'LineWidth', 2, 'LineStyle','--','Marker','none');
                else
                    h(i) = plot(0:4, shortageCosts_comb(:,i), 'Color', facecolors(i,:), 'LineWidth', 2, 'LineStyle','-','Marker','none');
                end
                hold on
            end
        hold on
        end
        hold on
        if d==3
            xticks([0, 1, 2, 3, 4])
            xticklabels(decade_short)
            xlabel('Time Period','Fontweight','bold')
        else
            xticks([0, 1, 2, 3, 4])
            xticklabels([])
        end
        grid on
        ylabel('Cost (M$)','FontWeight','bold')
        if d == 1
            title({'Simulated Shortage Cost vs. Time',strcat("Discount Rate: ",string(discounts(d)),"%")},'FontWeight','bold')
        else
            title(strcat("Discount Rate: ",string(discounts(d)),"%"),'Fontweight','bold')
        end
        ylim([0,400])
        
        
        % add line for precipitation state over time on secondary axis:
        yyaxis right
        hold on
        p1 = plot(0:4,Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5);
        leg1 = legend(p1,"Precip. state",'Box','off','AutoUpdate','off');
        ylabel('P State (mm/mo)')
        ylim([65,95]);
        %xlim([0.5,5.5])
        box on
        
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        
        
        % add legend:
        if d == 3
            hold on
            axes('position',get(gca,'position'),'visible','off');
%             hL = legend([h(1), h(2), h(3), h(4), h(5), h(6)],{strcat("Static Design & Static Ops."),strcat("Static Design & Flexible Ops."),...
%                 strcat("Flexible Design & Static Ops"),...
%                 strcat("Flexible Design & Flexible Ops"),strcat("Flexible Planning & Static Ops"),...
%                 strcat("Flexible Planning & Flexible Ops")},...
%                 'NumColumns',3,'Orientation','horizontal', 'FontSize', 9,'box','on');
            
                hL = legend([h(1), h(3), h(5), h(2), h(4), h(6)],{strcat("Static Design & Static Ops."),...
                    strcat("Flexible Design & Static Ops"),...
                    strcat("Flexible Planning & Static Ops"),strcat("Static Design & Flexible Ops."),...
                    strcat("Flexible Design & Flexible Ops"),strcat("Flexible Planning & Flexible Ops")},...
                    'NumColumns',3,'Orientation','horizontal', 'FontSize', 9,'box','on');

            % Programatically move the Legend
            newPosition = [0.4 0.05 0.2 0];
            newUnits = 'normalized';
            set(hL,'Position', newPosition,'Units', newUnits);
        end
    end
    
    sgtitle(strcat("Sample Forward Similations with Final Climate", string(P_regret(1))," mm/mo"),'FontSize',16, 'FontWeight','bold')
    
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

% ========================================================================
 %% BOXPLOT Total Costs vs. Time for discounts: 
 
 %Setup and Loading Data

% specify file naming convensions

discounts = [0, 3, 6];
cprimes = [2e-7 2.85e-7 1.25e-6 7.5E-7 3.5e-6 3.75e-6 6e-6 1.72 2.45]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for dat
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
            xticks([0, 1, 2, 3, 4])
            xticklabels(decade_short)
            xlabel(t,'Time Period','Fontweight','bold')
            ylabel(t,'Non-Discounted Cost (M$)','FontWeight','bold')
            
            legend([p1 meds(1)],{'Mean','Median'},'Location','northwest')
        else
            xticks([0, 1, 2, 3, 4])
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
       
%% Sample forward simulation by CLIMATE (stacked bar)
    
    f = figure();
    folder = 'Nov02post_process_sdp_reservoir_results';
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [72 74 79 87 72]; % dry, moderate, wet
    
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
        [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(1));
        [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(1));
        
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
            idxP = uPIdxs(199); %(2) (179) Stable: 85
            idxPall = uPIdxAll(199);
        elseif p == 2 % moderate plot index
            idxP = uPIdxs(85); %(5);
            idxPall = uPIdxAll(85);
        elseif p == 3 % wet plot index
            idxP = uPIdxs(60); %(3); 25
            idxPall = uPIdxAll(60); % 25 199
        else
            idxP = uPIdxs(179); %(3); 25
            idxPall = uPIdxAll(179); % 25 199
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
                damCostPnowStatic_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,2)+1);
                damCostPnowStatic_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,2)+1);
                damCostPnowFlex_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,1)+1);
                damCostPnowFlex_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,1)+1);
                damCostPnowPlan_adapt(i) = infra_cost_adaptive_lookup(ActionPnow_adapt(idxP,i,3)+1);
                damCostPnowPlan_nonadapt(i) = infra_cost_nonadaptive_lookup(ActionPnow_nonadapt(idxP,i,3)+1);
                
                % corresponding shortage cost at that time and P state
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(staticCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(flexCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat(string(folder),'/sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat(string(folder),'/sdp_adaptive_shortage_cost_s',string(planCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
            end
        end
        
        % plot dam capacity vs time:
        subplot(3,4,p)
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
        title({strcat(string(P_state(idxPall,1))," mm/mo");'Dam Capacity vs. Time'},'FontWeight','bold')
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
        subplot(3,4,p+4)
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
        subplot(3,4,p+8)
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
        l1 = yline(infra_cost_adaptive_lookup(5)/1E6, '--', 'color', facecolors(3,:), 'LineWidth',2);
        hold on
        l2 = yline(infra_cost_nonadaptive_lookup(5)/1E6, 'color',facecolors(3,:), 'LineWidth',2);
        hold on
        l3=yline(infra_cost_adaptive_lookup(5+bestAct_adapt(4))/1E6, '--','color', facecolors(5,:), 'LineWidth',2);
        hold on
        l4=yline(infra_cost_nonadaptive_lookup(5+bestAct_nonadapt(4))/1E6,'color', facecolors(5,:), 'LineWidth',2);        
        xticklabels(decade_short)
        grid on
        xlabel('Time Period','FontWeight','bold')
        ylabel('Cost (M$)','FontWeight','bold')
        title('Simulated Shortage Cost vs. Time','FontWeight','bold')
        
        
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
    
    sgtitle({strcat("Discount Rate: ", string(discounts(d)),"%");"Sample Forward Similations with Final Climate 72 mm/mo"},'FontSize',16, 'FontWeight','bold')
    
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
    