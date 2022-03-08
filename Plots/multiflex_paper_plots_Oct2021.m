%% Multiflex SDP Plots (Oct 2021) - Flexible design, operations, and planning

% Additional paper plots to assess the interactions between three different
% types of flexibility in water supply infrastructure

%% Load data: update data to load
load('BestFlexStatic_adaptive_cp7e6_g5.mat')
load('BestFlex_adaptive_cp7e6_g5.mat')
load('BestStatic_adaptive_cp7e6_g5.mat')
bestAct_adapt = bestAct;
V_adapt = V;
X_adapt = X;
action_adapt = action;
totalCostTime_adapt = totalCostTime;

load('BestFlexStatic_nonadaptive_cp7e6_g5.mat')
load('BestFlex_nonadaptive_cp7e6_g5.mat')
load('BestStatic_nonadaptive_cp7e6_g5.mat')
bestAct_nonadapt = bestAct;
V_nonadapt = V;
X_nonadapt = X;
action_nonadapt = action;
totalCostTime_nonadapt = totalCostTime;

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

%% Figure 1:

[R,~,~] = size(action); %size(action{1});

f = figure;
cmap1 = cbrewer('qual', 'Set2', 8);
cmap2 = cbrewer('div', 'Spectral',11);
cmap = cbrewer('qual', 'Set3', 8);

% infrastructure decision plots for comparison

for k = 1:2
    % specify whether to use adaptive or non-adaptive operations data
    if k == 1
        bestAct = bestAct_nonadapt;
        V = V_nonadapt;
        X = X_nonadapt;
        action = action_nonadapt; 
    elseif k == 2
        bestAct = bestAct_adapt;
        V = V_adapt;
        X = X_adapt;
        action = action_adapt;
    end
    
    % Define range capacity states to consider for optimal flexible dam
    s_C = 1:2+bestAct(4);
    
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,end);
    static = sum(act1 == 1);
    flex = sum(act1 == 2);
    
    % frequency of exp decision
    actexp = action(:,2:end,end); % action{k}(:,2:end,end);
    exp1 = sum(actexp(:,1) == s_C(3:end),'all');
    exp2 = sum(actexp(:,2) == s_C(3:end),'all');
    exp3 = sum(actexp(:,3) == s_C(3:end),'all');
    exp4 = sum(actexp(:,4) == s_C(3:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    subplot(2,8,k*8-1:k*8)
    colormap(cmap)
    %     b1 = bar([1 1.5],[static flex; nan(1,2)], .8,'stacked');
    %     b1(1).FaceColor = cmap1(1,:);
    %     b1(2).FaceColor = cmap1(2,:);
    %     hold on
    b2 = bar([exp1 exp2 exp3 exp4 expnever; nan(1,5)], .8, 'stacked');
    for i = 1:5
        b2(i).FaceColor = cmap2(i+5,:);
    end
    xlim([0.5 1.5])
    set(gca,'xticklabel',{'Expansion'})
    [l1, l3] = legend([b2], {decade{2:end}, 'never'}, 'FontSize', 10); %b1(2) b1(3)
    title('Infrastructure decisions')
    text(0.2,1000, labels{k*2-1})
    ylabel('Frequency')
    
    subplot(2,8,k*8-7:k*8-3)
    s_C_bins = s_C - 0.01;
    s_C_bins(end+1) = s_C(end)+0.01;
    
    clear actCounts actCounts_test
    
    for k=1:5
        actCounts(k,:) = histcounts(action(:,k,3), s_C_bins);
        actCounts_test(k,:) = histcounts(action(:,k,3), s_C_bins);
    end
    
    for j=2:5
        actCounts(j,1) = actCounts(1,1);
        actCounts(j,2) = actCounts(j-1,2) - sum(actCounts(j,3:end));
        actCounts(j,3:end) = actCounts(j-1,3:end) + actCounts(j,3:end);
    end
    
    colormap(cmap);
    b1 = bar(actCounts, 'stacked');
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    xticklabels(decade);
    xlabel('Time Period');
    ylabel('Frequency');
    capState = {'Static', 'Flex, Unexpanded', 'Flex, Exp:+10', ...
        'Flex, Exp:+20', 'Flex, Exp:+30', 'Flex, Exp:+40', 'Flex, Exp:+50'};
    l = legend(capState, 'location', 'east');
    l.Position = l.Position + [-0.25 0 0 0];
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    font_size = 12;
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', font_size)
    set(findall(allaxes,'type','text'),'FontSize', font_size)
    
end

figure_width = 8.5;
figure_height = 8.5;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(f, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);

%% Combined regret plot
% Regret for last time period
bestOption = 0;

P_regret = [68 78 88];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:2), 2));
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:2), 2));
meanCostPnow_adapt = zeros(length(P_regret),2);
meanCostPnow_nonadapt = zeros(length(P_regret),2);
for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P = P_state(:,end) == P_regret(i);
    % Get average cost of each infra option in that P level
    totalCostPnow_adapt = totalCost_adapt(ind_P,:);
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P,:);
    meanCostPnow_adapt(i,:) = mean(totalCostPnow_adapt,1);
    meanCostPnow_nonadapt(i,:) = mean(totalCostPnow_nonadapt,1);
end
meanCostPnow = [meanCostPnow_nonadapt; meancostPnow_adapt];

bestInfraCost = min(meanCostPnow,[],2);
regret = [meanCostPnow - repmat(bestInfraCost, 1,2);

f == figure;
bar([meanCostPnow; regret]/1E6)
hold on
line([3.5 3.5], [0 ceil(max(meanCostPnow/1E6,[],'all'))+50],'Color', 'k')
xlim([.5 6.5])
ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+50]);
xticklabels({'68', '78', '88', '68', '78', '88'})
yl == ylabel('M$');
yl.Position == yl.Position - [ .3 0 0];
xl == xlabel('P in 2090 [mm/month]');
xl.Position == xl.Position - [ 0 4 0];
%title('Cost and Regret for Infrastructure Alternatives by 2090 P')
l == legend('Non-adaptive, Flexible', 'Non-adaptive, Static','Adaptive, Flexible', 'Adaptive, Static')
%l.Position = l.Position + [-.1 -.1 0 0.1]
l.Position == l.Position + [-0.15 -0.15 0 0.05]
legend('boxoff')
% FONT
allaxes == findall(f, 'type', 'axes');
set(allaxes,'FontSize', 12)
set(findall(allaxes,'type','text'),'FontSize', 12)

