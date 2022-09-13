% Mwache Meeting Follow-up Plots (3/15)

%% Shortage Cost Plot (not subplots, use T state =1)

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storages = [50 80 100 120 150]; % MCM
cprime = 1.25E-6;

% set the shortagecost folder path
folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/'
%folder = 'Data/Nov02post_process_sdp_reservoir_results/';
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
        p = plot(s_P_abs,scost_nonadapt,'LineWidth',1.2);
    else % adaptive ops
        p = plot(s_P_abs,scost_adapt,'--','LineWidth',1.2);
    end
    
    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880]};
    for j=1:length(storages)
        p(j).Color = colors{j};
    end
    
    grid minor
    grid on
    xlabel('Precipitation State (mm/mo)')
    ylabel('Shortage Cost ($)')
    xlim([s_P_abs(1),s_P_abs(end)]);
    hold on
end
title({'07May2022 linearCost';'Shortage Cost vs. Dam Capacity'},'FontWeight','bold')

% add legend
leg1 = legend(strcat(string(storages), " MCM"),'Location','NorthEast','AutoUpdate','off');
l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--');
title(leg1,'Dam Capacity')
leg1.Title.Visible = 'on';
ah1=axes('position',get(gca,'position'),'visible','off');
leg2 = legend(ah1, [l1 l2], "Static Ops.", "Flexible Ops.",'Location','SouthEast');
title(leg2,'Dam Ops.')
leg2.Title.Visible = 'on';

%% Shortage Cost Plot comparison (not subplots, use T state =1)

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storages = [50 80 100 120 150]; % MCM

% set the shortagecost folder path
%folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/';
folder = 'Data/May19post_process_sdp_reservoir_results_p10inflow/';
%folder = 'Data/Nov02post_process_sdp_reservoir_results/';
scost_adapt = zeros(length(s_P_abs),length(storages));
scost_nonadapt = zeros(length(s_P_abs),length(storages));


f=figure();
t = tiledlayout(1,2,'Padding','compact');

% make data matrix for plots
for file = 1:2
    if file ==1
        folder = 'Data/Nov02post_process_sdp_reservoir_results/';
        cprime = 1;%1.25E-6;
    else
        %folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/';
        folder = 'Data/May19post_process_sdp_reservoir_results_p10inflow/';
        cprime = 1;
        %if file == 2
        %    cprime = 1.72;
        %else
        %    cprime = 2.45;
        %end
    end
    
    for s=1:length(storages)
        s_now = storages(s);
        
        for t=1
            tidx = t;
            load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
            % save shortage cost in new matrix
            scost_adapt(:,s) = shortageCost(1,:).*cprime./1E6;
        end
    end
    
    %nexttile()
    if file == 1 % Nov02
        p = plot(s_P_abs,scost_adapt,'-','LineWidth',1.2);
        for l = 1:length(storages)
            leglines{l} = p(l);
        end
    elseif file == 2
        p = plot(s_P_abs,scost_adapt,'--','LineWidth',1.2);
    else
        p = plot(s_P_abs,scost_adapt,'-.','LineWidth',1.2);
    end
    
    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880]};
    for j=1:length(storages)
        p(j).Color = colors{j};
    end
    hold on
end
title({'18May2022 90p';'Shortage Cost vs. Dam Capacity'},'FontWeight','bold')
grid minor
grid on
xlabel('Precipitation State (mm/mo)')
ylabel('Shortage Cost (M$)')
xlim([s_P_abs(1),s_P_abs(end)]);
hold on

% add legend
leg1 = legend(strcat(string(storages), " MCM"),'Location','NorthEast','AutoUpdate','off');
l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-');
l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--');
l3 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-.');
title(leg1,'Dam Capacity')
leg1.Title.Visible = 'on';
ah1=axes('position',get(gca,'position'),'visible','off');
% leg2 = legend(ah1, [l1 l2 l3], "02Nov2021", "07May2022 linearCost (c'=1.72)",...
%     "07May2022 linearCost (c'=2.45)",'Location','SouthEast');
leg2 = legend(ah1, [l1 l2], "02Nov2021 quadraticCost (c'=1)", "18May2022 p90 (c'=1)",...
    'Location','SouthEast');
title(leg2,'Dam Ops.')
leg2.Title.Visible = 'on';

%% Shortage Cost vs. Climate State Plots:

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
folder = 'Data/Nov02post_process_sdp_reservoir_results/';
storages = 30:10:150;
pstates = 66:4:97;
cprime = 2.85e-7; %1.25e-6;
scost = cell(length(s_T_abs),2);

% make data matrix for plots
for t=1:length(s_T_abs)
    tidx = t;
    scost_nonadapt = zeros(length(storages),length(pstates));
    scost_adapt = zeros(length(storages),length(pstates));
    for p=1:length(pstates)
        pidx = ismember(s_P_abs,pstates(p));
        for s = 1:length(storages)
            s_now = storages(s);
            
            % load the data
            load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
            scost_nonadapt_all = shortageCost;
            load(strcat(folder,'sdp_adaptive_shortage_cost_s',string(s_now),'.mat'));
            scost_adapt_all = shortageCost;
            
            % save shortage cost in new matrix
            scost_nonadapt(s,p) = scost_nonadapt_all(tidx,pidx).*cprime;
            scost_adapt(s,p) = scost_adapt_all(tidx,pidx).*cprime;
            
        end
    end
    
    scost{t,1} = scost_nonadapt;
    scost{t,2} = scost_adapt;
    
end

f=figure();
tile = tiledlayout(2,4);
%cols = cbrewer('div','Spectral',length(s_T_abs));
cols = [[0.6350 0.0780 0.1840];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];...
    [0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.4940 0.1840 0.5560]];

clear splt
for plt = 1:length(pstates)
    nexttile
    for t=1:length(s_T_abs)
        splt{t} = plot(storages, scost{t,1}(:,plt)/1E6,'-','Color',cols(t,:),...
            'DisplayName', strcat(string(s_T_abs(t)), " deg. C"));
        eval(['splt' num2str(plt) '= splt'])
        hold on
        plot(storages, scost{t,2}(:,plt)/1E6,'--','Color',cols(t,:))
        hold on
        grid(gca,'minor')
        grid('on')
    end
    xlim([50,150])
    %ylim([0,6E2])
    %xlabel('Dam Storage Capacity (MCM)')
    %ylabel('Shortage Cost (M$)')
    title(strcat("Precip. State: ",string(pstates(plt))," mm/mo"))
end

if plt == length(pstates)
    l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-');
    l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--');
    leglines = [splt{:}];
    leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),'Location','NorthEast');
    title(leg1,'Temp. State')
    leg1.Title.Visible = 'on';
    ah1=axes('position',get(gca,'position'),'visible','off');
    leg2 = legend(ah1, [l1 l2], "Static Ops.", "Flexible Ops.",'Location','SouthEast');
    title(leg2,'Dam Ops.')
    leg2.Title.Visible = 'on';
