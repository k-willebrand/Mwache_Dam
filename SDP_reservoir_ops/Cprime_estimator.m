% Description: this script is utilzed to find an appropriate parameter
% estimate for c' which allows for a quadratic operations model to be
% related to an economic water shortage cost model for the Mwache Dam.

% Defining the economic water shortage cost model:

% x*v = c' v^2 [$]

% - let x be the unit cost of water deficit with units [$/m3]. Let x be a
% linear function of v, the volume of water deficit
% - let c' be the rate at which the unit cost of water deficit increases
% as a function of the volume of water deficit with units [$/m6]. 

%% Script Setup
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storage_vals = [50:10:150];

%% First plot: reference raw objective function output plot (not rescaled)

figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        xlim([49,119])
        %xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle(["Current Non-Rescaled Shortage Costs"; "J = unmet_{ag}^2 + 2.3 unmet_{dom}^2"],'FontWeight','bold')

%% Trial 1: consider data from all 71 precipitation states
% Use average cumulative 20-year deficits as the range of  deficits

% choose a preliminary value for c' (cp):
cp = 1.85e-9; % [$/m^6]

% define our cost parameter functions where x has units [$/m^6]
x_ag = @(v) cp*v; % linear cost function for unit cost of agricultural shortages
x_dom = @(v) 2.3*x_ag(v); % linear cost function for unit cost of domestic shortage

% find the range of unmet domestic and agricultural demands from our model
for adaptiveOps = 0:1

    for s = 1:length(storage_vals)
        storage = storage_vals(s);
        if adaptiveOps == 1
            load(strcat('Oct172021sdp_adaptive_unmet_domagCost231_s',string(storage),'.mat'));
        else
            load(strcat('Oct172021sdp_nonadaptive_unmet_domagCost231_s',string(storage),'.mat'));
        end
        if s == 1
            unmet_ag_all = unmet_ag;
            unmet_dom_all = unmet_dom;
        else
            unmet_ag_all = [unmet_ag_all; unmet_ag];
            unmet_dom_all = [unmet_dom_all; unmet_dom];
        end
        
    end
end

v_ag = linspace(min(unmet_ag_all,[],'all'),max(unmet_ag_all,[],'all'));
v_dom = linspace(min(unmet_dom_all,[],'all'),max(unmet_dom_all,[],'all'));

% calculate the mean value over the larger range of shortage deficits
% in our model, we found that (v_ag) has a larger range of values
mean_x_ag = mean(x_ag(v_ag));
mean_x_dom = mean(x_dom(v_ag));

% 
figure()
plot(v_ag, x_ag(v_ag),'DisplayName','$x_{ag}(v)$')
hold on
plot(v_ag, x_dom(v_ag),'DisplayName','$x_{dom}(v)$')
hold on
yline(mean_x_ag,'LineStyle','--','DisplayName',strcat('$\overline{x_{ag}(v)}$ = ', string(mean_x_ag)),'interpreter','latex','color','blue')
hold on
yline(mean_x_dom,'LineStyle','--','DisplayName',strcat('$\overline{x_{dom}(v)}$ = ', string(mean_x_dom)),'interpreter','latex','color','red')
xlabel('Shortage Deficit (v) [m^3]')
ylabel('Unit Cost of Shortage (x) [$/m^3]')
legend('interpreter','latex')
title({'Unit Cost of Shortage vs. Volume of Shortage';strcat("c' = $", string(cp)," /m^6")}...
    ,'FontWeight','bold')

% plot the resulting scaled shortage costs
v_ag = unmet_ag_all;
v_dom = unmet_dom_all;

figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = cp.*shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        xlim([49,119])
        %xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle({strcat("Rescaled Shortage Costs for c' = $", string(cp)," /m^6 "); 
    strcat('mean x_{ag} = $',string(mean_x_ag),' /m^3 & mean x_{dom} = $', string(mean_x_dom),' /m^3')}...
    ,'FontWeight','bold')

%% Trial 2: consider data from subset of 32 precipitation states
% Use average cumulative 20-year deficits as the range of  deficits

% choose a preliminary value for c' (cp):
cp = 4.74e-9; % [$/m^6]

