
%% DiscountSensitivityPlots_Feb2.m

%% Description (Feb 2, 2022):
% This script performs data analysis and creates plots for testing the
% sensitivity of the Mwache Dam project to the discount rate, considering
% different c' parameter values in the shortage cost economic model.

% As of Feb 2, 2022: c' values of interest are c' = 1.25e-6 and c'=5e-6. We
% test the followingdiscount rates: 0%, 3%, and 6% under these two
% different c' parameter values.

%% Setup and Loading Data

% specify file naming convensions
discounts = [0, 3, 6];
cprimes = [1.25e-6 3.5e-6 3.75e-6 6e-6]; %[1.25e-6, 5e-6];
discountCost = 1; % if true, then use discounted costs, else non-discounted
fixInitCap = 0; % if true, then fix starting capacity always 60 MCM (disc = 6%)
maxExpTest = 0; % if true, then we always make maximum expansion 50% of initial capacity (try disc = 0%)

% specify file path for data
if fixInitCap == 0 && maxExpTest == 0
    folder = 'Jan28optimal_dam_design_comb';
else
    folder = 'Feb7optimal_dam_design_comb';
end
cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP/')

for d=1 %length(discounts)
    disc = string(discounts(d));
    for c = 1 %4%length(cprimes)
        cp = cprimes(c);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        % load adaptive operations files:
        if fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
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
        if fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex75_percExp15_disc',disc,'.mat'))
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
        labels = {strcat('$',string(round(infra_cost_nonadaptive.static(2))),'M'),...
            strcat('$',string(round(infra_cost_adaptive.static(2))),'M'),...
            strcat('$',string(round(infra_cost_nonadaptive.flex(2))),'M'),...
            strcat('$',string(round(infra_cost_adaptive.flex(2))),'M'),...
            strcat('$',string(round(infra_cost_nonadaptive.plan(2))),'M'),...
            strcat('$',string(round(infra_cost_adaptive.plan(2))),'M')};
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
    
    im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
        makehatch_plus('\\40',50), makehatch_plus('\',1), makehatch_plus('\\40',50), ...
        makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1),...
        makehatch_plus('\\40',50),makehatch_plus('\',1),makehatch_plus('\\40',50),makehatch_plus('\',1)},...
        [facecolors(2:4,:); facecolors_exp(4,:); facecolors(5,:); facecolors_exp(5,:); facecolors(6,:); facecolors_exp(6,:);...
        facecolors(7,:); facecolors_exp(7,:);facecolors(1,:); facecolors_exp(1,:)],[],300);
    
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
    
    % use consistent stacked color bar convention based on volume expanded
    nonadapt_plan_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    nonadapt_flex_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    adapt_plan_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    adapt_flex_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    
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
            if bestAct_nonadapt(3) == bestAct_nonadapt(8)
                cmap1 = [nonadapt_flex_colors(1+(bestAct_nonadapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_nonadapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_nonadapt(3)-minCap)/10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)-minCap)/10+(bestAct_nonadapt(3)-minCap)/10+1,:); nonadapt_plan_colors(2+(bestAct_nonadapt(8)-minCap)/10:(bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)-minCap)/10+(bestAct_nonadapt(8)-minCap)/10+1,:)]/255;
            else
                cmap1 = [nonadapt_flex_colors(1+(bestAct_nonadapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_nonadapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_nonadapt(3)-minCap)/10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)-minCap)/10+(bestAct_nonadapt(3)-minCap)/10+1,:); nonadapt_plan_colors(2+(bestAct_nonadapt(8)-minCap)/10:(bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)-minCap)/10+(bestAct_nonadapt(8)-minCap)/10+1,:)]/255;                
            end
        else % adaptive
            %cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
            cmap1 = [nonadapt_flex_colors(1+(bestAct_adapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_adapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_adapt(3)-minCap)/10:(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)-minCap)/10+(bestAct_adapt(3)-minCap)/10+1,:); nonadapt_plan_colors(2+(bestAct_adapt(8)-minCap)/10:(bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)-minCap)/10+(bestAct_adapt(8)-minCap)/10+1,:)]/255;
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
        set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
            'Static Ops.';'Flexible Ops.'},'FontSize',22)
        ylabel('Simulations (%)','FontSize',22);
        
        % create legend labels based on either flex design  or flex
        % planning (whichever has more expansion options)
        %if s == 1 % non-adaptive
        
    end
    
    % make legend from psuedo-bar containing all possible values
    b1 = bar(6, [minCap:10:max(maxFlex, maxPlan)]', 'stacked','FaceColor','flat',...
        'LineWidth',1); % expansion by the final time period
    
    for i=1:length(b1) % recolor
        b1(i).FaceColor = nonadapt_flex_colors(i,:)/255;
    end
    h=get(gca,'Children');
    capState = strcat(string([minCap:10:max([maxPlan, maxFlex])]), " MCM");
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    l.ItemTokenSize(1) = 60;
    %l.Position = l.Position + [-0.15 -0.15 0 0.05];
    box on
    
    xlim([1.5, 5.5])
    
    
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
                plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s),:),'LineWidth',2)
            else
                plot(1:5, expanded, 'Color', facecolors((2*(type-1)+s),:),'LineWidth',2,'LineStyle','--')
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
    
    %% Extent of Volume Expansion by End of Planning Period CLIMATE TRANSITION
    
    f = figure;
    
    nonadapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    nonadapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_plan_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    adapt_flex_colors = [[150, 150, 150];[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173]];
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
    %clear cPnowCounts cPnowCounts_test
    for p = 1:length(P_regret)
        
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
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
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
            if p == 3
                set(gca, 'XTick', [2 3 4 5])
                set(gca,'XTickLabel',{'Static Ops.';'Flexible Ops.';...
                    'Static Ops.';'Flexible Ops.'},'FontSize',9.5)
            else
                set(gca, 'XTick',[],'FontSize',9.5)
            end
            
            if p == 1
                title(strcat('Dry Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            elseif p == 2
                title(strcat('Moderate Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            else
                title(strcat('Wet Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
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
    
    % use consistent stacked color bar convention based on volume expanded
    nonadapt_plan_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    nonadapt_flex_colors = [[222,235,247];[146, 180, 210];[50,124,173];[45, 101, 152];[28,82,119];[29, 63, 78]];
    adapt_plan_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    adapt_flex_colors = [[222,235,247];[175,201,219];[128,167,190];[97,148,177];[70,124,173];[45, 101, 152];[28,82,119]];
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
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
    for p = 1:length(P_regret)
        
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
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
            action_P = action(ind_P,:,:);
            
            [R,~,~] = size(action_P); %size(action{1});

        
        clear cmap
        if s == 1 % nonadaptive
            if bestAct_nonadapt(3) == bestAct_nonadapt(8)
            %cmap1 = [[150, 150, 150]; [150, 150, 150]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
                cmap = [nonadapt_flex_colors(1+(bestAct_nonadapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_nonadapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_nonadapt(3)-minCap)/10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)-minCap)/10+(bestAct_nonadapt(3)-minCap)/10,:); nonadapt_plan_colors(2+(bestAct_nonadapt(8)-minCap)/10:(bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)-minCap)/10+(bestAct_nonadapt(8)-minCap)/10,:)]/255;
            else
                cmap = [nonadapt_flex_colors(1+(bestAct_nonadapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_nonadapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_nonadapt(3)-minCap)/10:(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)-minCap)/10+(bestAct_nonadapt(3)-minCap)/10+1,:); nonadapt_plan_colors(2+(bestAct_nonadapt(8)-minCap)/10:(bestAct_nonadapt(8)+ bestAct_nonadapt(9)*bestAct_nonadapt(10)-minCap)/10+(bestAct_nonadapt(8)-minCap)/10+1,:)]/255;
            end                
        else % adaptive
            %cmap1 = [[150, 150, 150]; [150, 150, 150]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
            cmap = [nonadapt_flex_colors(1+(bestAct_adapt(3)-minCap)/10,:); nonadapt_plan_colors(1+(bestAct_adapt(8)-minCap)/10,:); nonadapt_flex_colors(2+(bestAct_adapt(3)-minCap)/10:(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)-minCap)/10+(bestAct_adapt(3)-minCap)/10+1,:); nonadapt_plan_colors(2+(bestAct_adapt(8)-minCap)/10:(bestAct_adapt(8)+ bestAct_adapt(9)*bestAct_adapt(10)-minCap)/10+(bestAct_adapt(8)-minCap)/10+1,:)]/255;
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
                subplot(3,1,p)
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
                title(strcat('Dry Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            elseif p == 2
                title(strcat('Moderate Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
            else
                title(strcat('Wet Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
                % create legend labels based on either flex design  or flex
                % planning (whichever has more expansion options)
                largest_dS = max([bestAct_nonadapt(4),bestAct_adapt(4),bestAct_nonadapt(9),bestAct_adapt(9)]);
%                 clear labels
%                 for z = 1:largest_dS
%                     labels(z) = {strcat("Exp:+", num2str(z*10)," MCM")};
%                 end
%                 h=get(gca,'Children');
% 
%                 l = legend(b1,capState,'Location','northeast','FontSize',9.5,'AutoUpdate','off');
            end
        end
    end
    
    % make legend from psuedo-bar containing all possible values
    b1 = bar(6, [minCap:10:max(maxFlex, maxPlan)]', 'stacked','FaceColor','flat',...
        'LineWidth',1); % expansion by the final time period
    
    for i=1:length(b1) % recolor
        b1(i).FaceColor = nonadapt_flex_colors(i,:)/255;
    end
    h=get(gca,'Children');
    capState = strcat(string([minCap:10:max([maxPlan, maxFlex])]), " MCM");
    l = legend(b1,capState,'Orientation','horizontal',...
        'Location','southoutside','FontSize',10,'AutoUpdate','off');
    l.ItemTokenSize(1) = 60;
    %l.Position = l.Position + [-0.15 -0.15 0 0.05];
    box on
    
    xlim([1.5, 5.5])
    
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
    
    %% Bar Timing of Expansion by End of Planning Period by CLIMATE
    
    f = figure;
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
    clear cPnowCounts cPnowCounts_test
    for p = 1:length(P_regret)
        
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
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
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
            title(strcat('Dry Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
        elseif p == 2
            title(strcat('Moderate Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
        else
            title(strcat('Wet Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
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
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
    facecolors = [[153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    clear cPnowCounts cPnowCounts_test
    for p = 1:length(P_regret)
        
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
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
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
            title(strcat('Dry Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
        elseif p == 2
            title(strcat('Moderate Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
        else
            title(strcat('Wet Final Climate State (', string(P_regret(p)),'mm/mo)'),'FontSize',12)
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
    
    P_regret = [72 79 87]; % reference dry, moderate, and wet climates
    
    clear cPnowCounts cPnowCounts_test
    cPnowCounts = cell(2,2);
    for p = 1:length(P_regret)
        
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
            
            ind_P = (P_state_adapt(:,end) == P_regret(p));
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
                title({strcat("Flexible Design (", string(P_regret(p))," mm/mo)"),''},'FontSize',13)
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
                title({strcat("Flexible Planning (", string(P_regret(p))," mm/mo)");''},'FontSize',13)
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
    
end
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
