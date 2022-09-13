%% Plot: Shortage and Infrastructure Costs by P state for Different Scenarios

% load the data:
folder1 = 'Nov02post_process_sdp_reservoir_results';

storages = 50:20:150; % dam capacities to plot
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
cprime = 1.25E-6; %1.25E-6;

% calculate non-discounted infrastructure costs using storage2damcost:
% load optimal infrastructure information
infra_costs = struct();
infra_costs.static = NaN(length(storages),2);
infra_costs.flex = NaN(length(storages),6);

% plot all shortage costs vs. initial infrastructure cost
storagecolors = {[0.6350 0.0780 0.1840] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
    [0.4660 0.6740 0.1880] [0 0.4470 0.7410] [0.4940 0.1840 0.5560]};
cprime = 1.25E-6;
figure
for i=1:length(storages)
    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(storages(i))));
    p(i) = plot(s_P_abs, shortageCost(1,:)*cprime/1E6,'Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
    load(strcat(folder1,'/sdp_adaptive_shortage_cost_s',num2str(storages(i))));
    plot(s_P_abs, shortageCost(1,:)*cprime/1E6,'Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5,'LineStyle','--');
    hold on
end
xlabel('Precipitation State (mm/mo)','Fontweight','bold')
ylabel('Shortage Costs (M$)','fontweight','bold')
title('Shortage Cost vs. Precipitation State','FontWeight','bold')
leg1 = legend(p(:));
title(leg1,'Dam Capacity')
grid 'minor'
grid on
box 'on'
hold off
xlim([66, 97])

ah1=axes('position',get(gca,'position'),'visible','off');
hold on
p1 = plot([0 1],[0 0],'LineStyle','-','Color',[17 17 17]/255,...
    'DisplayName','Static Ops.');
hold on
p2 = plot([0 1],[0 0],'LineStyle','--','Color',[17 17 17]/255,...
    'DisplayName','Flexible Ops.');
ylim([10 12])
leg2=legend(ah1,'autoupdate','off');
title(leg2, 'Dam Operations' );
xlim([66, 97])




figure
t = tiledlayout(2,3,'TileSpacing','compact');
storages = 50:30:110; % dam capacities to plot
for type = 1:2 % 1 is flex design, 2 is flex planning
    for s=1:length(storages)
        costParam.discountrate = 0;
        optParam.staticCap = storages(s); % static dam size [MCM]
        
        if type == 1 % flexible design
            optParam.smallCap = storages(s);
            optParam.ExpIncr = 10; % increment of flexible expansion capacities [MCM]
            optParam.numExp = ((min(ceil(1.5*optParam.smallCap/10)*10,150))-optParam.smallCap)/...
                optParam.ExpIncr;  % number of possible expansion capacities [#]
            costParam.PercFlex = 0.05; % Initial upfront capital cost increase (0.075)
            costParam.PercExp = 0.01; % Expansion cost of flexible dam  (0.15)
        else % flexible planning
            optParam.smallCap = storages(s); % unexpanded flexible planning dam size [MCM]
            optParam.ExpIncr = 10;
            optParam.numExp = ((min(ceil(1.5*optParam.smallCap/10)*10,150))-optParam.smallCap)/...
                optParam.ExpIncr;  % number of possible expansion capacities [#]
            costParam.PercFlex = 0; % initial upfront capital cost increase (0);
            costParam.PercExp = 0.50; % expansion cost of flexibly planned dam (0.5)
        end
        
        s_C = 1:3+optParam.numExp;
        M_C = length(s_C);
        
        storage = zeros(1, M_C);
        storage(1) = optParam.staticCap;
        storage(2) = optParam.smallCap; % initial storage flex design or plan
        %storage(3) = optParam.smallCap;
        storage(3:2+optParam.numExp) = min(storage(2) + (1:optParam.numExp)*optParam.ExpIncr, 150);
        
        % Actions: Choose dam option in time period 1; expand dam in future time periods
        a_exp = 0:2+optParam.numExp;
        
        % Define infrastructure costs
        infra_cost = zeros(1,length(a_exp)); % no exp, static, small cap, exp cap costs
        infra_cost(2) = storage2damcost(storage(1),0); % cost of static dam
        for i = 1:optParam.numExp % cost of expanded dams
            [infra_cost(3), infra_cost(i+3)] = storage2damcost(storage(2), ...
                storage(i+2),costParam.PercFlex, costParam.PercExp); % cost of flexible design exp to option X
        end
        infra_costs.static(s,:) = [storage(1), infra_cost(2)/1E6];
        infra_costs.flex(s,1:2+optParam.numExp) = [storage(2), [infra_cost(3:3+optParam.numExp)]./1E6];
    end
    
    % change in shortage plot shortage cost vs. expansion cost for 50, 80, 110 MCM:
    storagecolors = [[38, 70, 83]; [42, 157, 143]; [233, 196, 106]; [244, 162, 97]; ...
        [231, 111, 81];[0.6350 0.0780 0.1840]*255]/255;
     storagecolors = [[175,201,219];[128,167,190];[97,148,177];[70,124,173]]/255;
     storagecolors =  [[210, 210, 210];[160, 196, 216];[69, 131, 189];[0, 33, 61];[0, 14, 25]]/255;
    
    for s=1:length(storages)
        nexttile
        expOpts = infra_costs.flex(s,1):10:infra_costs.flex(s,1)+sum(infra_costs.flex(s,3:end)>0)*10;
        
        for ops = 1:2 % 1 is flexible ops, 2 is static ops
            for j=2:length(expOpts)
                if ops == 1
                    load(strcat(folder1,'/sdp_adaptive_shortage_cost_s',num2str(expOpts(1))))
                    initCosts = shortageCost;
                    load(strcat(folder1,'/sdp_adaptive_shortage_cost_s',num2str(expOpts(j))))
                else
                    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(expOpts(1))))
                    initCosts = shortageCost;
                    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(expOpts(j))));
                end
                expCosts = infra_costs.flex(s,3:sum(infra_costs.flex(s,:)>0));
                %expCosts = expCosts(2:end);                
                %for j=2:length(expOpts)
                newCosts = shortageCost;
                costDiff = (initCosts - newCosts)*cprime/1E6;
                hold on
                if ops == 1
                    plot(s_P_abs, costDiff(1,:)/expCosts(j-1),'Color',storagecolors(j-1,:),...
                        'LineWidth',1.5, 'LineStyle','-')
                else
                    plot(s_P_abs, costDiff(1,:)/expCosts(j-1),'Color',storagecolors(j-1,:),...
                        'LineWidth',1.5, 'LineStyle','--')
                end
                hold on
            end
            if s==1
                %ylabel('\Delta Shortage Cost/Exp. Cost','FontWeight','bold')
                %ylmax = 1.1*max(costDiff(1,:)./expCosts(j-1));
            end
           
        end
        yline(1,':k','Linewidth',1.5)
        %ylim([0 inf])
        ylim([0 9])
        %xlim([49 119])
        xlim([66, 97])
        grid 'minor'
        grid on
        box 'on'
        if s == 2
            if type == 1
                title({"Flexible Design";strcat("Initial Dam Capacity: ", string(storages(s)), "MCM")})
            else
                title({"Flexible Planning";strcat("Initial Dam Capacity: ", string(storages(s)), "MCM")}) 
            end
        else
            title({"";strcat("Initial Dam Capacity: ", string(storages(s)), "MCM")})
        end
         if s==length(storages) && type == 2 && ops ==2
                for z=2:5
                    plot([66 97], ones(1,2)*-1,'Color',storagecolors(z-1,:),...
                        'LineWidth',1.5)
                    hold on
                end
                leg1 = legend("+10 MCM","+20 MCM","+30 MCM","+40 MCM",...
                    'autoupdate','off','Location','northeast');
                title(leg1,"\Delta Dam Capacity")
                hold off
                
                ah1=axes('position',get(gca,'position'),'visible','off');
                hold on
                p1 = plot([0 1],[0 0],'LineStyle','-','Color',[17 17 17]/255,...
                    'DisplayName','Static Ops.');
                hold on
                p2 = plot([0 1],[0 0],'LineStyle','--','Color',[17 17 17]/255,...
                    'DisplayName','Flexible Ops.');
                ylim([10 12])
                leg2=legend(ah1,'autoupdate','off');
                title(leg2, 'Dam Operations' );
            end
        %ylim([0,ylmax])
    end
