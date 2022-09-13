

%% Setup and Loading Data

% specify file naming convensions
discounts = [0, 3, 6];
cprimes = 6.40E-8; %[2.32E-7]; %[1.25e-6, 5e-6];
discountCost = 0; % if true, then use discounted costs, else non-discounted
newCostModel = 0; % if true, then use a different cost model
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 1; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0
    folder = 'Apr12optimal_dam_design_comb';
else
    folder = 'Apr12optimal_dam_design_comb';
end
%cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1 %length(discounts)
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

   % plot the expansion cost models for these different alternative
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
    plot(infra_cost_adaptive.flex(1,:),infracost,'--o','LineWidth',2,...
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
    plot(infra_cost_adaptive.plan(1,:),infracost,'--o','LineWidth',2,...
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
    plot(infra_cost_adaptive.static(1,:),infracost,'--o',...
        'MarkerFaceColor',facecolors(2,:),'Color',facecolors(2,:),'LineWidth',2,...
        'DisplayName','Static Design & Flexible Ops','MarkerSize',5)
    xlabel('Installed Dam Capacity (MCM)','FontWeight','bold')
    ylabel('Installed Infrastructure Cost (M$)','FontWeight','bold')
    legend('location','northwest')
    grid 'minor'
    grid 'on'
    xlim([105,155])
    title('Installed Infrastructure Cost vs. Installed Dam Capacity',...
        'FontWeight','bold','FontSize',13)
    
%% Alternative policy visualization since T state is deterministic: [4,1]


% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [180, 180, 231];...
    [255, 102, 102]; [255, 153, 153]]/255;
%expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;
%expansion_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]]/255;
expansion_colors = [[205,213,223];[167,208,241];[113,161,193];[39,76,119];[20,37,62]]/255;
s_P_abs = 66:1:97;
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C

f = figure('WindowState','maximized');
t = tiledlayout(2,1);
t.TileSpacing = 'compact';
%t.Padding = 'compact';

for s=1 % adapt vs non-adapt
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
    minStor_all = min([bestAct_nonadapt(3), bestAct_nonadapt(8)]);
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
            ax = nexttile
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
            map = expansion_colors(2+(min(X_newFlex',[],'all')-minStor_all)/10:2+(min(X_newFlex',[],'all')-minStor_all)/10+bestAct(4),:);  
            %map = expansion_colors(1+(min(X_newFlex',[],'all')-minStor_all)/10:1+(min(X_newFlex',[],'all')-minStor_all)/10,:);          

        else
            %ax = subplot(1,4,2+2*(s-1));
            ax = nexttile
            imagesc(1:5,s_P_abs,X_newPlan')
            xticks(1:5)
            xticklabels([])
            %yticklabels(decade_short)
            if s == 1
                title("Flexible Planning & Static Ops.",'FontWeight','bold','Color',facecolors(5,:))
                 xticklabels({decade_short{1:5}})
            else
                title("Flexible Planning & Flexible Ops.",'FontWeight','bold','Color',facecolors(6,:))
                xticklabels({decade_short{1:5}})
            end
            map = expansion_colors(2+(min(X_newPlan',[],'all')-minStor_all)/10:2+(min(X_newPlan',[],'all')-minStor_all)/10+bestAct(9)-1,:);       
            %map = expansion_colors(1+(min(X_newPlan',[],'all')-minStor_all)/10:1+(min(X_newPlan',[],'all')-minStor_all)/10+1,:);       
            %map = expansion_colors(1+(min(X_newPlan',[],'all')-minStor_all)/10:1+(min(X_newPlan',[],'all')-minStor_all)/10+1,:);       
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
            %hold on
            %p1 = plot(P_state(idxs(i),:),'color','black','LineWidth',0.8);
            %p1 = scatter(1:5,P_state(idxs(i),:),5,'black','filled','MarkerEdgeColor','black');
            %labs = string(P_state(idxs(i),:));
            %text([1:5]-0.01,P_state(idxs(i),:)+2,labs,'Fontsize', 8)
        %end
        
    
    if s == 1 && q ==1
        %h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
        %    'TickLabels',["Do Not\newlineExpand","Expand"]);
        h = colorbar('TicksMode','manual','Ticks',[min(stor)+(max(stor)-min(stor))/8.5:(max(stor)-min(stor))/4:max(stor)],...
           'TickLabels',[strcat(string(min(stor):10:max(stor)),"\newlineMCM")]);
        h.Location = 'eastoutside';
        hpos = get(h, 'Position');
        h.Position = [0.92 0.11 0.015 0.81];
    end
end

    title(t,"Infrastructure Expansion Policies",'FontWeight','bold','FontSize',15)
    xlabel(t, "Time Period",'FontWeight','bold')
    ylabel(t, "Mean Precipitation [mm/mo]",'FontWeight','bold')
end

