%% Single storage capacity shortage cost plot

ytext = 'Shortage Cost';
storage_vals = [50:10:150];

figure

for s = 1:length(storage_vals)
    filename = strcat('Oct062021sdp_nonadaptive_shortage_cost_domagCost21_s',string(storage_vals(s)),'.mat');
    load(filename)
    %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)

    subplot(4,3,s)
    plot([49:1:119],shortageCost')
    if s == 11
        legend('T State 1 (26.25 deg. C)','T State 2 (26.75 deg. C)', 'T State 3 (27.25 deg. C)', 'T State 4 (27.95 deg. C)', 'T State 5 (28.8 deg. C)')
    end
    xlabel('Precipitation State (mm/month)')
    ylabel(ytext)
    xlim([49,120])
    title(strcat(string(storage_vals(s)),' MCM SDP Non-Adaptive Dam'))
end

sgtitle({strcat(ytext,' vs. Precipitation State for SDP Non-Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')



%% subplot for each time period: each time period

ytext = 'Average 20-Year Unmet Domestic Demands';
storage_vals = [50:10:150];
T_vals = {'T State: 26.25 C','T State: 26.75 C', 'T State: 27.25 C', 'T State: 27.95 C', 'T State: 28.8 C'}

figure

for t = 1:5
    subplot(1,5,t)
    maxval = 0;
    for s = 1:length(storage_vals)
        filename = strcat('Oct062021sdp_adaptive_unmet_domagCost21_s',string(storage_vals(s)),'.mat');
        load(filename)
        %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
        
        maxval = max(max(unmet_dom(:,18:49),[],'all'), maxval);
        plot([49:1:119],(unmet_dom(t,:))')
        hold on
    end
    hold on
    xline(66,'--')
    hold on
    xline(97,'--')
    xlabel('Precipitation State (mm/month)')
    ylabel(strcat(ytext, '(m^3)'))
    ylim([0,maxval])
    %xlim([49,120])
    xlim([66,97])
    title(T_vals(t))
    if t == 1
        legend('50 MCM','60 MCM', '70 MCM', '80 MCM', '90 MCM',...
            '100 MCM', '110 MCM', '120 MCM', '130 MCM', '140 MCM',...
            '150 MCM')
    end
end

sgtitle({strcat(ytext,' vs. Precipitation State for SDP Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')


%% Plot adaptive and non-adaptive on same plot

ytext = 'Shortage Cost';
storage_vals = [50:10:150];
T_vals = {'T State: 26.25 C','T State: 26.75 C', 'T State: 27.25 C', 'T State: 27.95 C', 'T State: 28.8 C'}


for z = 2
    figure
    for t = 1:5
        subplot(1,5,t)
        
        for s = 1:length(storage_vals)
            maxval = 0;
            if z == 1
                filename = strcat('Oct062021sdp_nonadaptive_shortage_cost_domagCost21_s',string(storage_vals(s)),'.mat');
                load(filename)
                %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
                yval = shortageCost(5,18);
                maxval = max([yval, maxval]);

                plot([66:1:97],(shortageCost(t,18:49))')
                hold on
            else
                for s = 1:length(storage_vals)
                    filename = strcat('Oct062021sdp_adaptive_shortage_cost_domagCost21_s',string(storage_vals(s)),'.mat');
                    load(filename)
                    %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
                    
                    plot([66:1:97],(shortageCost(t,18:49))')
                    hold on
                end
            end
            hold on
            xlabel('Precipitation State (mm/month)')
            ylabel(ytext)
            if z == 1
                ylim([0,1E15])
            else
                ylim([0, 1E15])
            end
            %xlim([49,120])
            xlim([66,97])
            title(T_vals(t))
            if t == 1
                legend('50 MCM','60 MCM', '70 MCM', '80 MCM', '90 MCM',...
                    '100 MCM', '110 MCM', '120 MCM', '130 MCM', '140 MCM',...
                    '150 MCM')
            end
        end
    end
    if z == 1
        sgtitle({strcat(ytext,' vs. Precipitation State for SDP Non-Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')
    else
        sgtitle({strcat(ytext,' vs. Precipitation State for SDP Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')
    end
end

%%
%% Plot adaptive and non-adaptive average 20-year shortage costs on same plot

ytext = 'Shortage Cost';
storage_vals = [50:10:150];
T_vals = {'T State: 26.25 C','T State: 26.75 C', 'T State: 27.25 C', 'T State: 27.95 C', 'T State: 28.8 C'}
%colors = {'#EDB120', '#77AC30', '#D95319', '#7E2F8E', '#FF00FF', '#4DBEEE','#00FF00','#00FFFF', 'black','#0072BD','#A2142F'}
C = linspecer(11,'sequential'); 

figure
for t = 1:5
    subplot(1,5,t)
    
    for s = 1:length(storage_vals)
        filename = strcat('Oct172021sdp_nonadaptive_shortage_cost_domagCost231_s',string(storage_vals(s)),'.mat');
        load(filename)
        %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
        
        %plot([66:1:97],(shortageCost(t,18:49))','Color',C(s,:))
        plot([49:1:119],(shortageCost(t,:))','Color',C(s,:))
        hold on
    end
    for s = 1:length(storage_vals)
        filename = strcat('Oct172021sdp_adaptive_shortage_cost_domagCost231_s',string(storage_vals(s)),'.mat');
        load(filename)
        %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
        
        %plot([66:1:97],(shortageCost(t,18:49))','LineStyle','--','Color',C(s,:))
                plot([49:1:119],(shortageCost(t,:))','LineStyle','--','Color',C(s,:))
        hold on
    end
    xlabel('Precipitation State (mm/month)')
    ylabel(ytext)
    xlim([49,120])
    %xlim([66,97])
    ylim([0,1E15])
    title(T_vals(t))
end
hold on

legend('50 MCM','60 MCM', '70 MCM',...
    '80 MCM', '90 MCM',...
    '100 MCM', '110 MCM', '120 MCM', '130 MCM', '140 MCM',...
    '150 MCM')

sgtitle({strcat(ytext,' vs. Precipitation State for SDP Adaptive and Non-Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')


%% bar plot comparison of average 20-year shortage costs from adaptive and non-adaptive policies

storage_vals = [50:10:150];
T_vals = {'T State: 26.25 C','T State: 26.75 C', 'T State: 27.25 C', 'T State: 27.95 C', 'T State: 28.8 C'}

figure

for f = 1:2
    figure
    if f == 1
        storage_vals = [50:10:100]
    else
        storage_vals = [110:10:150]
    end
    for s = 1:length(storage_vals)
        subplot(6,1,s)
        
        filename = strcat('Oct062021sdp_nonadaptive_shortage_cost_domagCost21_s',string(storage_vals(s)),'.mat');
        load(filename)
        nonadaptive = shortageCost(t,18:49);

        filename = strcat('Oct062021sdp_adaptive_shortage_cost_domagCost21_s',string(storage_vals(s)),'.mat');
        load(filename)
        %load(strcat('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\)
        
        adaptive = shortageCost(t,18:49);
        
        bar([nonadaptive', adaptive'])
        xticks([1:1:32])
        xticklabels([66:1:97])
        legend('SDP non-adaptive dam','SDP adaptive dam')
        xlabel('Precipitation State')
        ylabel('Shortage Cost')
        title(strcat(string(storage_vals(s)),' MCM Dam'))
    end
    
    sgtitle({strcat('Shortage Cost vs. Precipitation State for SDP Adaptive and Non-Adaptive Dams');'Quadratic Shortage Cost Formulation via Objective Function'},'FontWeight','bold')
end
    
%% Runoff

figure
for T=1:5
    subplot(1,5,T)
    qq = NaN(32,100*12*20);
    for P=1:32
        qq(P,:)  = reshape(runoff{T,P,1},1,100*12*20); % inflow 
    end
    boxplot(qq')
    xticks([1:4:32])
    xticklabels({'1','5','9','13','17','21','25','29'})
    xlabel('Precipitaiton State')
    if T==1
        ylabel('Inflow (MCM/Y)')
    end
    title(strcat('T state: ',string(T)'))
end
sgtitle({'Boxplot of Inflow into Mwache Dam';'100 Scenarios per Climate State'})

figure
for T=1:5
    subplot(1,5,T)
    qq = NaN(32,100*12*20);
    for P=1:32
        qq(P,:)  = reshape(runoff{T,P,1},1,100*12*20); % inflow 
    end
    boxplot(qq','Symbol',' ')
    xticks([1:4:32])
    xticklabels({'1','5','9','13','17','21','25','29'})
    xlabel('Precipitaiton State')
    if T==1
        ylabel('Inflow (MCM/Y)')
    end
    ylim([0,350])
    title(strcat('T state: ',string(T)'))
end
sgtitle({'Boxplot of Inflow into Mwache Dam';'100 Scenarios per Climate State'})

%%

ytext = 'Objective Function';

% 55 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s55.mat')
nonadapt55 = objective;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s55.mat')
adapt55 = objective;

% 85 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s85.mat')
nonadapt85 = objective;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s85.mat')
adapt85 = objective;

% 125 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s125.mat')
nonadapt125 = objective;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s125.mat')
adapt125 = objective;

% Plot
figure

% 55 MCM
subplot(3,2,1)
plot(nonadapt55')
title({'SDP Non-Adaptive Ops.';'55 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

subplot(3,2,2)
plot(adapt55')
title({'SDP Adaptive Ops.','55 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 85 MCM
subplot(3,2,3)
plot(nonadapt85')
title({'85 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

subplot(3,2,4)
plot(adapt85')
title({'85 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 125 MCM
subplot(3,2,5)
plot(nonadapt125')
title({'125 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

subplot(3,2,6)
plot(adapt125')
title({'125 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

sgtitle(strcat(ytext,' vs. Precipitation State'),'FontWeight','bold')

%% Shortage Cost Difference

ytext = 'Difference in Shortage Cost';

% 55 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\Oct062021sdp_nonadaptive_shortage_cost_domagCost21_s50.mat')
nonadapt55 = shortageCost;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\Oct062021sdp_adaptive_shortage_cost_domagCost21_s50.mat')
adapt55 = shortageCost;

% 85 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s85.mat')
nonadapt85 = shortageCost;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s85.mat')
adapt85 = shortageCost;

% 125 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s125.mat')
nonadapt125 = shortageCost;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s125.mat')
adapt125 = shortageCost;

% Plot
figure

% 55 MCM
subplot(3,1,1)
plot((nonadapt55-adapt55)')
title({'55 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 85 MCM
subplot(3,1,2)
plot((nonadapt85-adapt85)')
title({'85 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 125 MCM
subplot(3,1,3)
plot((nonadapt125-adapt125)')
title({'125 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

sgtitle(strcat(ytext,' vs. Precipitation State'),'FontWeight','bold')

%% Objective Function DIfference

%% Shortage Cost Difference

ytext = 'Difference in Objective Function';

% 55 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s55.mat')
nonadapt55 = objective;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s55.mat')
adapt55 = objective;

% 85 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s85.mat')
nonadapt85 = objective;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s85.mat')
adapt85 = objective;

% 125 MCM
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_nonadaptive_shortage_cost_domagCost21_RCP85_s125.mat')
nonadapt125 = shortageCost;
load('C:\Users\kcuw9\Documents\Mwache_Dam\SDP_reservoir_ops\post_process_sdp_reservoir_results\V25sdp_adaptive_shortage_cost_domagCost21_RCP85_s125.mat')
adapt125 = shortageCost;

% Plot
figure

% 55 MCM
subplot(3,1,1)
plot((nonadapt55-adapt55)')
title({'55 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 85 MCM
subplot(3,1,2)
plot((nonadapt85-adapt85)')
title({'85 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

% 125 MCM
subplot(3,1,3)
plot((nonadapt125-adapt125)')
title({'125 MCM'})
xlabel('Precipitation State')
ylabel(ytext)

sgtitle(strcat(ytext,' vs. Precipitation State'),'FontWeight','bold')