end



xlabel(t, "Precipitation State (mm/mo)",'fontweight','bold')
ylabel(t, '\Delta Shortage Cost/Exp. Cost','FontWeight','bold')

title(t, "Ratio of Shortage Cost Reduction to Dam Expansion Cost",'FontWeight','bold')


%% Plot: Shortage and Infrastructure Costs by P state

% load the data:
folder1 = 'Nov02post_process_sdp_reservoir_results';
storages = 70:20:150; % dam capacities to plot
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
cprime = 1.25E-6;

% calculate non-discounted infrastructure costs using storage2damcost:   
% load optimal infrastructure information
infra_cost_nonadaptive = struct();
infra_cost_nonadaptive.static = NaN(length(storages),2);
infra_cost_nonadaptive.flex = NaN(length(storages),6);
infra_cost_nonadaptive.plan = NaN(length(storages),6);

for s=1:length(storages)
    costParam.discountrate = 0;
    optParam.staticCap = storages(s); % static dam size [MCM]
    
    optParam.smallFlexCap = storages(s);
    optParam.flexIncr = 10; % increment of flexible expansion capacities [MCM]
    optParam.numFlex = ((min(ceil(1.5*optParam.smallFlexCap/10)*10,150))-optParam.smallFlexCap)/...
        optParam.flexIncr;  % number of possible expansion capacities [#]
    costParam.PercFlex = 0.05; % Initial upfront capital cost increase (0.075)
    costParam.PercFlexExp = 0.01; % Expansion cost of flexible dam  (0.15)
    
    optParam.smallPlanCap = storages(s); % unexpanded flexible planning dam size [MCM]
    optParam.planIncr = 10;
    optParam.numPlan = ((min(ceil(1.5*optParam.smallPlanCap/10)*10,150))-optParam.smallPlanCap)/...
        optParam.planIncr;  % number of possible expansion capacities [#]
    costParam.PercPlan = 0; % initial upfront capital cost increase (0);
    costParam.PercPlanExp = 0.50; % expansion cost of flexibly planned dam (0.5)

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

    infra_cost_nonadaptive.static(s,:) = [storage(1), infra_cost(2)/1E6];
    infra_cost_nonadaptive.flex(s,1:2+optParam.numFlex) = [storage(2), [[infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6]];
    infra_cost_nonadaptive.plan(s,1:2+optParam.numPlan) = [storage(3), [[infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6]];
end

figure
t = tiledlayout(4,4,'TileSpacing','compact');

% plot all shortage costs vs. initial infrastructure cost
storagecolors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
    [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880]};
nexttile([2 4])
for i=1:length(storages)
    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(storages(i))));
    plot(s_P_abs, shortageCost(1,:)*cprime/1E6,'Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5)
    hold on
end
leg1 = legend('Location','northeast','AutoUpdate','off');
title(leg1, 'Dam Storage')

% plot initial infrastructure costs:
for i=1:length(storages)
    yline(infra_cost_nonadaptive.flex(i,2),'LineStyle',':','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
    yline(infra_cost_nonadaptive.static(i,2),'LineStyle','--','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
end
grid 'minor'
grid on
ylabel('Cost (M$)')
xlabel('Precip. State (mm/mo)')
xlim([66 97])

l1 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle',':');
l3 = plot([49, 49],[0,0],'color', [17 17 17]/255,'linestyle','--');
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, [l1 l2 l3], ["Shortage Costs", "Flex Design Infra. Cost",...
    "Static Design Infra. Cost"],'FontSize',7);
title(leg2,'Costs')
hold off

% for the remaining tiles, plot shortage cost vs. expansion costs:

for s=1:length(storages)-1
    nexttile(t,[2 1])
    expCosts = infra_cost_nonadaptive.flex(s,infra_cost_nonadaptive.flex(s,:)>0);
    expCosts = expCosts(3:end);
    expOpts = infra_cost_nonadaptive.flex(s,1):10:infra_cost_nonadaptive.flex(s,1)+length(expCosts)*10;
    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(storages(s))));
    initCosts = shortageCost;
    for j=2:length(expOpts)
        load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(expOpts(j))));
        newCosts = shortageCost;
        costDiff = (initCosts - newCosts)*cprime/1E6;
        hold on
        plot(s_P_abs, costDiff(1,:)/expCosts(j-1),'Color',storagecolors{j-1},...
            'LineWidth',1.5)
        hold on
    end
    yline(1,'--k')
    xlim([66, 97])
    ylim([0,4])
    grid 'minor'
    grid on
    box 'on'
