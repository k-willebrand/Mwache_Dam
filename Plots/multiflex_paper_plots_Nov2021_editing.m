%% Plot all forward realization time series of capacity for different climate states

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

for p = 1:length(P_regret) % for each transition to drier or wetter climate
    
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(p));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(p));
    
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,[1,3]);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,[1,3]);
        
    % Find the unique expansion decisions realizations
    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,1),'rows');
    RowFlex_adapt = cell(length(uA),1);
    % find rows with those expansion actions in that final P State
    for i = 1:size(uA,1)
        [RowFlex_adapt{i},~] = find(ActionPnow_adapt(:,:,1) == uA(i,:)); %# the first output argument
    end
    % update actions to follow cumulative dam capacity over time
    for ia = 2:width(uA)
        if modeRowFlex_adapt(1,ia) == 0
            modeRowFlex_adapt(1,ia) = modeRowFlex_adapt(1,ia-1);
        end
    end
    
    for r = 1:size(allRowFlex_adapt,1)
        for ia = 2:size(allRowFlex_adapt,2)
            if allRowFlex_adapt(r,ia) == 0
                allRowFlex_adapt(r,ia) = allRowFlex_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    allRowFlex_nonadapt = ActionPnow_nonadapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_nonadapt)
        if modeRowFlex_nonadapt(1,ia) == 0
            modeRowFlex_nonadapt(1,ia) = modeRowFlex_nonadapt(1,ia-1);
        end
    end
    
    for r = 1:size(allRowFlex_nonadapt,1)
        for ia = 2:size(allRowFlex_nonadapt,2)
            if allRowFlex_nonadapt(r,ia) == 0
                allRowFlex_nonadapt(r,ia) = allRowFlex_nonadapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,2),'rows');
    modeIdx_adapt = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx_adapt,:); %# the first output argument
    allRowPlan_adapt = ActionPnow_adapt(uPIdx,:,2);
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    for r = 1:size(allRowPlan_adapt,1)
        for ia = 2:size(allRowPlan_adapt,2)
            if allRowPlan_adapt(r,ia) == 0
                allRowPlan_adapt(r,ia) = allRowPlan_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx_nonadapt = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx_nonadapt,:); %# the first output argument
    allRowPlan_nonadapt = ActionPnow_nonadapt(uPIdx,:,2);
    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    for r = 1:size(allRowPlan_nonadapt,1)
        for ia = 2:size(allRowPlan_nonadapt,2)
            if allRowPlan_nonadapt(r,ia) == 0
                allRowPlan_nonadapt(r,ia) = allRowPlan_nonadapt(r,ia-1);
            end
        end
    end
    
    for fi = 1%:ceil(size(uPIdx,1)/16)
    uPIdxs = uPIdx(min([1:16]+(fi-1)*16,size(uP,1)));
    figure()
    
    for subP = 1:length(uPIdxs)
    subplot(4,4,subP)
    allRows_comb = [repmat(bestAct_nonadapt(2),[1,5]); repmat(bestAct_adapt(2),[1,5]); ...
        s_C_nonadapt(allRowFlex_nonadapt(uPIdxs(subP),:)); s_C_adapt(allRowFlex_adapt(uPIdxs(subP),:));...
        s_C_nonadapt(allRowPlan_nonadapt(uPIdxs(subP),:)); s_C_adapt(allRowPlan_adapt(uPIdxs(subP),:))];
    yyaxis left
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
    yyaxis right
    %plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
    plot(Pnow_nonadapt(uPIdx(subP),:),'color','black')
    ylabel('P State (mm/month)')
    ylim([65,97]);
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