%% (Apr 11) Shortage Cost vs. Climate State Plots for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
f=figure();
tile = tiledlayout(2,3);
title(tile,{'Non-Adaptive Shortage Cost vs. Dam Storage'},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Shortage Cost (M$)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

for j=1:3 % for Nov02, Apr06, and Apr08 results:
    if j==3
        folder = 'Data/Nov02post_process_sdp_reservoir_results/';
    elseif j==2
        %folder = 'Data/Apr06post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12v2post_process_sdp_reservoir_results/';
        folder = 'Data/Apr12v3post_process_sdp_reservoir_results_IncVar/';
    %elseif j==1
        %folder = 'Data/Apr08post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12post_process_sdp_reservoir_results/';
    %elseif j==3
        %folder = 'Data/Apr11post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12v3post_process_sdp_reservoir_results/';
    else
        %folder = 'Data/Apr08post_process_sdp_reservoir_results/';
        folder = 'Data/Apr12v3post_process_sdp_reservoir_results_IncVar/';
    end
    storages = 50:10:150;
    %pstates = 66:4:97;
    pstates = [58,62,66,70,74,78]; % subset of precipitation states
    if j==3
        cprime = 1.25e-6;
    elseif j==2
        cprime = 1.77e-7;
    else
        cprime = 2.32e-7;
    end
    scost = cell(length(s_T_abs),2);
    
    % make data matrix for plots
    for t=1:length(s_T_abs)
        tidx = t;
        scost_nonadapt = zeros(length(storages),length(pstates));
        scost_adapt = zeros(length(storages),length(pstates));
        for p=1:length(pstates)
            pidx = ismember(s_P_abs,pstates(p));
            %if j==3
                %pidx = ismember(s_P_abs,pstates(p));
            %else
                %pidx = p;
            %end
            for s = 1:length(storages)
                s_now = storages(s);
                
                % load the data
                %load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
                %scost_nonadapt_all = shortageCost;
                load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
                scost_adapt_all = shortageCost;
                
                % save shortage cost in new matrix
                %scost_nonadapt(s,p) = scost_nonadapt_all(tidx,pidx).*cprime;
                scost_adapt(s,p) = scost_adapt_all(tidx,pidx).*cprime;
                
            end
        end
        
        %scost{t,1} = scost_nonadapt;
        scost{t,2} = scost_adapt;
        
    end
    
    %cols = cbrewer('div','Spectral',length(s_T_abs));
    cols = [[0.6350 0.0780 0.1840];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];...
        [0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.4940 0.1840 0.5560]];
    
    clear splt
    for plt = 1:length(pstates)
        nexttile(plt)
        for t=1:2:5 %1:length(s_T_abs)
            %splt{t} = plot(storages, scost{t,1}(:,plt)/1E6,'-','Color',cols(t,:),...
            %    'DisplayName', strcat(string(s_T_abs(t)), " deg. C"));
            hold on
            if j==3
                splt{t} = plot(storages, scost{t,2}(:,plt)/1E6,'-','Color',cols(t,:),...
                    'DisplayName', strcat(string(s_T_abs(t)), " deg. C"),'LineWidth',1.5); % adaptive ops
                eval(['splt' num2str(plt) '= splt'])
            elseif j==2
                plot(storages, scost{t,2}(:,plt)/1E6,'--','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            elseif j==1
                plot(storages, scost{t,2}(:,plt)/1E6,'-.','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            %elseif j ==3
                %plot(storages, scost{t,2}(:,plt)/1E6,':','Color',cols(t,:),'LineWidth',1.5) % adaptive ops                
            end
            hold on
            grid(gca,'minor')
            grid('on')
        end
        xlim([50,150])
        %ylim([0,6E2])
        %xlabel('Dam Storage Capacity (MCM)')
        %ylabel('Shortage Cost (M$)')
        title(strcat("Precip. State: ",string(pstates(plt))," mm/mo"))
        box 'on'
    end
    if plt == length(pstates) && j==3
        l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-','LineWidth',1.5);
        hold on
        l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--','LineWidth',1.5);
        hold on
        l3 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-.','LineWidth',1.5);
        %hold on
        %l4 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle',':','LineWidth',1.5);        
        leglines = [splt{:}];
        leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),...
            'Location','NorthEast','FontSize',8);
        title(leg1,'Temp. State')
        leg1.Title.Visible = 'on';
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1, [l1 l3 l2], "02Nov2021 (c':1.25E-6)","12Apr2022 IncVar (c':2.32E-7)",...
            "12Apr2022 IncVar (c':1.77E-7)",'Location','SouthEast',...
            'FontSize',8);
        title(leg2,'Runoff Data File Date')
        leg2.Title.Visible = 'on';
    end
end


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
    minCap = min([bestAct_nonadapt(3), bestAct_nonadapt(8)]);
    maxCap = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5), ...
        bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)]);
    maxPlan = max([bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)]);
    maxFlex = max([bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)]);
    
    %clear cPnowCounts cPnowCounts_test
    for p = 1:length(P_ranges)
        P_regret = P_ranges{p};
        
        for s = 1 % for non-adaptive and adaptive operations
            
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
            
            ind_P = logical(sum((P_state_nonadapt(:,end) == P_regret),2));
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
                    b1 = bar(2, [cPnowCounts(5,[2, 4:3+bestAct(4)])]', 'stacked');
                    cmap1 = cmap([1 3:2+bestAct(4)],:);
                    for i=1:length(b1) % recolor
                        b1(i).FaceColor = cmap1(i,:);
                    end
                else
                    b1 = bar(3,[cPnowCounts(5,[3, 4+bestAct(4):end])]', 'stacked');
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
            
            xlim([1.5 3.5])
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
    
    
    