% define our cost parameter functions where x has units [$/m^6]
x_ag = @(v) cp*v; % linear cost function for unit cost of agricultural shortages
x_dom = @(v) 2.3*x_ag(v); % linear cost function for unit cost of domestic shortage

% find the range of unmet domestic and agricultural demands from our model
for adaptiveOps = 0:1

    for s = 1:length(storage_vals)
        storage = storage_vals(s);
        if adaptiveOps == 1
            load(strcat('Oct172021sdp_adaptive_unmet_domagCost231_s',string(storage),'.mat'));
        else
            load(strcat('Oct172021sdp_nonadaptive_unmet_domagCost231_s',string(storage),'.mat'));
        end

        if s == 1
            unmet_ag_all = unmet_ag(:,18:49);
            unmet_dom_all = unmet_dom(:,18:49);
        else
            unmet_ag_all = [unmet_ag_all; unmet_ag(:,18:49)];
            unmet_dom_all = [unmet_dom_all; unmet_dom(:,18:49)];
        end
    end
end

v_ag = linspace(min(unmet_ag_all,[],'all'),max(unmet_ag_all,[],'all'));
v_dom = linspace(min(unmet_dom_all,[],'all'),max(unmet_dom_all,[],'all'));

% calculate the mean value over the larger range of shortage deficits
% in our model, we found that (v_ag) has a larger range of values
mean_x_ag = mean(x_ag(v_ag));
mean_x_dom = mean(x_dom(v_ag));

% 
figure()
plot(v_ag, x_ag(v_ag),'DisplayName','$x_{ag}(v)$')
hold on
plot(v_ag, x_dom(v_ag),'DisplayName','$x_{dom}(v)$')
hold on
yline(mean_x_ag,'LineStyle','--','DisplayName',strcat('$\overline{x_{ag}(v)}$ = ', string(mean_x_ag)),'interpreter','latex','color','blue')
hold on
yline(mean_x_dom,'LineStyle','--','DisplayName',strcat('$\overline{x_{dom}(v)}$ = ', string(mean_x_dom)),'interpreter','latex','color','red')
xlabel('Shortage Deficit (v) [m^3]')
ylabel('Unit Cost of Shortage (x) [$/m^3]')
legend('interpreter','latex')
title({'Unit Cost of Shortage vs. Volume of Shortage';strcat("c' = $", string(cp)," /m^6")}...
    ,'FontWeight','bold')

% plot the resulting shortage costs
v_ag = unmet_ag_all;
v_dom = unmet_dom_all;


figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = cp.*shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        xlim([49,119])
        %xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle({strcat("Rescaled Shortage Costs for c' = $", string(cp)," /m^6 "); 
    strcat('mean x_{ag} = $',string(mean_x_ag),' /m^3 & mean x_{dom} = $', string(mean_x_dom),' /m^3')}...
    ,'FontWeight','bold')


%% First plot: reference raw objective function output plot (not rescaled)

figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        xlim([49,119])
        %xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle(["Current Non-Rescaled Shortage Costs"; "J = unmet_{ag}^2 + 2.3 unmet_{dom}^2"],'FontWeight','bold')

%% Trial 3: consider data from all 71 precipitation states
% Use range of monthly deficits from the driest, warmest climate state

% choose a preliminary value for c' (cp):
cp = 1.55e-7; % [$/m^6]

% define our cost parameter functions where x has units [$/m^6]
x_ag = @(v) cp*v; % linear cost function for unit cost of agricultural shortages
x_dom = @(v) 2.3*x_ag(v); % linear cost function for unit cost of domestic shortage