end
title(tile,{'Shortage Cost vs. Dam Storage';"c' = 2.85E-7"},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Shortage Cost (M$)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

%% (Apr 06) Shortage Cost vs. Climate State Plots for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
f=figure();
tile = tiledlayout(2,3);
title(tile,{'Adaptive Shortage Cost vs. Dam Storage';"c' = 1.25E-6"},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Shortage Cost (M$)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

for j=1:2 % for Nov02, Apr06, and Apr08 results:
    if j==1
        folder = 'Data/Nov02post_process_sdp_reservoir_results/';
    elseif j==2
        folder = 'Data/May19post_process_sdp_reservoir_results_p10inflow/';
    else
        folder = 'Data/Apr08post_process_sdp_reservoir_results/';
    end
    storages = 50:10:150;
    %pstates = 66:4:97;
    pstates = [58,62,66,70,74,78]; % subset of precipitation states
    cprime = 1.25e-6;
    scost = cell(length(s_T_abs),2);
    
    % make data matrix for plots
    for t=1:length(s_T_abs)
        tidx = t;
        scost_nonadapt = zeros(length(storages),length(pstates));
        scost_adapt = zeros(length(storages),length(pstates));
        for p=1:length(pstates)
            if j==3
                pidx = ismember(s_P_abs,pstates(p));
            else
                pidx = p;
            end
            for s = 1:length(storages)
                s_now = storages(s);
                
                % load the data
                %load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
                %scost_nonadapt_all = shortageCost;
                load(strcat(folder,'sdp_adaptive_shortage_cost_s',string(s_now),'.mat'));
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
            if j==2
                splt{t} = plot(storages, scost{t,2}(:,plt)/1E6,'-','Color',cols(t,:),...
                    'DisplayName', strcat(string(s_T_abs(t)), " deg. C"),'LineWidth',1.5); % adaptive ops
                eval(['splt' num2str(plt) '= splt'])
            elseif j==3
                plot(storages, scost{t,2}(:,plt)/1E6,'--','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            else
                plot(storages, scost{t,2}(:,plt)/1E6,'-.','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
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
    if plt == length(pstates) && j==2
        l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-','LineWidth',1.5);
        hold on
        l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--','LineWidth',1.5);
        hold on
        l3 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-.','LineWidth',1.5);
        leglines = [splt{:}];
        leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),'Location','NorthEast');
        title(leg1,'Temp. State')
        leg1.Title.Visible = 'on';
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1, [l2 l1], "02Nov2021", "18May2022 p10inflow",...
            'Location','SouthEast');
        title(leg2,'Runoff Data File')
        leg2.Title.Visible = 'on';
    end
end

% boxplot of runoff from each data file
figure()
tile = tiledlayout(2,3);
title(tile,{'Boxplot of Runoff Data'},'fontweight','bold')
xlabel(tile,'Runoff Data File','fontweight','bold')
ylabel(tile,'Runoff (m^3/d)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

folder = 'SDP_reservoir_ops/data/';
pstates = [58,62,66,70,74,78]; % subset of precipitation states

%load the runoff data
runoffdata = NaN(21*2400,3);
for p=1:length(pstates)
    groups = [repmat({'08Apr2022'},size(runoffdata,1),1);...
     repmat({'06Apr2022'},size(runoffdata,1),1);repmat({'02Nov2021'},size(runoffdata,1),1)];
    load(strcat(folder,'runoff_by_state_02Nov2021.mat'))
    runoffdata(:,3) = reshape(runoff{1,ismember(s_P_abs,pstates(p))},[],1);
    load(strcat(folder,'Runoff_NoExtremes_98perc_6Apr2022.mat'))
    runoffdata(:,2) = reshape(runoff{1,p},[],1);
    load(strcat(folder,'Runoff_NoExtremes_98perc_invCDF_8Apr2022.mat'))
    runoffdata(:,1) = reshape(runoff{1,p},[],1);
    
    nexttile(p)
    boxplot(runoffdata,'Widths',0.2,'OutlierSize',5,'Symbol','x','BoxStyle','filled')
    %ylim([0,250])
    xticklabels({'08Apr2022','06Apr2022','02Nov2021'});
    title(strcat("Precip. State: ",string(pstates(p))," mm/mo"))
    box 'on'
        
    whisks = findobj(gca,'Tag','Whisker');
    outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
    meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
    set(meds(:),'Color','k');
    set(whisks(1),'Color',[148, 210, 189]/255);
    set(whisks(2),'Color',[10, 147, 150]/255);
    set(whisks(3),'Color',[0, 95, 115]/255); 
    set(outs(1),'MarkerEdgeColor',[148, 210, 189]/255);
    set(outs(2),'MarkerEdgeColor',[10, 147, 150]/255);
    set(outs(3),'MarkerEdgeColor',[0, 95, 115]/255);
%     set(outs(1),'MarkerEdgeColor','w');
%     set(outs(2),'MarkerEdgeColor','w');
%     set(outs(3),'MarkerEdgeColor','w');
    a = findobj(gca,'Tag','Box');
    set(a(1),'Color',[148, 210, 189]/255,'LineWidth',30);
    set(a(2),'Color',[10, 147, 150]/255,'LineWidth',30);
    set(a(3),'Color',[0, 95, 115]/255,'LineWidth',30);
    
    hold on
    means = mean(runoffdata);
    p1=plot([1:3],means(:), 'k.');
    %plot(2,means(max(P_state_adapt(Idx_bestPlan_adapt,:),[],2)), 'k.');
    set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
    if p==length(pstates)
        legend([p1, meds(1)],{'Mean Runoff','Median Runoff'},'Location','northwest')
    end
    

    hold on
end
%% (Apr 11) Shortage Cost vs. Climate State Plots for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
f=figure();
tile = tiledlayout(2,4);%(2,3);
title(tile,{'Adaptive Shortage Cost vs. Dam Storage'},'fontweight','bold')
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
        folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/';
    %elseif j==1
        %folder = 'Data/Apr08post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12post_process_sdp_reservoir_results/';
    %elseif j==3
        %folder = 'Data/Apr11post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12v3post_process_sdp_reservoir_results/';
    else
        %folder = 'Data/Apr08post_process_sdp_reservoir_results/';
        %folder = 'Data/Apr12v3post_process_sdp_reservoir_results_H2OBalance/';
        folder = 'Data/May07post_process_sdp_reservoir_results_linearCost/';
    end
    storages = 50:10:150;
    %pstates = 66:4:97;
    pstates = [66:4:96];%[58,62,66,70,74,78]; % subset of precipitation states
    if j==3
        cprime = 1.25e-6;
    elseif j==2
       cprime = 1.72;
    else
       cprime = 2.45;
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
                load(strcat(folder,'sdp_adaptive_shortage_cost_s',string(s_now),'.mat'));
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
        leg2 = legend(ah1, [l1 l3 l2], "02Nov2021 (c':1.25E-6)","07May2022 linearCost (c':2.45)",...
            "07May2022 linearCost (c':1.72)",'Location','SouthEast',...
            'FontSize',8);
        title(leg2,'Runoff Data File Date')
        leg2.Title.Visible = 'on';
    end
end

%% boxplot of runoff from each data file
figure()
tile = tiledlayout(2,3);
title(tile,{'Boxplot of Runoff Data'},'fontweight','bold')
xlabel(tile,'Runoff Data File','fontweight','bold')
ylabel(tile,'Runoff (m^3/d)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

folder = 'SDP_reservoir_ops/data/';
pstates = [58,62,66,70,74,78]; % subset of precipitation states

%load the runoff data
runoffdata = NaN(21*2400,4);
for p=1:length(pstates)
    groups = [repmat({'08Apr2022'},size(runoffdata,1),1);...
     repmat({'06Apr2022'},size(runoffdata,1),1);repmat({'02Nov2021'},size(runoffdata,1),1)];
    load(strcat(folder,'runoff_by_state_02Nov2021.mat'))
    runoffdata(:,4) = reshape(runoff{1,ismember(s_P_abs,pstates(p))},[],1);
    load(strcat(folder,'Runoff_NoExtremes_98perc_6Apr2022.mat'))
    runoffdata(:,2) = reshape(runoff{1,p},[],1);
    load(strcat(folder,'Runoff_NoExtremes_98perc_invCDF_8Apr2022.mat'))
    runoffdata(:,1) = reshape(runoff{1,p},[],1);
    
    
    nexttile(p)
    boxplot(runoffdata,'Widths',0.2,'OutlierSize',5,'Symbol','x','BoxStyle','filled')
    %ylim([0,250])
    xticklabels({'08Apr2022','06Apr2022','02Nov2021'});
    title(strcat("Precip. State: ",string(pstates(p))," mm/mo"))
    box 'on'
        
    whisks = findobj(gca,'Tag','Whisker');
    outs = findobj(gca, 'type', 'line','Tag', 'Outliers');
    meds = findobj(gca, 'type', 'line', 'Tag', 'Median');
    set(meds(:),'Color','k');
    set(whisks(1),'Color',[148, 210, 189]/255);
    set(whisks(2),'Color',[10, 147, 150]/255);
    set(whisks(3),'Color',[0, 95, 115]/255); 
    set(outs(1),'MarkerEdgeColor',[148, 210, 189]/255);
    set(outs(2),'MarkerEdgeColor',[10, 147, 150]/255);
    set(outs(3),'MarkerEdgeColor',[0, 95, 115]/255);
%     set(outs(1),'MarkerEdgeColor','w');
%     set(outs(2),'MarkerEdgeColor','w');
%     set(outs(3),'MarkerEdgeColor','w');
    a = findobj(gca,'Tag','Box');
    set(a(1),'Color',[148, 210, 189]/255,'LineWidth',30);
    set(a(2),'Color',[10, 147, 150]/255,'LineWidth',30);
    set(a(3),'Color',[0, 95, 115]/255,'LineWidth',30);
    
    hold on
    means = mean(runoffdata);
    p1=plot([1:3],means(:), 'k.');
    %plot(2,means(max(P_state_adapt(Idx_bestPlan_adapt,:),[],2)), 'k.');
    set(gca, 'YGrid', 'on', 'YMinorGrid','on', 'XGrid', 'off');
    if p==length(pstates)
        legend([p1, meds(1)],{'Mean Runoff','Median Runoff'},'Location','northwest')
    end
    

    hold on
end

%% (Apr 06) Time series of storage for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storages = 50:10:180;
%pstates = 66:4:97;
pstates = [58,62,66,70,74,78]; % subset of precipitation state
gcms = [2,8,14];

for g=1:length(gcms) % for each GCM and each P state, make new figure
    gcmidx = gcms(g);
    for t=1
        tidx = t;
        for p=1:length(pstates)

            % load and plot the storage and runoff time series
            % each column is a different runoff file type
            for s = 1:length(storages)
                s_now = storages(s);
                
                % set up figure
                if rem(s-1,5) == 0
                    figure('units','normalized','outerposition',[0 0 1 1])
                    %tile = tiledlayout(5,3);
                    sgtitle({strcat("Precip. State: ",string(pstates(p))," mm/mo (GCM ",string(gcmidx),")");strcat('Adaptive Active Storage Level vs. Time (',string(ceil(s/5)),"/3)")},'fontweight','bold')
                    %xlabel(tile,'Month','fontweight','bold')
                    %ylabel(tile,'Storage Level','fontweight','bold')
%                     tile.TileSpacing = 'compact';
%                     tile.Padding = 'compact';
                end
                
                for j=1:3 % for each runoff data file type
                    if j==3
                        pidx = find(s_P_abs==pstates(p));
                    else
                        pidx = p;
                    end
            
                    
                    %nexttile
                    if (j + 3*(s-1)-15*(ceil(s/5)-1))/3<=1
                        subplot(5,3,j + 3*(s-1)-15*(ceil(s/5)-1))
                        if j==1
                            title({'06Apr2022';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        elseif j==2
                            title({'08Apr2022';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        else
                            title({'02Nov2021';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        end
                        
                        % plot runoff time series
                        if j==1
                            load('SDP_reservoir_ops/data/Runoff_NoExtremes_98perc_6Apr2022.mat');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            title({'06Apr2022';'Runoff Time Series'})
                        elseif j==2
                            load('SDP_reservoir_ops/data/Runoff_NoExtremes_98perc_invCDF_8Apr2022.mat');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            title({'08Apr2022';'Runoff Time Series'})
                        else
                            load('SDP_reservoir_ops/data/runoff_by_state_02Nov2021.mat');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            title({'02Nov2021';'Runoff Time Series'})
                        end
                        box 'on'
                        xlim([0,2400])
                        grid(gca,'minor')
                        grid('on')
                    elseif (j + 3*(s-1))>1
                        subplot(5,3,j + 3*(s-1)-15*(ceil(s/5)-1))
                        if j==1
                            folder = 'Data/Apr06sdp_reservoir_ops_SteadyState/';
                            load(strcat(folder,'Apr062021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_040622.mat'));
                            p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
                                'LineStyle','-','Color',[10, 147, 150]/255);
                            ylabel('Storage (MCM)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Storage Time Series")})
                        elseif j==2
                            folder = 'Data/Apr08sdp_reservoir_ops_SteadyState/';
                            load(strcat(folder,'Apr082021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_040622.mat'));
                            p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
                                'LineStyle','-','Color',[0, 95, 115]/255);
                            ylabel('Storage (MCM)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Storage Time Series")})
                            
                        else
                            folder = 'Data/Nov02sdp_reservoir_ops_SteadyState/';
                            load(strcat(folder,'Nov022021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_100821.mat'));
                            p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
                                'LineStyle','-','Color',[148, 210, 189]/255);
                            ylabel('Storage (MCM)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Storage Time Series")})
                        end
                        xlabel('Month')
                        box 'on'
                        xlim([0,2400])
                        %ylim([0,s_now])
                        grid(gca,'minor')
                        grid('on')
                    end
                end
                if ((j + 3*(s-1)-15*(ceil(s/5)-1)) == 15) || (s_now ==180)
                    ceil((j + 3*(s-1))/15)
                    savefig(strcat('C:/Users/kcuw9/Downloads/storagets_gcm',string(gcmidx),'_sp',string(pstates(p)),'_s',string(s_now-10*ceil(s/5)),'_part',string(ceil((j + 3*(s-1))/15)),'of3'))
                end
            end
        end
    end
end

%% (Apr 06) Time series of storage for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
storages = 50:10:180;
%pstates = 66:4:97;
pstates = [58,62,66,70,74,78]; % subset of precipitation state
gcms = [2,8,14];

for g=1:length(gcms) % for each GCM and each P state, make new figure
    gcmidx = gcms(g);
    for t=1
        tidx = t;
        for p=1:length(pstates)

            % load and plot the storage and runoff time series
            % each column is a different runoff file type
            for s = 1:length(storages)
                s_now = storages(s);
                
                % set up figure
                if rem(s-1,5) == 0
                    figure('units','normalized','outerposition',[0 0 1 1])
                    %tile = tiledlayout(5,3);
                    sgtitle({strcat("Precip. State: ",string(pstates(p))," mm/mo (GCM ",string(gcmidx),")");strcat('Adaptive Active Storage Level vs. Time (',string(ceil(s/5)),"/3)")},'fontweight','bold')
                    %xlabel(tile,'Month','fontweight','bold')
                    %ylabel(tile,'Storage Level','fontweight','bold')
%                     tile.TileSpacing = 'compact';
%                     tile.Padding = 'compact';
                end
                
                for j=1 % for each runoff data file type
                    if j==3
                        pidx = find(s_P_abs==pstates(p));
                    else
                        pidx = p;
                    end
            
                    
                    %nexttile
                    if (j + 3*(s-1)-15*(ceil(s/5)-1))/3<=1
                        %subplot(5,3,j + 3*(s-1)-15*(ceil(s/5)-1))
                        subplot(5,1,j + 1*(s-1)-5*(ceil(s/5)-1))
                        if j==1
                            title({'11Apr2022';strcat(string(s_now)," MCM Dam Spill Time Series")})
                            %title({'06Apr2022';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        elseif j==2
                            title({'08Apr2022';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        else
                            title({'02Nov2021';strcat(string(s_now)," MCM Dam Storage Time Series")})
                        end
                        
                        % plot runoff time series
                        if j==1
                            %load('SDP_reservoir_ops/data/Runoff_NoExtremes_98perc_6Apr2022.mat');
                            load('SDP_reservoir_ops/data/runoff_modified_98perc_spreadH2O_11Apr2022');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            %title({'06Apr2022';'Runoff Time Series'})
                            title({'11Apr2022';'Runoff Time Series'})
                        elseif j==2
                            load('SDP_reservoir_ops/data/Runoff_NoExtremes_98perc_invCDF_8Apr2022.mat');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            title({'08Apr2022';'Runoff Time Series'})
                        else
                            load('SDP_reservoir_ops/data/runoff_by_state_02Nov2021.mat');
                            rnoff = runoff{1,pidx};
                            p4 = plot(1:length(rnoff(gcmidx,:)),rnoff(gcmidx,:),'k');
                            ylabel('Runoff (m^3/d)')
                            title({'02Nov2021';'Runoff Time Series'})
                        end
                        box 'on'
                        xlim([0,2400])
                        grid(gca,'minor')
                        grid('on')
                    elseif (j + 1*(s-1))>1
                        %subplot(5,3,j + 3*(s-1)-15*(ceil(s/5)-1))
                        subplot(5,1,j + 1*(s-1)-5*(ceil(s/5)-1))
                        if j==1
                            %folder = 'Data/Apr06sdp_reservoir_ops_SteadyState/';
                            folder = 'Data/Apr11sdp_reservoir_ops_SteadyState/';
                            %load(strcat(folder,'Apr062021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_040622.mat'));
                            load(strcat(folder,'Apr112021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_040622.mat'));
%                             p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
%                                 'LineStyle','-','Color',[10, 147, 150]/255);
                            p1 = plot(1:length(spill_ts(:,gcmidx)),spill_ts(:,gcmidx),...
                                'LineStyle','-','Color',[10, 147, 150]/255);
                            ylabel('Spill (MCM/Y)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Spill Time Series")})
                        elseif j==2
                            folder = 'Data/Apr08sdp_reservoir_ops_SteadyState/';
                            load(strcat(folder,'Apr082021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_040622.mat'));
                            p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
                                'LineStyle','-','Color',[0, 95, 115]/255);
                            ylabel('Storage (MCM)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Storage Time Series")})
                            
                        else
                            folder = 'Data/Nov02sdp_reservoir_ops_SteadyState/';
                            load(strcat(folder,'Nov022021adaptive_domagCost231_SSTest_st1_sp',string(pidx),'_s',string(s_now-10*ceil(s/5)),'_100821.mat'));
                            p1 = plot(1:length(storage_ts(:,gcmidx)),storage_ts(:,gcmidx),...
                                'LineStyle','-','Color',[148, 210, 189]/255);
                            ylabel('Storage (MCM)')
                            title({strcat(string(s_now-10*ceil(s/5))," MCM Dam Storage Time Series")})
                        end
                        xlabel('Month')
                        box 'on'
                        xlim([0,2400])
                        %ylim([0,s_now])
                        grid(gca,'minor')
                        grid('on')
                    end
                end
                if ((j + 1*(s-1)-5*(ceil(s/5)-1)) == 5) || (s_now ==180)
                    ceil((j + 1*(s-1))/5)
                    savefig(strcat('C:/Users/kcuw9/Downloads/Apr12_MwacheSpillTimeSeries/spillts_gcm',string(gcmidx),'_sp',string(pstates(p)),'_s',string(s_now-10*ceil(s/5)),'_part',string(ceil((j + 1*(s-1))/5)),'of3'))
                    close all
                end
            end
        end
    end
end

%% Mean Storage Level vs. Climate State Plots:

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
folder = 'Data/Mar20post_process_sdp_reservoir_results/';
storages = 30:10:150;
pstates = 66:4:97;
scost = cell(length(s_T_abs),2);

% make data matrix for plots
for t=1:length(s_T_abs)
    tidx = t;
    scost_nonadapt = zeros(length(storages),length(pstates));
    scost_adapt = zeros(length(storages),length(pstates));
    for p=1:length(pstates)
        pidx = ismember(s_P_abs,pstates(p));
        for s = 1:length(storages)
            s_now = storages(s);
            
            % load the data
            load(strcat(folder,'sdp_nonadaptive_storage_s',string(s_now),'.mat'));
            scost_nonadapt_all = storage;
            load(strcat(folder,'sdp_adaptive_storage_s',string(s_now),'.mat'));
            scost_adapt_all = storage; % add the dead storage
            
            % save shortage cost in new matrix
            scost_nonadapt(s,p) = scost_nonadapt_all(tidx,pidx);
            scost_adapt(s,p) = scost_adapt_all(tidx,pidx);
            
        end
    end
    
    scost{t,1} = scost_nonadapt;
    scost{t,2} = scost_adapt;
    
end

f=figure();
tile = tiledlayout(2,4);
%cols = cbrewer('div','Spectral',length(s_T_abs));
cols = [[0.6350 0.0780 0.1840];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];...
    [0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.4940 0.1840 0.5560]];

clear splt
for plt = 1:length(pstates)
    nexttile
    for t=1:length(s_T_abs)
        splt{t} = plot(storages, scost{t,1}(:,plt),'-','Color',cols(t,:),...
            'DisplayName', strcat(string(s_T_abs(t)), " deg. C"));
        eval(['splt' num2str(plt) '= splt'])
        hold on
        plot(storages, scost{t,2}(:,plt),'--','Color',cols(t,:))
        hold on
        grid(gca,'minor')
        grid('on')
    end
    xlim([50,150])
    ylim([0,150])
    %xlabel('Dam Storage Capacity (MCM)')
    %ylabel('Shortage Cost (M$)')
    title(strcat("Precip. State: ",string(pstates(plt))," mm/mo"))
end

if plt == length(pstates)
    l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-');
    l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--');
    leglines = [splt{:}];
    leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),'Location','NorthEast');
    title(leg1,'Temp. State')
    leg1.Title.Visible = 'on';
    ah1=axes('position',get(gca,'position'),'visible','off');
    leg2 = legend(ah1, [l1 l2], "Static Ops.", "Flexible Ops.",'Location','SouthEast');
    title(leg2,'Dam Ops.')
    leg2.Title.Visible = 'on';
end
title(tile,{'Mean Active Storage Level vs. Dam Storage Capacity'},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Mean Active Storage Level (MCM)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';
%% (Apr 06) Storage Level vs. Climate State Plots for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
f=figure();
tile = tiledlayout(2,3);
title(tile,{'Adaptive Mean Storage Level vs. Dam Storage'},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Mean Storage Level (MCM)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

for j=1:3 % for Nov02, Apr06, and Apr08 results:
    if j==3
        folder = 'Data/Mar20post_process_sdp_reservoir_results/';
    elseif j==2
        folder = 'Data/Apr06post_process_sdp_reservoir_storage/';
    else
        folder = 'Data/Apr08post_process_sdp_reservoir_storage/';
    end
    storages = 50:10:150;
    %pstates = 66:4:97;
    pstates = [58,62,66,70,74,78]; % subset of precipitation states
    cprime = 1.25e-6;
    scost = cell(length(s_T_abs),2);
    
    % make data matrix for plots
    for t=1:length(s_T_abs)
        tidx = t;
        scost_nonadapt = zeros(length(storages),length(pstates));
        scost_adapt = zeros(length(storages),length(pstates));
        for p=1:length(pstates)
            if j==3
                pidx = ismember(s_P_abs,pstates(p));
            else
                pidx = p;
            end
            for s = 1:length(storages)
                s_now = storages(s);
                
                % load the data
                %load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
                %scost_nonadapt_all = shortageCost;

                load(strcat(folder,'sdp_adaptive_storage_s',string(s_now),'.mat'));
                scost_adapt_all = storage;
                
                % save shortage cost in new matrix
                %scost_nonadapt(s,p) = scost_nonadapt_all(tidx,pidx).*cprime;
                scost_adapt(s,p) = scost_adapt_all(tidx,pidx);
                
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
                splt{t} = plot(storages, scost{t,2}(:,plt),'-','Color',cols(t,:),...
                    'DisplayName', strcat(string(s_T_abs(t)), " deg. C"),'LineWidth',1.5); % adaptive ops
                eval(['splt' num2str(plt) '= splt'])
            elseif j==2
                plot(storages, scost{t,2}(:,plt),'--','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            else
                plot(storages, scost{t,2}(:,plt),'-.','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            end
            hold on
            grid(gca,'minor')
            grid('on')
        end
        xlim([50,150])
        ylim([0,150])
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
        leglines = [splt{:}];
        leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),'Location','NorthEast');
        title(leg1,'Temp. State')
        leg1.Title.Visible = 'on';
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1, [l1 l2 l3], "02Nov2021", "06Apr2022",...
            "08Apr2022",'Location','SouthEast');
        title(leg2,'Runoff Data File Date')
        leg2.Title.Visible = 'on';
    end
end

%% (Apr 11) Storage Level vs. Climate State Plots for select climates

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]

% set the shortagecost folder path
f=figure();
tile = tiledlayout(2,3);
title(tile,{'Adaptive Mean Storage Level vs. Dam Storage'},'fontweight','bold')
xlabel(tile,'Dam Storage Capacity (MCM)','fontweight','bold')
ylabel(tile,'Mean Storage Level (MCM)','fontweight','bold')
tile.TileSpacing = 'compact';
tile.Padding = 'compact';

splt = cell(5,1);
for j=1:4 % for Nov02, Apr06, and Apr08 results:
    if j==4
        folder = 'Data/Mar20post_process_sdp_reservoir_results/';
    elseif j==2
        folder = 'Data/Apr06post_process_sdp_reservoir_storage/';
    elseif j==1
        folder = 'Data/Apr08post_process_sdp_reservoir_storage/';
    else
        folder = 'Data/Apr11post_process_sdp_reservoir_storage/';
    end
    storages = 50:10:150;
    %pstates = 66:4:97;
    pstates = [58,62,66,70,74,78]; % subset of precipitation states
    cprime = 1.25e-6;
    scost = cell(length(s_T_abs),2);
    
    % make data matrix for plots
    for t=1:length(s_T_abs)
        tidx = t;
        scost_nonadapt = zeros(length(storages),length(pstates));
        scost_adapt = zeros(length(storages),length(pstates));
        for p=1:length(pstates)
            if j==4
                pidx = ismember(s_P_abs,pstates(p));
            else
                pidx = p;
            end
            for s = 1:length(storages)
                s_now = storages(s);
                
                % load the data
                %load(strcat(folder,'sdp_nonadaptive_shortage_cost_s',string(s_now),'.mat'));
                %scost_nonadapt_all = shortageCost;

                load(strcat(folder,'sdp_adaptive_storage_s',string(s_now),'.mat'));
                scost_adapt_all = storage;
                
                % save shortage cost in new matrix
                %scost_nonadapt(s,p) = scost_nonadapt_all(tidx,pidx).*cprime;
                scost_adapt(s,p) = scost_adapt_all(tidx,pidx);
                
            end
        end
        
        %scost{t,1} = scost_nonadapt;
        scost{t,2} = scost_adapt;
        
    end
    
    %cols = cbrewer('div','Spectral',length(s_T_abs));
    cols = [[0.6350 0.0780 0.1840];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];...
        [0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.4940 0.1840 0.5560]];
    
    %clear splt
    for plt = 1:length(pstates)
        nexttile(plt)
        for t=1:2:5 %1:length(s_T_abs)
%             p(t) = plot(storages, scost{t,2}(:,plt)/1E6,'-','Color',cols(t,:),...
%                 'DisplayName', strcat(string(s_T_abs(t)), " deg. C"));
            hold on
            if j==4
                splt{t}=plot(storages, scost{t,2}(:,plt),'-','Color',cols(t,:),...
                    'DisplayName', strcat(string(s_T_abs(t)), " deg. C"),'LineWidth',1.5); % adaptive ops
                %eval(['splt' num2str(plt) '= splt'])
            elseif j==2
                plot(storages, scost{t,2}(:,plt),'--','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            elseif j==1
                plot(storages, scost{t,2}(:,plt),'-.','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            elseif j==3
                plot(storages, scost{t,2}(:,plt),':','Color',cols(t,:),'LineWidth',1.5) % adaptive ops
            end
            hold on
            grid(gca,'minor')
            grid('on')
        end
        xlim([50,150])
        ylim([0,150])
        %ylim([0,6E2])
        %xlabel('Dam Storage Capacity (MCM)')
        %ylabel('Shortage Cost (M$)')
        title(strcat("Precip. State: ",string(pstates(plt))," mm/mo"))
        box 'on'
    end
    if plt == length(pstates) && j==4
        l1 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-','LineWidth',1.5);
        hold on
        l2 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','--','LineWidth',1.5);
        hold on
        l3 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle','-.','LineWidth',1.5);
        hold on
        l4 = plot([-1, -2],[-1,-2],'color', [17 17 17]/255,'linestyle',':','LineWidth',1.5);        
        leglines = [splt{:}];
        leg1 = legend(leglines,strcat(string(s_T_abs), " deg. C"),'Location','NorthEast');
        title(leg1,'Temp. State')
        leg1.Title.Visible = 'on';
        ah1=axes('position',get(gca,'position'),'visible','off');
        leg2 = legend(ah1, [l1 l2 l3 l4], "02Nov2021", "06Apr2022",...
            "08Apr2022","11Apr2022",'Location','SouthEast');
        title(leg2,'Runoff Data File Date')
        leg2.Title.Visible = 'on';
    end
end

%% Cost of design vs. planning Empirical CDF

% ======= Setup and Loading Data =======================

% specify file naming convensions
discounts = [0];
cprimes = [1.25e-6]; %[1.25e-6, 5e-6];
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
    for c = 1 %4%length(cprimes)
        cp = cprimes(c);
        c_prime = regexprep(strrep(string(cp), '.', ''), {'-0'}, {''});
        
        % load adaptive operations files:
        if fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestStatic_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
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
        if fixInitCap == 0 || maxExpTest == 1
            load(strcat(folder,'/BestFlex_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestStatic_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
            load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp',c_prime,'_g7_percFlex5_percExp1_disc',disc,'_50PercExpCapOr120.mat'))
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
    
    % ======== PLOT Cost design/Cost planning vs. F(x) ===================
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
            qtiles = [0:0.0001:1];
            qtile_adapt = quantile(totalCostPnow_adapt, qtiles);
            qtile_nonadapt = quantile(totalCostPnow_nonadapt, qtiles);
            minCostPnow_adapt(i,:) = min(qtile_adapt./qtile_nonadapt(:,2),[],'all');
            minCostPnow_nonadapt(i,:) = min(qtile_nonadapt./qtile_nonadapt(:,2),[],'all');
            minCostPnow(i,:) = min([minCostPnow_adapt(i,:),minCostPnow_nonadapt(i,:)],[],'all');
            
            % max total costs
            maxCostPnow_adapt(i,:) = max(qtile_adapt./qtile_nonadapt(:,2),[],'all');
            maxCostPnow_nonadapt(i,:) = max(qtile_nonadapt./qtile_nonadapt(:,2),[],'all');
            maxCostPnow(i,:) = max([maxCostPnow_adapt(i,:),maxCostPnow_nonadapt(i,:)],[],'all');
            
        end
        
        maxCostPnow_all(j) = max(maxCostPnow)/1E6;
        minCostPnow_all(j) = min(minCostPnow)/1E6;
    end
    
    f = figure;
    
    p1 = patch( [0 0 1 1], [minCostPnow_all(1) minCostPnow_all(1) maxCostPnow_all(1) maxCostPnow_all(1)], facecolors{1},'LineStyle','none');
    p1.FaceVertexAlphaData = 0.0001;
    p1.FaceAlpha = 'flat';
    hold on
    
    p2 = patch( [0 0 1 1], [minCostPnow_all(2) minCostPnow_all(2) maxCostPnow_all(2) maxCostPnow_all(2)], facecolors{2},'LineStyle','none');
    p2.FaceAlpha = 'flat';
    p2.FaceVertexAlphaData = 0.0001;
    hold on
    
    p3 = patch([0 0 1 1], [minCostPnow_all(3) minCostPnow_all(3) maxCostPnow_all(3) maxCostPnow_all(3)], facecolors{3},'LineStyle','none');
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
    qtiles = [0:0.0001:1]; % uniform quantiles to use
    hold on
    %c1 = cdfplot(totalCostStatic_nonadapt/1E6);
    %c1 = cdfplot(totalCostStatic_nonadapt./totalCostFlex_nonadapt);
    q1 = quantile(totalCostStatic_nonadapt/1E6, qtiles);
    c1 = plot(qtiles,q1./q1);
    c1.LineWidth = 3.5;
    c1.Color = facecolors{1};
    hold on
    %c2 = cdfplot(totalCostStatic_adapt/1E6);
    %c2 = cdfplot(totalCostStatic_adapt./totalCostFlex_adapt);
    q2 = quantile(totalCostStatic_adapt/1E6, qtiles);
    c2 = plot(qtiles,q2./q1);
    c2.LineWidth = 3.5;
    c2.Color = facecolors{2};
    %c2.Color = facecolors{1};
    %c2.LineStyle = '--';
    hold on
    %c3 = cdfplot(totalCostFlex_nonadapt/1E6);
    %c3 = cdfplot(totalCostFlex_nonadapt./totalCostFlex_nonadapt);
    q3 = quantile(totalCostFlex_nonadapt/1E6, qtiles);
    c3 = plot(qtiles,q3./q1);
    c3.LineWidth = 3.5;
    c3.Color = facecolors{3};
    hold on
    %c4 = cdfplot(totalCostFlex_adapt/1E6);
    %c4 = cdfplot(totalCostFlex_adapt./totalCostFlex_adapt);
    q4 = quantile(totalCostFlex_adapt/1E6, qtiles);
    c4 = plot(qtiles,q4./q1);
    c4.LineWidth = 3.5;
    c4.Color = facecolors{4};
    %c4.Color = facecolors{3};
    %c4.LineStyle = '--';
    hold on
    %c5 = cdfplot(totalCostPlan_nonadapt/1E6);
    %c5 = cdfplot(totalCostPlan_nonadapt./totalCostFlex_nonadapt);
    q5 = quantile(totalCostPlan_nonadapt/1E6, qtiles);
    c5 = plot(qtiles,q5./q1);
    c5.LineWidth = 3.5;
    c5.Color = facecolors{5};
    hold on
    %c6 = cdfplot(totalCostPlan_adapt/1E6);
    %c6 = cdfplot(totalCostPlan_adapt./totalCostFlex_adapt);
    q6 = quantile(totalCostPlan_adapt/1E6, qtiles);
    c6 = plot(qtiles,q6./q1);
    c6.LineWidth = 3.5;
    c6.Color = facecolors{6};
    %c6.Color = facecolors{5};
    %c6.LineStyle = '--';
    
    legend([c1 c2 c3 c4 c5 c6], {strcat('Static Design & Static Ops.'),...
        strcat('Static Design & Flexible Ops.'),...
        strcat('Flexible Design & Static Ops.'),...
        strcat('Flexible Design & Flexible Ops.'),...
        strcat('Flexible Planning & Static Ops.'),...
        strcat('Flexible Planning & Flexible Ops.')}, 'Location','best')
    xlabel('F(x)')
    ylabel('Total Cost / Total Cost Static Design & Static Ops. (M$)')
    xlim([0,1])
    
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
    
end

%% Infrastructure costs

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

%% Forward Simulations: Never Expand into Transitions to Drier Climates

f = figure();

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

%P_ranges = {[66:1:76];[77:1:86];[87:97]}; % reference dry, moderate, and wet climates
P_ranges = {[66:97]};

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

% forward simulations of shortage and infrastructure costs
totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

for p = 1%:length(P_ranges)
    
    % calculate the average shortage, dam, and expansion costs for each
    % climate state:
    ind_P = ismember(P_state_adapt(:,5),P_ranges{p}); % to any dry climate
    rowsAll = [1:1:length(P_state_adapt)];
    ind_Prows = rowsAll(ind_P); % row number of dry climate transitions from 10000 matrix
    %ind_P = P_state_adapt(:,5) == 72;
    
    
    % P state time series: select associated time series for
    % transitions to the given final climate states:
    Pnow_adapt = P_state_adapt(ind_P,:);
    Pnow_nonadapt = P_state_nonadapt(ind_P,:);
    
    % Actions: select associated simulations
    ActionPnow_adapt = action_adapt(ind_P,:,:);
    ActionPnow_nonadapt = action_nonadapt(ind_P,:,:);
    
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
    
    % ===== Frequency of Final P state vs. Never Expanded =========
    % index rows where flexible dams not expanded
    IdxUnexpStatic_nonadapt = actionPnowStatic_nonadapt(:,1) == actionPnowStatic_nonadapt(:,5);
    IdxUnexpStatic_adapt = actionPnowStatic_adapt(:,1) == actionPnowStatic_adapt(:,5);
    IdxUnexpFlex_nonadapt = actionPnowFlex_nonadapt(:,1) == actionPnowFlex_nonadapt(:,5);
    IdxUnexpFlex_adapt = actionPnowFlex_adapt(:,1) == actionPnowFlex_adapt(:,5);
    IdxUnexpPlan_nonadapt = actionPnowPlan_nonadapt(:,1) == actionPnowPlan_nonadapt(:,5);
    IdxUnexpPlan_adapt = actionPnowPlan_adapt(:,1) == actionPnowPlan_adapt(:,5);
    
    % for each flexible dam type, count number of observations that
    % don't expand for each final climate state
    t = tiledlayout(2,2);
    t.Padding = 'compact';
    t.TileSpacing = 'none';
    nexttile
    h1 = histogram(Pnow_adapt(:,5),'BinMethod','integers','FaceColor',facecolors(3,:),'FaceAlpha',1);
    hold on
    finalP = Pnow_adapt(IdxUnexpFlex_nonadapt,5);
    h2 = histogram(finalP,'BinMethod','integers','FaceColor',[210,210,210]/255,'FaceAlpha',1);
    legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
    grid on
    %xlim([65,77])
    xlim([65,98])
    xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
    ylabel('Frequency','FontWeight','bold')
    title('Flexible Design & Static Ops')
    nexttile
    h1 = histogram(Pnow_adapt(:,5),'BinMethod','integers','FaceColor',facecolors(4,:),'FaceAlpha',1);
    hold on
    finalP = Pnow_adapt(IdxUnexpFlex_adapt,5);
    h2 = histogram(finalP,'BinMethod','integers','FaceColor',[210,210,210]/255,'FaceAlpha',1);
    legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
    grid on
    %xlim([65,77])
    xlim([65,98])
    xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
    ylabel('Frequency','FontWeight','bold')
    title('Flexible Design & Flexible Ops')
    nexttile
    h1 = histogram(Pnow_adapt(:,5),'BinMethod','integers','FaceColor',facecolors(5,:),'FaceAlpha',1);
    hold on
    finalP = Pnow_adapt(IdxUnexpPlan_nonadapt,5);
    h2 = histogram(finalP,'BinMethod','integers','FaceColor',[210,210,210]/255,'FaceAlpha',1);
    %xlim([65,77])
    xlim([65,98])
    legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
    grid on
    xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
    ylabel('Frequency','FontWeight','bold')
    title('Flexible Planning & Static Ops')
    nexttile
    h1 = histogram(Pnow_adapt(:,5),'BinMethod','integers','FaceColor',facecolors(6,:),'FaceAlpha',1);
    hold on
    finalP = Pnow_adapt(IdxUnexpPlan_adapt,5);
    h2 = histogram(finalP,'BinMethod','integers','FaceColor',[210,210,210]/255,'FaceAlpha',1);
    legend([h1 h2],'Expanded','Unexpanded','Location','northwest')
    grid on
    xlim([65,98])
    xlabel('Final Precip. State (mm/mo)','FontWeight','bold')
    ylabel('Frequency','FontWeight','bold')
    title('Flexible Planning & Flexible Ops')
    title(t,'Frequency of Unexpanded Flexible Alternatives by Final Precip. State', 'FontWeight','bold')
    subtitle(t,'Counts of Final Climate State Given Flexible Alternative is Never Expanded')
    
    
    % == SAMPLE FORWARD SIMULATIONS OF UNIQUE P STATE TRANSITIONS ==
    [uP, uPIdxs, ~] = unique(Pnow_adapt, 'rows','stable'); % use these when calling subset climate matrix
    uPIdxAll = ind_Prows(uPIdxs); % use these indices when indexing unique rows among all 10000 simulations
    
    % Make dam capacity time series
    damCapPnowStatic_nonadapt = repmat(bestAct_nonadapt(2),[length(uPIdxs),5]);
    damCapPnowStatic_adapt = repmat(bestAct_adapt(2),[length(uPIdxs),5]);
    damCapPnowFlex_nonadapt = s_C_nonadapt(actionPnowFlex_nonadapt(uPIdxs,:));
    damCapPnowFlex_adapt = s_C_adapt(actionPnowFlex_adapt(uPIdxs,:));
    damCapPnowPlan_nonadapt = s_C_nonadapt(actionPnowPlan_nonadapt(uPIdxs,:));
    damCapPnowPlan_adapt = s_C_adapt(actionPnowPlan_adapt(uPIdxs,:));
    
    % now subindex where flexible design and planning never expanded
    % (~= to look at where both are expanded)
    IdxUnexpFlex_nonadapt = uPIdxAll(damCapPnowFlex_nonadapt(:,end) == damCapPnowFlex_nonadapt(:,1));
    IdxUnexpFlex_adapt = uPIdxAll(damCapPnowFlex_adapt(:,end) == damCapPnowFlex_adapt(:,1));
    IdxUnexpPlan_nonadapt = uPIdxAll(damCapPnowPlan_nonadapt(:,end) == damCapPnowPlan_nonadapt(:,1));
    IdxUnexpPlan_adapt = uPIdxAll(damCapPnowPlan_adapt(:,end) == damCapPnowPlan_adapt(:,1));
    
    % note: common shared indices for dams never expanded:
    IdxUnexp_shared = intersect(intersect(IdxUnexpFlex_nonadapt,IdxUnexpFlex_adapt),intersect(IdxUnexpPlan_nonadapt,IdxUnexpPlan_adapt));
    
    % randomly sample 15 of the shared forward simulation indices
    s = RandStream('mlfg6331_64');
    idxs = randsample(s,IdxUnexp_shared,min(length(IdxUnexp_shared),40)); % sample without replacement
    
    % plot some randomly selected sample forward simulations:
    decade_short = {'2020', '2040', '2060', '2080', '2100'};
    
    % update actions for capacity indexing
    action_adapt_nonzero = action_adapt;
    action_nonadapt_nonzero = action_nonadapt;
    for z = 1:2
        for j=1:4
            for i=2:5
                if z == 1
                    action_adapt_nonzero(action_adapt_nonzero(:,i,j)==0,i,j) ...
                        = action_adapt_nonzero(action_adapt_nonzero(:,i,j)==0,i-1,j);
                else
                    action_nonadapt_nonzero(action_nonadapt_nonzero(:,i,j)==0,i,j) ...
                        = action_nonadapt_nonzero(action_nonadapt_nonzero(:,i,j)==0,i-1,j);
                end
            end
        end
    end
    
    
    for fg = 1:ceil(length(idxs)/5)
        figure
        figure('WindowState','maximized');
        t = tiledlayout(3,5);
        for j = 1:5
            idx = idxs(5*(fg-1)+j); % random sample
            % plot dam capacities
            %subplot(5,3,j+3*(i-1))
            nexttile(j)
            plot(1:5,repmat(bestAct_nonadapt(2),[1,5]),'Color',facecolors(1,:),'LineWidth',1.5)
            hold on
            plot(1:5,repmat(bestAct_adapt(2),[1,5]),'Color',facecolors(2,:),'LineWidth',1.5)
            hold on
            plot(1:5, s_C_nonadapt(action_nonadapt_nonzero(idx,:,1)),'Color',facecolors(3,:),'LineWidth',1.5)
            hold on
            plot(1:5, s_C_adapt(action_adapt_nonzero(idx,:,1)),'Color',facecolors(4,:),'LineWidth',1.5)
            hold on
            plot(1:5, s_C_nonadapt(action_nonadapt_nonzero(idx,:,3)),'Color',facecolors(5,:),'LineWidth',1.5)
            hold on
            plot(1:5, s_C_adapt(action_adapt_nonzero(idx,:,3)),'Color',facecolors(6,:),'LineWidth',1.5)
            
            xlim([1,5])
            ylim([0,160])
            grid('minor')
            grid on
            title('Dam Capacity vs. Time','FontWeight','bold')
            
            % add line for precipitation state over time on secondary axis:
            yyaxis right
            hold on
            p1 = plot(P_state(idx,:),'color','black','LineWidth',1.5);
            labs = string(P_state(idx,:));
            text([1:5],P_state(idx,:)+2,labs,'Fontsize', 8)
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
            h(1) = plot(1:5, damCost_nonadapt(idx,:,2), 'Color',facecolors(1,:),'LineWidth',1.5);
            hold on
            h(2) = plot(1:5, damCost_adapt(idx,:,2),'Color',facecolors(2,:),'LineWidth',1.5);
            hold on
            h(3) = plot(1:5, damCost_nonadapt(idx,:,1),'Color',facecolors(3,:),'LineWidth',1.5);
            hold on
            h(4) = plot(1:5, damCost_adapt(idx,:,1),'Color',facecolors(4,:),'LineWidth',1.5);
            hold on
            h(5) = plot(1:5, damCost_nonadapt(idx,:,3),'Color',facecolors(5,:),'LineWidth',1.5);
            hold on
            h(6) = plot(1:5, damCost_adapt(idx,:,3)+1,'Color',facecolors(6,:),'LineWidth',1.5);
            ylabel('Cost (M$)','FontWeight','bold')
            title('Infrastructure Cost vs. Time','FontWeight','bold')
            grid('minor')
            grid on
            
            xticklabels([]);
            
            
            % plot shortage costs
            nexttile(j+10)
            plot(1:5,  totalCost_nonadapt(idx,:,2)-damCost_nonadapt(idx,:,2), 'Color',facecolors(1,:),'LineWidth',1.5)
            hold on
            plot(1:5, totalCost_adapt(idx,:,2)-damCost_adapt(idx,:,2),'Color',facecolors(2,:),'LineWidth',1.5)
            hold on
            plot(1:5, totalCost_nonadapt(idx,:,1)-damCost_nonadapt(idx,:,1),'Color',facecolors(3,:),'LineWidth',1.5)
            hold on
            plot(1:5,  totalCost_adapt(idx,:,1)-damCost_adapt(idx,:,1),'Color',facecolors(4,:),'LineWidth',1.5)
            hold on
            plot(1:5, totalCost_nonadapt(idx,:,3)-damCost_nonadapt(idx,:,3),'Color',facecolors(5,:),'LineWidth',1.5)
            hold on
            plot(1:5, totalCost_adapt(idx,:,3)-damCost_adapt(idx,:,3),'Color',facecolors(6,:),'LineWidth',1.5)
            
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
            
        end
        hL = legend([h(1), h(2), h(3), h(4), h(5), h(6), p1],{strcat("Static Design & Static Ops"),strcat("Static Design & Flexible Ops"),...
            strcat("Flexible Design & Static Ops"),...
            strcat("Flexible Design & Flexible Ops"),strcat("Flexible Planning & Static Ops"),...
            strcat("Flexible Planning & Flexible Ops"),"Precip. state"},'Orientation','horizontal', 'FontSize', 9);
        
        % Programatically move the Legend
        newPosition = [0.05 0.025 0.9 0.025];
        newUnits = 'normalized';
        set(hL,'Position', newPosition,'Units',newUnits);
        
        title(t,{'Sample Forward Simulations for Dry Climate Transitions'},'FontSize',14, 'FontWeight','bold')
        subtitle(t, strcat("Discount Rate: ", string(discounts(d)),"%"))
        
    end
end

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

%% Plot flexible infrastructure SDP optimal expansion decisions

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
    
    for N=1:5 % for each time period
        
        %ax(N)=subplot(2,5,N+(s-1)*N);
        
        if (s==1) && (N==1) % non-adaptive
            ax(N)=subplot(2,5,[1;6])
            imagesc(s_P_abs,s_T_abs,X(:,:,2,N))
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
            imagesc(s_P_abs,s_T_abs,X(:,:,2,N))
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
                ax(N)=subplot(2,5,N+(flex_type-1)*5);
                if flex_type == 1 % flex design
                    %X(X(:,:,2,N) == 0) = 3;
                    X(X(:,:,2,N) ~= 0) = 1;
                    %imagesc(s_P_abs,s_T_abs,(X(:,:,2,N)-3)/(bestAct(4)+1))
                    imagesc(s_P_abs,s_T_abs,X(:,:,2,N))
                    map = expansion_colors([1,4],:);
                    %step = 1/(2*(1+bestAct(4)));
                    caxis([0, 1])
                    %h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
                    %    'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_flex),"\newlineMCM")]);
                    h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
                        'TickLabels',["Do Not\newlineExpand","Expand"]);
                    %             caxis([2,2+bestAct(4)])
                    title({"Flexible Design Expansion Policy"; decade{N}},'FontWeight','bold')
                else % flexible planning
                    %X(X(:,:,3,N) == 0) = 3+bestAct(4);
                    X(X(:,:,3,N) ~= 0) = 1;
                    %imagesc(s_P_abs,s_T_abs,(X(:,:,3,N)-3-bestAct(4))/(bestAct(9)+1))
                    imagesc(s_P_abs,s_T_abs,X(:,:,3,N))
                    %map = expansion_colors(1:bestAct(9)+1,:);
                    map = expansion_colors([1,4],:);
                    step = 1/(2*(1+bestAct(9)));
                    caxis([0, 1])
                    %                     h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
                    %                         'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_plan),"\newlineMCM")]);
                    h = colorbar('TicksMode','manual','Ticks',[0.25,0.75],...
                        'TickLabels',["Do Not\newlineExpand","Expand"]);
                    %             caxis([2,2+bestAct(4)])
                    title({"Flexible Plan Expansion Policy"; decade{N}},'FontWeight','bold')
                end
                %caxis([2, 2+bestAct(4)]);
                %caxis([1,2])
                colormap(ax(N), map);
                set(gca,'YDir','normal')
                
                ylabel('Mean T [degrees C]','FontWeight','bold')
                xlabel('Mean P [mm/m]','FontWeight','bold')
                box on
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
        exportgraphics(f,filename1,'Resolution',1200)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/adaptive_policy_comb.png'];
        %saveas(f, filename2)
        exportgraphics(f,filename2,'Resolution',1200)
    end
    %close
    %pcolor(X_adapt(:,:,2,N)) % all T states, all P states, initial flex capacity, N time period
end


% stack figures
fcomb = figure;
out = imtile({filename1; filename2},'GridSize',[2,1],'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
title({'Infrastructure and Expansion Policies'},'FontSize',15)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/policyV2_g7_percFlex5_percExp15.png'];
%saveas(fcomb, filename)
%exportgraphics(fcomb,filename,'Resolution',1200);