%% Plot all forward realization time series of capacity for different climate states

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
    allRowFlex_adapt = ActionPnow_adapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_adapt)
        if modeRowFlex_adapt(1,ia) == 0
            modeRowFlex_adapt(1,ia) = modeRowFlex_adapt(1,ia-1);
        end
    end
    
    for r = 1:size(allRowFlex_adapt,1)
        for ia = 2:size(allRowFlex_adapt,2)
            if allRowFlex_adapt(r,ia) == 0
                allRowFlex_adapt(r,ia) = allRowFlex_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    allRowFlex_nonadapt = ActionPnow_nonadapt(uPIdx,:,1);
    for ia = 2:length(modeRowFlex_nonadapt)
        if modeRowFlex_nonadapt(1,ia) == 0
            modeRowFlex_nonadapt(1,ia) = modeRowFlex_nonadapt(1,ia-1);
        end
    end
    
    for r = 1:size(allRowFlex_nonadapt,1)
        for ia = 2:size(allRowFlex_nonadapt,2)
            if allRowFlex_nonadapt(r,ia) == 0
                allRowFlex_nonadapt(r,ia) = allRowFlex_nonadapt(r,ia-1);
            end
        end
    end
    
    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdFlex_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),allRowFlex_adapt(r,ia),ia);
            VsFlex_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),allRowFlex_adapt(r,ia),ia);
            VdFlex_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),allRowFlex_nonadapt(r,ia),ia);
            VsFlex_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),allRowFlex_nonadapt(r,ia),ia);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,2),'rows');
    modeIdx_adapt = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx_adapt,:); %# the first output argument
    allRowPlan_adapt = ActionPnow_adapt(uPIdx,:,2);
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    for r = 1:size(allRowPlan_adapt,1)
        for ia = 2:size(allRowPlan_adapt,2)
            if allRowPlan_adapt(r,ia) == 0
                allRowPlan_adapt(r,ia) = allRowPlan_adapt(r,ia-1);
            end
        end
    end
    
    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx_nonadapt = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx_nonadapt,:); %# the first output argument
    allRowPlan_nonadapt = ActionPnow_nonadapt(uPIdx,:,2);

    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    for r = 1:size(allRowPlan_nonadapt,1)
        for ia = 2:size(allRowPlan_nonadapt,2)
            if allRowPlan_nonadapt(r,ia) == 0
                allRowPlan_nonadapt(r,ia) = allRowPlan_nonadapt(r,ia-1);
            end
        end
    end

    for r = 1:size(Pnow_adapt,1)
        for ia = 1:5
            VdPlan_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),allRowPlan_adapt(r,ia),ia);
            VsPlan_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),allRowPlan_adapt(r,ia),ia);
            VdPlan_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),allRowPlan_nonadapt(r,ia),ia);
            VsPlan_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),allRowPlan_nonadapt(r,ia),ia);
        end
    end
    
    for r = 1:size(allRowPlan_nonadapt,1)
        for ia = 1:5
            VdStatic_adapt(r,ia) = Vd_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VsStatic_adapt(r,ia) = Vs_adapt(ia,find(s_P_abs == Pnow_adapt(r,ia)),1,ia);
            VdStatic_nonadapt(r,ia) = Vd_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
            VsStatic_nonadapt(r,ia) = Vs_nonadapt(ia,find(s_P_abs == Pnow_nonadapt(r,ia)),1,ia);
        end
    end
    
    
    for fi = 1%:ceil(size(uPIdx,1)/16)
    uPIdxs = uPIdx(min([1:16]+(fi-1)*16,size(uP,1)));
    figure()
    
    for subP = 1:length(uPIdxs)
    subplot(4,4,subP)
    
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
    yyaxis right
    plot(Pnow_nonadapt(uPIdx(subP),:),'color','black')
    ylabel('P State (mm/month)')
    ylim([65,97]);

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

%% Plot all forward realization time series of capcaity for different climate states

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

