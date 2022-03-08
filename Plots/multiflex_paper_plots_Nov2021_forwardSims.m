%% Load data: update data to load

% change default font style
set(groot,'defaultAxesFontName','Futura')

folder = 'SDP_sensitivity_tests/Nov02optimal_dam_design_discount';
cd('C:/Users/kcuw9/Documents/Mwache_Dam')
mkdir('Plots/multiflex_discount')

load(strcat(folder,'/BestFlex_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
bestAct_adapt = bestAct;
V_adapt = V;
%Vs_adapt = Vs;
%Vd_adapt = Vd;
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


load(strcat(folder,'/BestFlex_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
bestAct_nonadapt = bestAct;
V_nonadapt = V;
%Vs_nonadapt = Vs;
%Vd_nonadapt = Vd;
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

mkdir('C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex02Nov_comb/')


%% (OG 1 - Best option as of Nov 30th) Plot all forward simulation time series for different climate states
% Use forward simulation estimates for costs over time

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

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
    [uP, uPIdx, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    for fi = 1%:ceil(size(uPIdx,1)/16)
    uPIdxs = uPIdx(min([1:8]+(fi-1)*8,size(uPIdx,1)));
    figure()
    
    for subP = 1:length(uPIdxs)
    idxP = uPIdxs(subP);
    subplot(4,4,2*subP)
    
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
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Cost (M$)','FontWeight','bold')
    
    yyaxis right
    hold on
    p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
    ylabel('P State (mm/mo)')
    ylim([65,95]);
    xlim([0.5,5.5])
    box on
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
     hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2), p1],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts","Precip.\newlinestate"},'Orientation','horizontal', 'FontSize', 9);

% Programatically move the Legend
newPosition = [0.4 0.05 0.2 0];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
    
    subplot(4,4,2*subP-1)
        allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
        s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
    %yyaxis left
    b = bar(1:5, allRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors(i,:),[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Capacity (MCM)','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
    hold on
%     yyaxis right
%     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
%     plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([70,90]);

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

%hL = legend{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
%     strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
%     string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
%     ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
%     string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9);

% % Programatically move the Legend
% newPosition = [0.4 0.05 0.2 0];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    end
    end
end

%% Stack dry, moderate, wet sample simulation for base-case (discount rate 3%)
% Look at plots above to select interesting/representative forward
% simulations

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

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
    [uP, uPIdx, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    figure()
    
    if p==1 % dry plot index
        idxP = uPIdxs(2);
    elseif p == 2 % moderate plot index
        idxP = uPIdxs(5);
    else % wet plot index
        idxP = uPIdxs(3);
    end

    subplot(1,2,2)
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
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Cost (M$)','FontWeight','bold')
    title('Cost vs. Time','FontWeight','bold')
    
    yyaxis right
    hold on
    p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
    ylabel('P State (mm/mo)')
    ylim([65,95]);
    xlim([0.5,5.5])
    box on
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
    if p == 1
     hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2), p1],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts","Precip.\newlinestate"},'Orientation','horizontal', 'FontSize', 9);

    % Programatically move the Legend
    newPosition = [0.4 0.05 0.2 0];
    newUnits = 'normalized';
    set(hL,'Position', newPosition,'Units', newUnits);
    end
    
    subplot(1,2,1)
        allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
        s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
    %yyaxis left
    b = bar(1:5, allRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors(i,:),[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Capacity (MCM)','FontWeight','bold')
    title('Dam Capacity vs. Time','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
    hold on
%     yyaxis right
%     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
%     plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([70,90]);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(P_regret(p)),'mm/mo)'),...
         'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    end
    
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



%hL = legend{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
%     strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
%     string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
%     ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
%     string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9);

% % Programatically move the Legend
% newPosition = [0.4 0.05 0.2 0];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);


%% Compare final total cost when 3% vs. 6% discount rate is used
% consider if same larger capacity dam was built vs. optimal design
% Look at plots above to select interesting/representative forward
% simulations

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;


s_P_abs = 66:1:97;
s_T_abs = [26.25 26.75 27.25 27.95 28.8000];

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

disc = [3,6,6];

for d = 1:3 % for each discount rate
    if d == 1
        load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
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
        
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
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
        
    elseif d ==2
        load(strcat(folder,'/Nov02optimal_dam_design_discount/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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
        
        load(strcat(folder,'/Nov02optimal_dam_design_discount/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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
    else
                load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
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
        
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
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
    
    P_regret = [72 79 87];
    
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
    figure(p)
    
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
    shortageCostPnowFlex_adapt = mean(sum(totalCost_adapt(ind_P_adapt,:,1)-damCost_adapt(ind_P_adapt,:,1),2));
    shortageCostPnowFlex_nonadapt = mean(sum(totalCost_nonadapt(ind_P_nonadapt,:,1)-damCost_nonadapt(ind_P_nonadapt,:,1),2));
    shortageCostPnowStatic_adapt = mean(sum(totalCost_adapt(ind_P_adapt,:,2)-damCost_adapt(ind_P_adapt,:,2),2));
    shortageCostPnowStatic_nonadapt = mean(sum(totalCost_nonadapt(ind_P_nonadapt,:,2)-damCost_nonadapt(ind_P_nonadapt,:,2),2));
    shortageCostPnowPlan_adapt = mean(sum(totalCost_adapt(ind_P_adapt,:,3)-damCost_adapt(ind_P_adapt,:,3),2));
    shortageCostPnowPlan_nonadapt = mean(sum(totalCost_nonadapt(ind_P_nonadapt,:,3)-damCost_nonadapt(ind_P_nonadapt,:,3),2));

        % Dam Cost Time: select associated simulations
    damCostPnowFlex_adapt = mean(sum(damCost_adapt(ind_P_adapt,:,1),2));
    damCostPnowFlex_nonadapt = mean(sum(damCost_nonadapt(ind_P_nonadapt,:,1),2));
    damCostPnowStatic_adapt = mean(sum(damCost_adapt(ind_P_adapt,:,2),2));
    damCostPnowStatic_nonadapt = mean(sum(damCost_nonadapt(ind_P_nonadapt,:,2),2));
    damCostPnowPlan_adapt = mean(sum(damCost_adapt(ind_P_adapt,:,3),2));
    damCostPnowPlan_nonadapt = mean(sum(damCost_nonadapt(ind_P_nonadapt,:,3),2));
    
    
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
    [uP, uPIdx, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    
    
    subplot(1,3,d)
    allRows_comb = zeros(5,6,2);
    for i = 1
        allRows_comb(i,1:6,1) = [damCostPnowStatic_nonadapt, damCostPnowStatic_adapt,...
            damCostPnowFlex_nonadapt, damCostPnowFlex_adapt, damCostPnowPlan_nonadapt, damCostPnowPlan_adapt];
        allRows_comb(i,1:6,2) = [ shortageCostPnowStatic_nonadapt, shortageCostPnowStatic_adapt,...
            shortageCostPnowFlex_nonadapt, shortageCostPnowFlex_adapt, shortageCostPnowPlan_nonadapt, shortageCostPnowPlan_adapt];
    end
    h = plotBarStackGroups(allRows_comb,decade_short);
    for i = 1:6
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Flexible Infrastructure Alternative','FontWeight','bold')
    ylabel('Total Cost')
    xlim([0.5,1.5])
    title(strcat("Discount rate: ",num2str(disc(d)),"%"),'FontWeight','bold')
    
%     yyaxis right
%     hold on
%     p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([65,95]);
%     xlim([0.5,5.5])
%     box on
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.XTickLabel = '';
%     ax.YAxis(2).Color = 'k';
    if p == 1
     hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2)],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts"},'Orientation','horizontal', 'FontSize', 9);

    % Programatically move the Legend
    newPosition = [0.4 0.05 0.2 0];
    newUnits = 'normalized';
    set(hL,'Position', newPosition,'Units', newUnits);
    end
    
%     subplot(1,2,1)
%         allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
%         s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
%         s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
%     %yyaxis left
%     b = bar(1:5, allRows_comb,'facecolor','flat');
%     for i = 1:6
%         b(i).CData = repmat(facecolors(i,:),[5,1]);
%     end
%     ylim([0,155])
%     xticklabels(decade_short)
%     xlabel('Time Period','FontWeight','bold')
%     ylabel('Capacity (MCM)','FontWeight','bold')
%     title('Dam Capacity vs. Time','FontWeight','bold')
%     hold on
%     yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
%     hold on
%     yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
%     hold on
%     yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
%     hold on
%     yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
%     hold on
% %     yyaxis right
% %     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
% %     plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
% %     ylabel('P State (mm/mo)')
% %     ylim([70,90]);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(P_regret(p)),'mm/mo)'),...
         'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    end
    
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

end

%% ALL - Compare final total cost when 3% vs. 6% discount rate is used
% consider if same larger capacity dam was built vs. optimal design
% Look at plots above to select interesting/representative forward
% simulations

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;


s_P_abs = 66:1:97;
s_T_abs = [26.25 26.75 27.25 27.95 28.8000];

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

disc = [3,6,6];

for d = 1:3 % for each discount rate
    if d == 1
        load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
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
        
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc3.mat'))
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
        
    elseif d ==2
        load(strcat(folder,'/Nov02optimal_dam_design_discount/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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
        
        load(strcat(folder,'/Nov02optimal_dam_design_discount/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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
    else
                load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
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
        
        load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6.mat'))
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
    
    
    s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
        (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];
    
    s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
        (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];
    
    % forward simulations of shortage and infrastructure costs
    totalCost_adapt = squeeze(totalCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(totalCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(damCostTime_adapt(:,:,1:3))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(damCostTime_nonadapt(:,:,1:3))/1E6;% 1 is flex, 2 is static

for p = 1%:length(P_regret) % for each transition to drier or wetter climate
    figure(p)
    
    % Actions: select associated simulations
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,:);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,:);
    
    % Dam Cost Time: select associated simulations
    damCostPnowFlex_adapt = damCost_adapt(:,:,1);
    damCostPnowFlex_nonadapt = damCost_nonadapt(:,:,1);
    damCostPnowStatic_adapt = damCost_adapt(:,:,2);
    damCostPnowStatic_nonadapt = damCost_nonadapt(:,:,2);
    damCostPnowPlan_adapt = damCost_adapt(:,:,3);
    damCostPnowPlan_nonadapt = damCost_nonadapt(:,:,3);

    % Shortage Cost Time: select associated simulations
    shortageCostPnowFlex_adapt = mean(sum(totalCost_adapt(:,:,1)-damCost_adapt(:,:,1),2));
    shortageCostPnowFlex_nonadapt = mean(sum(totalCost_nonadapt(:,:,1)-damCost_nonadapt(:,:,1),2));
    shortageCostPnowStatic_adapt = mean(sum(totalCost_adapt(:,:,2)-damCost_adapt(:,:,2),2));
    shortageCostPnowStatic_nonadapt = mean(sum(totalCost_nonadapt(:,:,2)-damCost_nonadapt(:,:,2),2));
    shortageCostPnowPlan_adapt = mean(sum(totalCost_adapt(:,:,3)-damCost_adapt(:,:,3),2));
    shortageCostPnowPlan_nonadapt = mean(sum(totalCost_nonadapt(:,:,3)-damCost_nonadapt(:,:,3),2));

        % Dam Cost Time: select associated simulations
    damCostPnowFlex_adapt = mean(sum(damCost_adapt(:,:,1),2));
    damCostPnowFlex_nonadapt = mean(sum(damCost_nonadapt(:,:,1),2));
    damCostPnowStatic_adapt = mean(sum(damCost_adapt(:,:,2),2));
    damCostPnowStatic_nonadapt = mean(sum(damCost_nonadapt(:,:,2),2));
    damCostPnowPlan_adapt = mean(sum(damCost_adapt(:,:,3),2));
    damCostPnowPlan_nonadapt = mean(sum(damCost_nonadapt(:,:,3),2));
    
    
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
    [uP, uPIdx, ~] = unique(Pnow_adapt, 'rows','stable');
    
    
   % PLOTS
    
    
    subplot(1,3,d)
    allRows_comb = zeros(5,6,2);
    for i = 1
        allRows_comb(i,1:6,1) = [damCostPnowStatic_nonadapt, damCostPnowStatic_adapt,...
            damCostPnowFlex_nonadapt, damCostPnowFlex_adapt, damCostPnowPlan_nonadapt, damCostPnowPlan_adapt];
        allRows_comb(i,1:6,2) = [ shortageCostPnowStatic_nonadapt, shortageCostPnowStatic_adapt,...
            shortageCostPnowFlex_nonadapt, shortageCostPnowFlex_adapt, shortageCostPnowPlan_nonadapt, shortageCostPnowPlan_adapt];
    end
    h = plotBarStackGroups(allRows_comb,decade_short);
    for i = 1:6
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Flexible Infrastructure Alternative','FontWeight','bold')
    ylabel('Total Cost')
    xlim([0.5,1.5])
    ylim([0,200])
    title(strcat("Discount rate: ",num2str(disc(d)),"%"),'FontWeight','bold')
    
%     yyaxis right
%     hold on
%     p1 = plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([65,95]);
%     xlim([0.5,5.5])
%     box on
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.XTickLabel = '';
%     ax.YAxis(2).Color = 'k';
    if p == 1
     hL = legend([h(1,1), h(2,1), h(3,1), h(4,1), h(5,1), h(6,1), h(1,2)],{strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)"),"Shortage\newlinecosts"},'Orientation','horizontal', 'FontSize', 9);

    % Programatically move the Legend
    newPosition = [0.4 0.05 0.2 0];
    newUnits = 'normalized';
    set(hL,'Position', newPosition,'Units', newUnits);
    end
    
%     subplot(1,2,1)
%         allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
%         s_C_nonadapt(actionPnowFlex_nonadapt(idxP,:)); s_C_adapt(actionPnowFlex_adapt(idxP,:));...
%         s_C_nonadapt(actionPnowPlan_nonadapt(idxP,:)); s_C_adapt(actionPnowPlan_adapt(idxP,:))];
%     %yyaxis left
%     b = bar(1:5, allRows_comb,'facecolor','flat');
%     for i = 1:6
%         b(i).CData = repmat(facecolors(i,:),[5,1]);
%     end
%     ylim([0,155])
%     xticklabels(decade_short)
%     xlabel('Time Period','FontWeight','bold')
%     ylabel('Capacity (MCM)','FontWeight','bold')
%     title('Dam Capacity vs. Time','FontWeight','bold')
%     hold on
%     yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
%     hold on
%     yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
%     hold on
%     yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
%     hold on
%     yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
%     hold on
% %     yyaxis right
% %     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
% %     plot(Pnow_nonadapt(idxP,:),'color','black','LineWidth',1.5)
% %     ylabel('P State (mm/mo)')
% %     ylim([70,90]);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(P_regret(p)),'mm/mo)'),...
         'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(P_regret(p)),'mm/mo)'),...
            'FontWeight','bold')
    end
    
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

end

%% (2 - NEW) Plot all forward simulation time series for different climate states
% Use SDP best value estimates for expected next costs 

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

M_C = length(s_C);

storage = zeros(1, M_C); 
storage_adapt = s_C_adapt; % added line

infra_cost = zeros(1,length(a_exp));
% dam costs
infra_cost(2) = storage2damcost(storage(1),0); % cost of static dam
for i = 1:bestAct_adapt(4) % cost of flexible design dam
    [infra_cost(3), infra_cost(i+4)] = storage2damcost(storage(2), ...
        storage(i+3),costParam.PercFlex, costParam.PercFlexExp); % cost of flexible design exp to option X
end
for i = 1:bestAct_adapt(9) % cost of flexible plan dam
    [infra_cost(4), infra_cost(i+4+optParam.numFlex)] = storage2damcost(storage(3), ...
        storage(i+3+optParam.numFlex),costParam.PercPlan, costParam.PercPlanExp); % cost of flexible planning exp to option X
end

%for each expanded threshold, calculate (from small expansion to larger
%expansion):
flexexp = zeros(1,M_C-3);
for i=1:bestAct_adapt(4) % flexible design dam
    flexexp(i) = infra_cost(3) + infra_cost(4+i); %flexexp(i) = infra_cost(4) + infra_cost(4+i); % total expanded cost for each option
end
for i=1:bestAct_adapt(9) % flexible plan dam
    flexexp(optParam.numFlex+i) = infra_cost(4) + infra_cost(4+bestAct_adapt(4)+i); %flexexp(i) = infra_cost(4) + infra_cost(4+i); % total expanded cost for each option
end

for p = 1:length(P_regret) % for each transition to drier or wetter climate
    
    [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(p));
    [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(p));
    
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,[1,3]);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,[1,3]);
    modeRowStatic_adapt = repmat(bestAct_adapt(2),[1,5]);
    modeRowStatic_nonadapt = repmat(bestAct_nonadapt(2),[1,5]);
    
    % Find the mode of realizations
    [uP, ~, uPIdx] = unique(Pnow_adapt,'rows');
    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_adapt(1,:) = uA(modeIdx,:); %# the first output argument
    actionPnowStatic_adapt = ActionPnow_adapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_adapt)
        if modeRowFlex_adapt(1,ia) == 0
            modeRowFlex_adapt(1,ia) = modeRowFlex_adapt(1,ia-1);
        end
    end
    
    for r = 1:size(actionPnowStatic_adapt,1)
        for ia = 2:size(actionPnowStatic_adapt,2)
            if actionPnowStatic_adapt(r,ia) == 0
                actionPnowStatic_adapt(r,ia) = actionPnowStatic_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    actionPnowStatic_nonadapt = ActionPnow_nonadapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_nonadapt)
        if modeRowFlex_nonadapt(1,ia) == 0
            modeRowFlex_nonadapt(1,ia) = modeRowFlex_nonadapt(1,ia-1);
        end
    end
    
    for r = 1:size(actionPnowStatic_nonadapt,1)
        for ia = 2:size(actionPnowStatic_nonadapt,2)
            if actionPnowStatic_nonadapt(r,ia) == 0
                actionPnowStatic_nonadapt(r,ia) = actionPnowStatic_nonadapt(r,ia-1);
            end
        end
    end
    
    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdFlex_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowStatic_adapt(r,ia),ia);
            VsFlex_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowStatic_adapt(r,ia),ia);
            VdFlex_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowStatic_nonadapt(r,ia),ia);
            VsFlex_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowStatic_nonadapt(r,ia),ia);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,2),'rows');
    modeIdx_adapt = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx_adapt,:); %# the first output argument
    actionPnowPlan_adapt = ActionPnow_adapt(uPIdx,:,2);
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    for r = 1:size(actionPnowPlan_adapt,1)
        for ia = 2:size(actionPnowPlan_adapt,2)
            if actionPnowPlan_adapt(r,ia) == 0
                actionPnowPlan_adapt(r,ia) = actionPnowPlan_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx_nonadapt = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx_nonadapt,:); %# the first output argument
    actionPnowPlan_nonadapt = ActionPnow_nonadapt(uPIdx,:,2);

    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 2:size(actionPnowPlan_nonadapt,2)
            if actionPnowPlan_nonadapt(r,ia) == 0
                actionPnowPlan_nonadapt(r,ia) = actionPnowPlan_nonadapt(r,ia-1);
            end
        end
    end

    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdPlan_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowPlan_adapt(r,ia),ia);
            VsPlan_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowPlan_adapt(r,ia),ia);
            VdPlan_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowPlan_nonadapt(r,ia),ia);
            VsPlan_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowPlan_nonadapt(r,ia),ia);
        end
    end
    
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 1:5
            VdStatic_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VsStatic_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VdStatic_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
            VsStatic_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
        end
    end
    
    
   % PLOTS
   for fi = 1%:ceil(size(uPIdx,1)/16)
    uPIdxs = uPIdx(min([1:8]+(fi-1)*8,size(uP,1)));
    figure()
    
    for subP = 1:length(uPIdxs)
    subplot(4,4,2*subP)
    
    allRows_comb = zeros(5,6,2);
    for i = 1:5
        allRows_comb(i,1:6,1) = [VdStatic_nonadapt(subP,i), VdStatic_adapt(subP,i),...
            VdFlex_nonadapt(subP,i), VdFlex_adapt(subP,i), VdPlan_nonadapt(subP,i), VdPlan_adapt(subP,i)]/1E6;
        allRows_comb(i,1:6,2) = [ VsStatic_nonadapt(subP,i), VsStatic_adapt(subP,i),...
            VsFlex_nonadapt(subP,i), VsFlex_adapt(subP,i), VsPlan_nonadapt(subP,i), VsPlan_adapt(subP,i)]/1E6;
    end
    yyaxis left
    h = plotBarStackGroups(allRows_comb,decade_short);
    for i = 1:6
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Cost (M$)','FontWeight','bold')
    
    yyaxis right
    hold on
    plot(Pnow_nonadapt(uPIdx(subP),:),'color','black','LineWidth',1.5)
    ylabel('P State (mm/mo)')
    ylim([70,90]);
    xlim([0.5,5.5])
    box on
    
    subplot(4,4,2*subP-1)
        allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(actionPnowStatic_nonadapt(uPIdxs(subP),:)); s_C_adapt(actionPnowStatic_adapt(uPIdxs(subP),:));...
        s_C_nonadapt(actionPnowPlan_nonadapt(uPIdxs(subP),:)); s_C_adapt(actionPnowPlan_adapt(uPIdxs(subP),:))];
    %yyaxis left
    b = bar(1:5, allRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors(i,:),[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Capacity (MCM)','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
    hold on
%     yyaxis right
%     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
%     plot(Pnow_nonadapt(uPIdx(subP),:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([70,90]);

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

hL = legend({strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9);

% Programatically move the Legend
newPosition = [0.4 0.05 0.2 0];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    end
    end
end


%% (2 - OG) Plot all forward simulation time series for different climate states
% Use SDP best value estimates for costs over time (not best estimate...)

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

for p = 1:length(P_regret) % for each transition to drier or wetter climate
    
    [ind_P_adapt,~] = find(P_state_adapt(:,end) == P_regret(p));
    [ind_P_nonadapt,~] = find(P_state_nonadapt(:,end) == P_regret(p));
    
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,[1,3]);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,[1,3]);
    modeRowStatic_adapt = repmat(bestAct_adapt(2),[1,5]);
    modeRowStatic_nonadapt = repmat(bestAct_nonadapt(2),[1,5]);
    
    % Find the mode of realizations
    [uP, ~, uPIdx] = unique(Pnow_adapt,'rows');
    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_adapt(1,:) = uA(modeIdx,:); %# the first output argument
    actionPnowStatic_adapt = ActionPnow_adapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_adapt)
        if modeRowFlex_adapt(1,ia) == 0
            modeRowFlex_adapt(1,ia) = modeRowFlex_adapt(1,ia-1);
        end
    end
    
    for r = 1:size(actionPnowStatic_adapt,1)
        for ia = 2:size(actionPnowStatic_adapt,2)
            if actionPnowStatic_adapt(r,ia) == 0
                actionPnowStatic_adapt(r,ia) = actionPnowStatic_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    actionPnowStatic_nonadapt = ActionPnow_nonadapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_nonadapt)
        if modeRowFlex_nonadapt(1,ia) == 0
            modeRowFlex_nonadapt(1,ia) = modeRowFlex_nonadapt(1,ia-1);
        end
    end
    
    for r = 1:size(actionPnowStatic_nonadapt,1)
        for ia = 2:size(actionPnowStatic_nonadapt,2)
            if actionPnowStatic_nonadapt(r,ia) == 0
                actionPnowStatic_nonadapt(r,ia) = actionPnowStatic_nonadapt(r,ia-1);
            end
        end
    end
    
    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdFlex_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowStatic_adapt(r,ia),ia);
            VsFlex_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowStatic_adapt(r,ia),ia);
            VdFlex_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowStatic_nonadapt(r,ia),ia);
            VsFlex_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowStatic_nonadapt(r,ia),ia);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,2),'rows');
    modeIdx_adapt = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx_adapt,:); %# the first output argument
    actionPnowPlan_adapt = ActionPnow_adapt(uPIdx,:,2);
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    for r = 1:size(actionPnowPlan_adapt,1)
        for ia = 2:size(actionPnowPlan_adapt,2)
            if actionPnowPlan_adapt(r,ia) == 0
                actionPnowPlan_adapt(r,ia) = actionPnowPlan_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx_nonadapt = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx_nonadapt,:); %# the first output argument
    actionPnowPlan_nonadapt = ActionPnow_nonadapt(uPIdx,:,2);

    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 2:size(actionPnowPlan_nonadapt,2)
            if actionPnowPlan_nonadapt(r,ia) == 0
                actionPnowPlan_nonadapt(r,ia) = actionPnowPlan_nonadapt(r,ia-1);
            end
        end
    end

    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdPlan_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowPlan_adapt(r,ia),ia);
            VsPlan_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),actionPnowPlan_adapt(r,ia),ia);
            VdPlan_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowPlan_nonadapt(r,ia),ia);
            VsPlan_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),actionPnowPlan_nonadapt(r,ia),ia);
        end
    end
    
    for r = 1:size(actionPnowPlan_nonadapt,1)
        for ia = 1:5
            VdStatic_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VsStatic_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VdStatic_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
            VsStatic_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
        end
    end
    
    
   % PLOTS
   for fi = 1%:ceil(size(uPIdx,1)/16)
    uPIdxs = uPIdx(min([1:8]+(fi-1)*8,size(uP,1)));
    figure()
    
    for subP = 1:length(uPIdxs)
    subplot(4,4,2*subP)
    
    allRows_comb = zeros(5,6,2);
    for i = 1:5
        allRows_comb(i,1:6,1) = [VdStatic_nonadapt(subP,i), VdStatic_adapt(subP,i),...
            VdFlex_nonadapt(subP,i), VdFlex_adapt(subP,i), VdPlan_nonadapt(subP,i), VdPlan_adapt(subP,i)]/1E6;
        allRows_comb(i,1:6,2) = [ VsStatic_nonadapt(subP,i), VsStatic_adapt(subP,i),...
            VsFlex_nonadapt(subP,i), VsFlex_adapt(subP,i), VsPlan_nonadapt(subP,i), VsPlan_adapt(subP,i)]/1E6;
    end
    yyaxis left
    h = plotBarStackGroups(allRows_comb,decade_short);
    for i = 1:6
        h(i,1).FaceColor = facecolors(i,:);
        h(i,2).FaceColor = [211,211,211]/255;
    end
    %xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Cost (M$)','FontWeight','bold')
    
    yyaxis right
    hold on
    plot(Pnow_nonadapt(uPIdx(subP),:),'color','black','LineWidth',1.5)
    ylabel('P State (mm/mo)')
    ylim([70,90]);
    xlim([0.5,5.5])
    box on
    
    subplot(4,4,2*subP-1)
        allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(actionPnowStatic_nonadapt(uPIdxs(subP),:)); s_C_adapt(actionPnowStatic_adapt(uPIdxs(subP),:));...
        s_C_nonadapt(actionPnowPlan_nonadapt(uPIdxs(subP),:)); s_C_adapt(actionPnowPlan_adapt(uPIdxs(subP),:))];
    %yyaxis left
    b = bar(1:5, allRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors(i,:),[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period','FontWeight','bold')
    ylabel('Capacity (MCM)','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
    hold on
%     yyaxis right
%     %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
%     plot(Pnow_nonadapt(uPIdx(subP),:),'color','black','LineWidth',1.5)
%     ylabel('P State (mm/mo)')
%     ylim([70,90]);

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

hL = legend({strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign (",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9);

% Programatically move the Legend
newPosition = [0.4 0.05 0.2 0];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);

    if p == 1
        sgtitle(strcat('Dry Final Precipitation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    elseif p == 2
        sgtitle(strcat('Moderate Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    else
        sgtitle(strcat('Wet Final Precipiation State (',num2str(fi),'/',...
            num2str(ceil(size(uPIdx,1)/16)),')'),'FontWeight','bold')
    end
    end
end