% find the range of unmet domestic and agricultural demands from our model
for adaptiveOps = 0:1

    for s = 1:length(storage_vals)
        storage = storage_vals(s);
        if adaptiveOps == 1
            load(strcat('Oct172021adaptive_domagCost231_SSTest_st5_sp1_s',string(storage),'_100821.mat'));
        else
            load(strcat('Oct172021adaptive_domagCost231_SSTest_st5_sp1_s',string(storage),'_100821.mat'));
        end
        if s == 1
            unmet_ag_all = unmet_ag_ts(241:end,:)';
            unmet_dom_all = unmet_dom_ts(241:end,:)';
        else
            unmet_ag_all = [unmet_ag_all; unmet_ag_ts(241:end,:)'];
            unmet_dom_all = [unmet_dom_all; unmet_dom_ts(241:end,:)'];
        end
        
    end
end

% v_ag = linspace(min(unmet_ag_all,[],'all'),max(unmet_ag_all,[],'all'));
% v_dom = linspace(min(unmet_dom_all,[],'all'),max(unmet_dom_all,[],'all'));

v_ag = linspace(min(unmet_ag_all,[],'all'),prctile(unmet_ag_all, 95,'all'));
v_dom = linspace(min(unmet_dom_all,[],'all'),prctile(unmet_dom_all, 95,'all'));

% calculate the mean value over the larger range of shortage deficits
% in our model, we found that (v_ag) has a larger range of values
mean_x_ag = mean(x_ag(v_ag));
mean_x_dom = mean(x_dom(v_ag));

% 
figure()
plot(v_ag, x_ag(v_ag),'DisplayName','$x_{ag}(v)$')
hold on
plot(v_ag, x_dom(v_ag),'DisplayName','$x_{dom}(v)$')
hold on
yline(mean_x_ag,'LineStyle','--','DisplayName',strcat('$\overline{x_{ag}(v)}$ = ', string(mean_x_ag)),'interpreter','latex','color','blue')
hold on
yline(mean_x_dom,'LineStyle','--','DisplayName',strcat('$\overline{x_{dom}(v)}$ = ', string(mean_x_dom)),'interpreter','latex','color','red')
xlabel('Shortage Deficit (v) [m^3]')
ylabel('Unit Cost of Shortage (x) [$/m^3]')
legend('interpreter','latex')
title({'Unit Cost of Shortage vs. Volume of Shortage';strcat("c' = $", string(cp)," /m^6")}...
    ,'FontWeight','bold')

% plot the resulting scaled shortage costs
v_ag = unmet_ag_all;
v_dom = unmet_dom_all;

figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = cp.*shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        xlim([49,119])
        %xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle({strcat("Rescaled Shortage Costs for c' = $", string(cp)," /m^6 "); 
    strcat('mean x_{ag} = $',string(mean_x_ag),' /m^3 & mean x_{dom} = $', string(mean_x_dom),' /m^3')}...
    ,'FontWeight','bold')

%% Trial 4: consider data from subset of 32 precipitation states
% Use average cumulative 20-year deficits as the range of  deficits

% choose a preliminary value for c' (cp):
cp = 4.85e-7; % [$/m^6]

% define our cost parameter functions where x has units [$/m^6]
x_ag = @(v) cp*v; % linear cost function for unit cost of agricultural shortages
x_dom = @(v) 2.3*x_ag(v); % linear cost function for unit cost of domestic shortage

% find the range of unmet domestic and agricultural demands from our model
for adaptiveOps = 0:1

    for s = 1:length(storage_vals)
        storage = storage_vals(s);
        if adaptiveOps == 1
            load(strcat('Oct172021adaptive_domagCost231_SSTest_st5_sp18_s',string(storage),'_100821.mat'));
        else
            load(strcat('Oct172021adaptive_domagCost231_SSTest_st5_sp18_s',string(storage),'_100821.mat'));
        end

        if s == 1
            unmet_ag_all = unmet_ag_ts(241:end,:)';
            unmet_dom_all = unmet_dom_ts(241:end,:)';
        else
            unmet_ag_all = [unmet_ag_all; unmet_ag_ts(241:end,:)'];
            unmet_dom_all = [unmet_dom_all; unmet_dom_ts(241:end,:)'];
        end
    end
end

% v_ag = linspace(min(unmet_ag_all,[],'all'),max(unmet_ag_all,[],'all'));
% v_dom = linspace(min(unmet_dom_all,[],'all'),max(unmet_dom_all,[],'all'));

v_ag = linspace(min(unmet_ag_all,[],'all'),prctile(unmet_ag_all, 95,'all'));
v_dom = linspace(min(unmet_dom_all,[],'all'),prctile(unmet_dom_all, 95,'all'));

% calculate the mean value over the larger range of shortage deficits
% in our model, we found that (v_ag) has a larger range of values
mean_x_ag = mean(x_ag(v_ag));
mean_x_dom = mean(x_dom(v_ag));

% 
figure()
plot(v_ag, x_ag(v_ag),'DisplayName','$x_{ag}(v)$')
hold on
plot(v_ag, x_dom(v_ag),'DisplayName','$x_{dom}(v)$')
hold on
yline(mean_x_ag,'LineStyle','--','DisplayName',strcat('$\overline{x_{ag}(v)}$ = ', string(mean_x_ag)),'interpreter','latex','color','blue')
hold on
yline(mean_x_dom,'LineStyle','--','DisplayName',strcat('$\overline{x_{dom}(v)}$ = ', string(mean_x_dom)),'interpreter','latex','color','red')
xlabel('Shortage Deficit (v) [m^3]')
ylabel('Unit Cost of Shortage (x) [$/m^3]')
legend('interpreter','latex')
title({'Unit Cost of Shortage vs. Volume of Shortage';strcat("c' = $", string(cp)," /m^6")}...
    ,'FontWeight','bold')

% plot the resulting shortage costs
v_ag = unmet_ag_all;
v_dom = unmet_dom_all;


figure
for adaptiveOps = 0:1
    for t = 1:5
        for s = 1:length(storage_vals)
            storage = storage_vals(s);
            if adaptiveOps == 1
                load(strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            else
                load(strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage),'.mat'));
            end
            subplot(2,5,adaptiveOps*5+t)
            cost = cp.*shortageCost(t,:);
            if adaptiveOps == 1
                plot([49:119],cost,'DisplayName',strcat('Adaptive ', string(storage),'MCM'))
                hold on
            else
                plot([49:119],cost,'DisplayName',strcat('Non-adaptive ', string(storage),'MCM'))
                hold on
            end
            xlabel('Precipitation State [mm/mo]')
            ylabel('Shortage Cost ($)')
            if t == 3
                if adaptiveOps == 1
                    title({'Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                else
                    title({'Non-Adaptive Operations';strcat('T State: ',string(s_T_abs(t)),'*C')})
                end
            else
                title(strcat('T State: ',string(s_T_abs(t)),'*C'))
            end
            if t == 1
                if adaptiveOps == 1
                    legend(strcat('Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                else
                    legend(strcat('Non-Adaptive ', string(storage_vals),'MCM'),'AutoUpdate','off')
                end
            end
        end
        %xlim([49,119])
        xlim([66,97])
        xline(66,'Linestyle','--','color','black','DisplayName','')
        xline(97,'Linestyle','--','color','black','DisplayName','')
    end
end

sgtitle({strcat("Rescaled Shortage Costs for c' = $", string(cp)," /m^6 "); 
    strcat('mean x_{ag} = $',string(mean_x_ag),' /m^3 & mean x_{dom} = $', string(mean_x_dom),' /m^3')}...
    ,'FontWeight','bold')

%% Old script (ignore)

costParam.agShortage = 0.3;
c = costParam.agShortage;
costParam.domShortage = 2*costParam.agShortage;

storage_vals = [50:10:150];

for adaptiveOps = 0:1

    for s = 1:length(storage_vals)
        storage = storage_vals(s);
        if adaptiveOps == 1
            load(strcat('Oct062021sdp_adaptive_unmet_domagCost21_s',string(storage),'.mat'));
        else
            load(strcat('Oct062021sdp_nonadaptive_unmet_domagCost21_s',string(storage),'.mat'));
        end

        % compute the costs if a linear cost model was used
        %unmet_volumes = [0:100:3.5E8]; % range of average 20-year unmet ag volumes
        linear_cost_ag = c.*sort(reshape(unmet_ag,1,[]));
        linear_cost_dom = 2.3.*c.* sort(reshape(unmet_dom,1,[]));
        linear_cost = sort(reshape(c.*unmet_ag + 2.3.*c.*unmet_dom,1,[]));

        if s == 1
            unmet_ag_all = unmet_ag;
            unmet_dom_all = unmet_dom;

            linear_cost_ag_all = linear_cost_ag;
            linear_cost_dom_all = linear_cost_dom;
            linear_cost_all = linear_cost;
        else
            unmet_ag_all = [unmet_ag_all; unmet_ag];
            unmet_dom_all = [unmet_dom_all; unmet_dom];

            linear_cost_ag_all = [linear_cost_ag_all; linear_cost_ag];
            linear_cost_dom_all = [linear_cost_dom_all; linear_cost_dom];
            linear_cost_all = [linear_cost_all; linear_cost];
        end

        % plot raw data
        % Agricutural Cost
        figure(1)
        hold on
        if adaptiveOps == 1
            scatter(sort(reshape(unmet_ag,1,[])), linear_cost_ag,'Marker','o','DisplayName',strcat('Adaptive ', string(storage),'MCM'))
        else
            scatter(sort(reshape(unmet_ag,1,[])), linear_cost_ag,'Marker','.','DisplayName',strcat('Nonadaptive ', string(storage),'MCM'))
        end
        
        % Domestic Cost
        figure(2)
        hold on
        if adaptiveOps == 1
            scatter(sort(reshape(unmet_dom,1,[])), linear_cost_dom,'Marker','o','DisplayName',strcat('Adaptive ', string(storage),'MCM'))
        else
            scatter(sort(reshape(unmet_dom,1,[])), linear_cost_dom,'Marker','.','DisplayName',strcat('Nonadaptive ', string(storage),'MCM'))
        end
        
        % Total Shortage Cost
        figure(3)
        hold on
        if adaptiveOps == 1
            scatter(sort(reshape((unmet_ag + 2.*unmet_dom),1,[])), linear_cost,'Marker','o','DisplayName',strcat('Adaptive ', string(storage),'MCM'))
            %scatter(sort(reshape((unmet_ag.^2 + 4.*unmet_dom.^2),1,[])), linear_cost,'Marker','o','DisplayName',strcat('Adaptive ', string(storage),'MCM'))
        else
            scatter(sort(reshape((unmet_ag + 2.*unmet_dom),1,[])), linear_cost,'Marker','.','DisplayName',strcat('Nonadaptive ', string(storage),'MCM'))
            %scatter(sort(reshape((unmet_ag.^2 + 4.*unmet_dom.^2),1,[])), linear_cost,'Marker','.','DisplayName',strcat('Nonadaptive ', string(storage),'MCM'))
        end

    end
end

    % find the value of the best fit paramter c' from a quadratic formulation
    % Agricultual Cost
    x = sort(reshape(unmet_ag_all,1,[]));
    y = sort(reshape(linear_cost_ag_all,1,[]));
    [fit_ag, gof_ag] = fit(x',y','cp*x^2');

    figure(1)
    hold on
    quadfit_ag = fit_ag.cp.*x.^2;
    plot(x, quadfit_ag,'DisplayName',strcat('fitted cost = (',string(fit_ag.cp),')x^2'));
    legend()
    xlabel('Unmet Agricultural Demands, x [m^3]')
    ylabel('Cost ($)')
    title('Shortage Cost vs. Unmet Agricultural Demands')

    % Domestic Cost
    x = sort(reshape(unmet_dom_all,1,[]));
    y = sort(reshape(linear_cost_dom_all,1,[]));
    [fit_dom, gof_dom] = fit(x',y','cp*x^2');

    figure(2)
    hold on
    quadfit_dom = fit_dom.cp.*x.^2;
    plot(x,quadfit_dom,'DisplayName',strcat('fitted cost = (',string(fit_dom.cp),')x^2'));
    legend()
    xlabel('Unmet Domestic Demands, x [m^3]')
    ylabel('Cost ($)')
    title('Shortage Cost vs. Unmet Domestic Demands')

    % Total Shortage Cost
    %x = sort(reshape((unmet_ag_all.^2 + (2.*unmet_dom_all).^2),1,[]));
    %y = sort(reshape(linear_cost_all,1,[]));
    x = reshape((unmet_ag_all.^2 + (2.*unmet_dom_all).^2),1,[]);
    y = reshape(linear_cost_all,1,[]);
    [fit_all, gof_all] = fit(x',y','cp*x');

    figure(4)
    hold on
    x = sort(reshape((unmet_ag_all.^2 + (2.*unmet_dom_all).^2),1,[]));
    quadfit_all = fit_all.cp.*x;
    plot(x,quadfit_all,'DisplayName',strcat('fitted cost = (',string(fit_all.cp),')(unmet_{ag}^2+(2unmet_{dom})^2'));
    legend()
    xlabel('unmet_{ag}^2+ 4 unmet_{dom}^2 [m^6]')
    ylabel('Cost ($)')
    title('Shortage Cost vs. Unmet Demands')
    
    