f = figure
for p = 1:length(P_regret) % for each transition to drier or wetter climate
    
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(p));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(p));
    
    Pnow_adapt = P_state_adapt(ind_P_adapt,:);
    Pnow_nonadapt = P_state_adapt(ind_P_nonadapt,:);
    
    % Actions
    ActionPnow_adapt = action_adapt(ind_P_adapt,:,[1,3]);
    ActionPnow_nonadapt = action_nonadapt(ind_P_nonadapt,:,[1,3]);
    modeRowStatic_adapt = repmat(bestAct_adapt(2),[1,5]);
    modeRowStatic_nonadapt = repmat(bestAct_nonadapt(2),[1,5]);
        
    % Find the mode of realizations
    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_adapt(1,:) = uA(modeIdx,:); %# the first output argument
    for ia = 2:length(modeRowFlex_adapt)
        if modeRowFlex_adapt(1,ia) == 0
            modeRowFlex_adapt(1,ia) = modeRowFlex_adapt(1,ia-1);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,1),'rows');
    modeIdx = mode(uIdx);
    modeRowFlex_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    for ia = 2:length(modeRowFlex_nonadapt)
        if modeRowFlex_nonadapt(1,ia) == 0
            modeRowFlex_nonadapt(1,ia) = modeRowFlex_nonadapt(1,ia-1);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_adapt(:,:,2),'rows');
    modeIdx_adapt = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx_adapt,:); %# the first output argument
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx_nonadapt = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx_nonadapt,:); %# the first output argument
    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    subplot(1,3,p)
    modeRows_comb = [modeRowStatic_nonadapt; modeRowStatic_adapt; ...
        s_C_nonadapt(modeRowFlex_nonadapt); s_C_adapt(modeRowFlex_adapt);...
        s_C_nonadapt(modeRowPlan_nonadapt); s_C_adapt(modeRowPlan_adapt)];
    yyaxis left
    b = bar(1:5, modeRows_comb,'facecolor','flat');
    for i = 1:6
        b(i).CData = repmat(facecolors(i,:),[5,1]);
    end
    ylim([0,155])
    xticklabels(decade_short)
    xlabel('Time Period\newline\newline\newline \newline','FontWeight','bold')
    ylabel('Dam Capacity (MCM)','FontWeight','bold')
    hold on
    yline(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Planning Capacity', 'color', facecolors(5,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Planning Capacity', 'color', facecolors(6,:),'LineWidth',2)
    hold on
    yline(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5),'LineStyle',':', 'DisplayName','Max Non-Adaptive Flexible Design Capacity', 'color', facecolors(3,:),'LineWidth',2)
    hold on
    yline(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5),'LineStyle','--', 'DisplayName','Max Adaptive Flexible Design Capacity', 'color', facecolors(4,:),'LineWidth',2)
    if p == 1
        title('Dry Final Precipitation State','FontWeight','bold')
    elseif p == 2
        title('Moderate Final Precipiation State','FontWeight','bold')
    else
        title('Wet Final Precipiation State','FontWeight','bold')
    end
    hold on
    yyaxis right
    plot(Pnow_nonadapt(modeIdx_adapt,:),'color','black')
    ylabel('Precipitation State (mm/month)')
    ylim([65,97]);
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

sgtitle({'Mode Simulated Expansion Decision Time Series'},'FontSize',14,'FontWeight','bold')

% export figure to combine with time series of total costs plot
filename3 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/modeExpSimPstate.jpg'];
exportgraphics(f,filename3,'Resolution',1200)


%% Highlights from Jenny's Plots (initial infrastructure decision, final decision, timing of decisions)

f = figure;

nonadapt_plan_colors = [[255,102,102];[255,153,153];[255,214,214];[255,255,255];[224,224,224]];
nonadapt_flex_colors = [[153,153,204];[213,213,255];[234,234,255];[238,184,192];[255,255,255];[224,224,224]];

