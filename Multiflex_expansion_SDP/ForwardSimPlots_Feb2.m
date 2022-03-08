    %% Sample forward simulation by CLIMATE
    
    f = figure();
    
    facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
        [255, 102, 102]; [255, 153, 153]]/255;
    
    P_regret = [72 79 87 72]; % dry, moderate, wet
    
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
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(staticCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(staticCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowStatic_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(flexCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(flexCap_adapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowFlex_adapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                
                s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',string(planCap_nonadapt),'.mat');
                shortageCostDir = load(s_state_filename,'shortageCost');
                shortageCost_s_state = shortageCostDir.shortageCost(:,18:49); % 66 mm/month to 97 mm/month
                shortageCostPnowPlan_nonadapt(i) = shortageCost_s_state(i, Ps == P_now)*cp;
                s_state_filename = strcat('sdp_adaptive_shortage_cost_s',string(planCap_adapt),'.mat');
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