end
    
    
%% Plot: Shortage and Infrastructure Costs by P state for Different Scenarios

% load the data:
folder1 = 'Nov02post_process_sdp_reservoir_results';
folder2 = 'Apr12v3post_process_sdp_reservoir_results_IncVar';
folder3 = 'May07post_process_sdp_reservoir_results_linearCost';

storages = 50:20:150; % dam capacities to plot
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
cprime = 1.25E-6; %1.25E-6;

% calculate non-discounted infrastructure costs using storage2damcost:   
% load optimal infrastructure information
infra_cost_nonadaptive = struct();
infra_cost_nonadaptive.static = NaN(length(storages),2);
infra_cost_nonadaptive.flex = NaN(length(storages),6);
infra_cost_nonadaptive.plan = NaN(length(storages),6);

for s=1:length(storages)
    costParam.discountrate = 0;
    optParam.staticCap = storages(s); % static dam size [MCM]
    
    optParam.smallFlexCap = storages(s);
    optParam.flexIncr = 10; % increment of flexible expansion capacities [MCM]
    optParam.numFlex = ((min(ceil(1.5*optParam.smallFlexCap/10)*10,150))-optParam.smallFlexCap)/...
        optParam.flexIncr;  % number of possible expansion capacities [#]
    costParam.PercFlex = 0.05; % Initial upfront capital cost increase (0.075)
    costParam.PercFlexExp = 0.01; % Expansion cost of flexible dam  (0.15)
    
    optParam.smallPlanCap = storages(s); % unexpanded flexible planning dam size [MCM]
    optParam.planIncr = 10;
    optParam.numPlan = ((min(ceil(1.5*optParam.smallPlanCap/10)*10,150))-optParam.smallPlanCap)/...
        optParam.planIncr;  % number of possible expansion capacities [#]
    costParam.PercPlan = 0; % initial upfront capital cost increase (0);
    costParam.PercPlanExp = 0.50; % expansion cost of flexibly planned dam (0.5)

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

    infra_cost_nonadaptive.static(s,:) = [storage(1), infra_cost(2)/1E6];
    infra_cost_nonadaptive.flex(s,1:2+optParam.numFlex) = [storage(2), [[infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6]];
    infra_cost_nonadaptive.plan(s,1:2+optParam.numPlan) = [storage(3), [[infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6]];
end

figure
t = tiledlayout(4,6,'TileSpacing','compact');

% plot all shortage costs vs. initial infrastructure cost
storagecolors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
    [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.6350 0.0780 0.1840]};
nexttile([2 6])
for i=1:length(storages)
    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(storages(i))));
    plot(s_P_abs, shortageCost(1,:)*cprime/1E6,'Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5)
    hold on
end
leg1 = legend('Location','northeast','AutoUpdate','off');
title(leg1, 'Dam Storage')

% plot initial infrastructure costs:
for i=1:length(storages)
    yline(infra_cost_nonadaptive.flex(i,2),'LineStyle',':','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
    yline(infra_cost_nonadaptive.static(i,2),'LineStyle','--','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
end
grid 'minor'
grid on
ylabel('Cost (M$)','FontWeight','bold')
%xlabel('Precip. State (mm/mo)')
title("Shortage Costs & Initial Infrastructure Costs vs. P State (T State: 26.25^oC)")
xlim([66 97])

l1 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle',':');
l3 = plot([49, 49],[0,0],'color', [17 17 17]/255,'linestyle','--');
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, [l1 l2 l3], ["Shortage Costs", "Flex Design Infra. Cost",...
    "Static Design Infra. Cost"],'FontSize',7);
title(leg2,'Costs')
hold off

% for the remaining tiles, plot shortage cost vs. expansion costs:
storagecolors = [[38, 70, 83]; [42, 157, 143]; [233, 196, 106]; [244, 162, 97]; ...
    [231, 111, 81];[0.6350 0.0780 0.1840]*255]/255;
for s=1:length(storages)
    nexttile(t,[2 1])
    expCosts = infra_cost_nonadaptive.plan(s,infra_cost_nonadaptive.plan(s,:)>0);
    expCosts = expCosts(3:end);
    expOpts = infra_cost_nonadaptive.plan(s,1):10:infra_cost_nonadaptive.plan(s,1)+length(expCosts)*10;
    load(strcat(folder1,'/sdp_adaptive_shortage_cost_s',num2str(storages(s))));
    initCosts = shortageCost;
    for j=2:length(expOpts)
        load(strcat(folder1,'/sdp_adaptive_shortage_cost_s',num2str(expOpts(j))));
        newCosts = shortageCost;
        costDiff = (initCosts - newCosts)*cprime/1E6;
        hold on
        plot(s_P_abs, costDiff(1,:)/expCosts(j-1),'Color',storagecolors(j-1,:),...
            'LineWidth',1.5)
        hold on
    end
    if s==1
        ylabel('\Delta Shortage Cost/Exp. Cost','FontWeight','bold')
        ylmax = 1.1*max(costDiff(1,:)/expCosts(j-1));
    end
    if s==length(storages)
        for j=2:6
        plot([66 97], ones(1,2)*-1,'Color',storagecolors(j-1,:),...
            'LineWidth',1.5)
        hold on
        end
        legend("+10 MCM","+20 MCM","+30 MCM","+40 MCM","+50 MCM",...
            'autoupdate','off','Location','northeast')
    end
    yline(1,'--k')
    ylim([0 inf])
    %xlim([49 119])
    xlim([66 97])
    grid 'minor'
    grid on
    box 'on'
    title({"Initial Plan Dam: ";strcat(string(storages(s)), "MCM")})
    %ylim([0,ylmax])
end

xlabel(t, "Precipitation State (mm/mo)",'fontweight','bold')
title(t, "12Apr2022 IncVar Cost Non-Adaptive Reservoir Operations Results",'FontWeight','bold')

%% shortage cost by dam size and min and max expansion cost vs. p state
% load the data:
folder1 = 'Nov02post_process_sdp_reservoir_results';
folder2 = 'Apr12v3post_process_sdp_reservoir_results_IncVar';
folder3 = 'May07post_process_sdp_reservoir_results_linearCost';

storages = 50:20:150; % dam capacities to plot
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
cprime = 1.25E-6; %1.25E-6;

% calculate non-discounted infrastructure costs using storage2damcost:   
% load optimal infrastructure information
infra_cost_nonadaptive = struct();
infra_cost_nonadaptive.static = NaN(length(storages),2);
infra_cost_nonadaptive.flex = NaN(length(storages),6);
infra_cost_nonadaptive.plan = NaN(length(storages),6);

for s=1:length(storages)
    costParam.discountrate = 0;
    optParam.staticCap = storages(s); % static dam size [MCM]
    
    optParam.smallFlexCap = storages(s);
    optParam.flexIncr = 10; % increment of flexible expansion capacities [MCM]
    optParam.numFlex = ((min(ceil(1.5*optParam.smallFlexCap/10)*10,150))-optParam.smallFlexCap)/...
        optParam.flexIncr;  % number of possible expansion capacities [#]
    costParam.PercFlex = 0.05; % Initial upfront capital cost increase (0.075)
    costParam.PercFlexExp = 0.01; % Expansion cost of flexible dam  (0.15)
    
    optParam.smallPlanCap = storages(s); % unexpanded flexible planning dam size [MCM]
    optParam.planIncr = 10;
    optParam.numPlan = ((min(ceil(1.5*optParam.smallPlanCap/10)*10,150))-optParam.smallPlanCap)/...
        optParam.planIncr;  % number of possible expansion capacities [#]
    costParam.PercPlan = 0; % initial upfront capital cost increase (0);
    costParam.PercPlanExp = 0.50; % expansion cost of flexibly planned dam (0.5)

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

    infra_cost_nonadaptive.static(s,:) = [storage(1), infra_cost(2)/1E6];
    infra_cost_nonadaptive.flex(s,1:2+optParam.numFlex) = [storage(2), [[infra_cost(3), infra_cost(5:optParam.numFlex+4)]./1E6]];
    infra_cost_nonadaptive.plan(s,1:2+optParam.numPlan) = [storage(3), [[infra_cost(4), infra_cost(5+optParam.numFlex:end)]./1E6]];
end

figure
%t = tiledlayout(1,2,'TileSpacing','compact');

% plot all shortage costs vs. initial infrastructure cost
storagecolors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
    [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.6350 0.0780 0.1840]};

for i=1:length(storages)
    load(strcat(folder1,'/sdp_nonadaptive_shortage_cost_s',num2str(storages(i))));
    plot(s_P_abs, shortageCost(1,:)*cprime/1E6,'Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5)
    hold on
end
leg1 = legend('Location','northeast','AutoUpdate','off');
title(leg1, 'Dam Storage')

% plot initial infrastructure costs:
for i=1:length(storages)-1
    ExpFlex = infra_cost_nonadaptive.flex(i,infra_cost_nonadaptive.flex(i,:)>0);
    minExpFlex = min(ExpFlex(3:end));
    maxExpFlex = max(ExpFlex(3:end));
    ExpPlan = infra_cost_nonadaptive.plan(i,infra_cost_nonadaptive.plan(i,:)>0);
    minExpPlan = min(ExpPlan(3:end));
    maxExpPlan = max(ExpPlan(3:end));
    yline(minExpPlan,'LineStyle',':','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
    yline(maxExpPlan,'LineStyle','--','Color',storagecolors{i},'DisplayName',...
        strcat(string(storages(i))," MCM Dam"),'LineWidth',1.5);
    hold on
end
grid 'minor'
grid on
ylabel('Cost (M$)','FontWeight','bold')
%xlabel('Precip. State (mm/mo)')
title("Static Operations")
xlim([66 97])
ylim([0, 100])

l1 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([48, 49],[0,0],'color', [17 17 17]/255,'linestyle',':');
l3 = plot([49, 49],[0,0],'color', [17 17 17]/255,'linestyle','--');
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, [l1 l2 l3], ["Shortage Costs", "Min Exp. Cost",...
    "Max Exp. Cost"],'FontSize',7);
title(leg2,'Costs')
hold off