adapt_plan_colors = [[255,153,153];[255,204,204];[255,243,243];[255,255,255];[224,224,224]];
adapt_flex_colors = [[204,204,255];[230,230,255];[243,243,255];[235,255,255];[255,255,255];[224,224,224]];


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
        cmap1 = [[153,204,204]; [153, 153, 204];  [255, 102, 102]; nonadapt_flex_colors(2:bestAct(4)+1,:); nonadapt_plan_colors(2:bestAct(9)+1,:)]/255;
    else % adaptive
        cmap1 = [[204,255,255]; [204, 204, 255]; [255, 153, 153]; adapt_flex_colors(2:bestAct(4)+1,:); adapt_plan_colors(2:bestAct(9)+1,:)]/255;
    end
    cmap2 = cbrewer('div', 'Spectral',11);
    cmap = cbrewer('qual', 'Set3', n);
    
    % Define range capacity states to consider for optimal flexible dam
    s_C = [1:3,4:3+bestAct(4)+bestAct(9)];
    
    % === SUBPLOT 1: FINAL EXPANSIONS OVER TIME ==
    subplot(2,2,s)
    s_C_bins = s_C - 0.01;
    s_C_bins(end+1) = s_C(end)+0.01;
    
    clear cPnowCounts cPnowCounts_test
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
    for k=1:5
        cPnowCounts(k,:) = histcounts(action(:,k,t), s_C_bins);
        cPnowCounts_test(k,:) = histcounts(action(:,k,t), s_C_bins);
    end
    
    for j=2:5
        cPnowCounts(j,1) = cPnowCounts(1,1);
        cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4)));
        cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end));
        cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
    end
    
    colormap(cmap);
    b1 = bar([1:5]+(type-1)*6,cPnowCounts, 'stacked','FaceColor','flat');
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    hold on
    end
    xticks(1:1:2)
    xticklabels({'Flexible Design', 'Flexible Planning'})
    xlim([0.5 2.5])
    
    xlabel('Dam Alternative');
    ylabel('Frequency');
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex Design, Exp:+", num2str(z*bestAct(5)))};
    end
    for r = 1:bestAct(9)
        planExp_labels(r) = {strcat("Flex Planning, Exp:+", num2str(r*bestAct(10)))};
    end
    
    capState = {'Static', 'Flex. Design, Unexpanded','Flex. Planning, Unexpanded', flexExp_labels{:}, planExp_labels{:}};
    l = legend(capState,'Location',"southwest",'FontSize', 9);
    l.Position == l.Position + [-0.15 -0.15 0 0.05];
    box
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    set(findall(allaxes,'type','text'),'FontSize', 10);
    if s == 1 % nonadaptive
        title('Non-Adaptive Operations','FontSize',12)
    else
        title('Adaptive Operations','FontSize',12)
    end

    
    % == SUBPLOT 2: EXPANSION DECISIONS  ==
    
    subplot(2,2,2+s)
    
    for type = 1:2 % flexible design and flexible planning
        if type == 1
            t = 1;
        else
            t= 3;
        end
        % frequency of 1st decision (flexible or static)
        act1 = action(:,1,t);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % frequency timing of of exp decisions
        
        
        actexp = action(:,2:end,t);
        exp1 = sum(actexp(:,1) == s_C(4:end),'all');
        exp2 = sum(actexp(:,2) == s_C(4:end),'all');
        exp3 = sum(actexp(:,3) == s_C(4:end),'all');
        exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
        expnever = R - exp1 - exp2 - exp3 - exp4;
        
        % plot bars
        colormap(cmap)
        b2 = bar(1+0.5*(t-1),[exp1 exp2 exp3 exp4 expnever]', .8, 'stacked','FaceColor','flat');
        for i = 1:5
            b2(i).FaceColor = cmap2(i+5,:);
        end
        hold on
        xlim([0.5 2.5])
        xticks(1:1:2)
        xticklabels({'Flexible Design'; 'Flexible Planning'})
        [l1, l3] = legend({decade{1,2:end}, 'never'}, 'FontSize', 9, 'Location',"north");
        ylabel('Frequency')
        xlabel('Dam Alternative')
        allaxes = findall(f, 'type', 'axes');
        set(allaxes,'FontSize', 10)
        
        % add title to subplot groups
        if s == 1 % nonadaptive
            title('Non-Adaptive Operations','FontSize',12)
        else
            title('Adaptive Operations','FontSize',12)
        end
    end
end

% set figure size
figure_width = 10;
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
