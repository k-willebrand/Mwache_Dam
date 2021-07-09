%% Figures 
% Load data and set path
if true
%addpath(genpath('/Users/sarahfletcher/Documents/MATLAB/figure_tools'))
end
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};


%% Optimal policies plots: Fig 4
% figure (1a): In N=1, build flexible or do not build flex

if true

% Calculate initial threshold
policy1 =  X(:,:,1,1);
indexThresh = zeros(M_T_abs,1);
for i = 1:M_T_abs
    indexThresh(i) = find(policy1(i,:) == 2, 1);
end
threshP = s_P_abs(indexThresh);

% Calculate flex exp threshold
policyflex = cell(1,4);
for i = 1:4
    policyflex{i} = X(:,:,2,i+1);
end

threshPFlex = zeros(6, M_T_abs);

% Find wherever flex dam is expanded to any threshold (i.e., action >= 3)
for j = 1:4
    indexThresh = zeros(M_T_abs,1);
    for i = 1:M_T_abs
        indexThresh(i) = find(policyflex{j}(i,:) == 0, 1);
    end
    threshPFlex(j,:) = s_P_abs(indexThresh);
end


% Option 1: subplots
f = figure('Position', [354 124 660 525]);

subplot(1,2,1)
plot(threshP, s_T_abs, 'LineWidth', 1.5, 'Color', 'k')
%xlim([70, 83]) % previously: xlim([70, 83])
ylim([s_T_abs(1), s_T_abs(end)])
xlabel('Mean P [mm/m]')
ylabel('Mean T [degrees C]')
text(73, 32.5, 'Static Dam');
text(79, 27, 'Flexible Dam');
title('Initial policy')


subplot(1,2,2)
hold on
plot(threshPFlex, s_T_abs, 'LineWidth', 1.5)
%xlim([66, 83]) % previously: xlim([70, 83])
ylim([s_T_abs(1), s_T_abs(end)])
xlabel('Mean P [mm/m]')
ylabel('Mean T [degrees C]')
title('Flexible dam policy')
legend(decade{2:end}, 'location', 'northwest');
legend('boxoff');
text(66.5, 31.5, 'Expand Dam');
text(78, 27, 'Do not \newlineexpand dam');
sgtitle(['Dam Policies: Static = ', num2str(optParam.staticCap), ...
    ', Flex Unexp = ', num2str(optParam.smallCap)], 'FontSize', 13);
% Option 2 combined
if false

f = figure;
plot(threshP, s_T_abs, 'LineWidth', 1.5, 'Color', 'k')
hold on
plot(threshPFlex, s_T_abs, 'LineWidth', 1.5)
xlim([70 83])
ylim([s_T_abs(1), s_T_abs(end)])
xlabel('Mean P [mm/m]')
ylabel('Mean T [degrees C]')

end


FigHandle = f;
figure_width = 5;
figure_height = 3;
font_size = 6;
line_width = 1;
export_ppi = 600;
print_png = true;
print_pdf = false;
savename = 'SDP plots/discounting 3 perc/sdp_policy2';
%printsetup(FigHandle, figure_width, figure_height, font_size, line_width, export_ppi, print_png, print_pdf, savename)


end

%% Figure 5: Combine hist and cdf plot

[R,~,~] = size(action); %size(action{1});
labels = {'a)', 'b)', 'c)', 'd)', 'e)', 'f)'};

f = figure;
addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Plots/plotting utilities/cbrewer/cbrewer/cbrewer');
cmap1 = cbrewer('qual', 'Set2', 8);
cmap2 = cbrewer('div', 'Spectral',11);
cmap = [cmap1(1,:); cmap1(4,:); cmap2(6:end,:)];
cmap = cbrewer('qual', 'Set3', 8);

% histogram w/ stacked bars
for k = 1%:3
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,end); %action{k}(:,1,end);
    static = sum(act1 == 1);
    %large = sum(act1 == 2);
    flex = sum(act1 == 2);
    
    % frequency of exp decision
    actexp = action(:,2:end,end); % action{k}(:,2:end,end);
    exp1 = sum(actexp(:,1) == s_C(3:end),'all');
    exp2 = sum(actexp(:,2) == s_C(3:end),'all');
    exp3 = sum(actexp(:,3) == s_C(3:end),'all');
    exp4 = sum(actexp(:,4) == s_C(3:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    subplot(1,8,k*8-7:k*8-6)
    colormap(cmap)
    %b1 = bar([1 1.5],[small large flex; nan(1,3)], .8,'stacked');
    b1 = bar([1 1.5],[static flex; nan(1,2)], .8,'stacked');
    b1(1).FaceColor = cmap1(1,:);
    b1(2).FaceColor = cmap1(2,:);
    %b1(3).FaceColor = cmap1(3,:);
    hold on
    b2 = bar([1.5 2],[exp1 exp2 exp3 exp4 expnever; nan(1,5)], .8, 'stacked');
    for i = 1:5
        b2(i).FaceColor = cmap2(i+5,:);
    end
    xlim([0.7 1.8])
    set(gca,'xtick',[1 1.5])
    set(gca,'xticklabel',{'1st', 'exp'})
    if k == 1
        [l1, l3] = legend([b1(1) b1(2) b2], { 'Static', 'Flex', decade{2:end}, 'never'}, 'FontSize', 10); %b1(2) b1(3)
        title('Infrastructure decisions') 
        
%         for i=8:14
%             left = l2(i).Children.Vertices(1,1);
%             width = l2(i).Children.Vertices(3,1) - l2(i).Children.Vertices(2,1);
%             l2(i).Children.Vertices(3:4,1) = left + width/2;
%         end
%         
%         for i=1:7
%             l2(i).Position(1) = l2(i).Position(1) - width/2;
%         end
%         
%         l1.Position(1) = l1.Position(1) - .008;
%         l1.Position(2) = l1.Position(2) - .06;
%         
    end
    text(0.2,1000, labels{k*2-1})
    ylabel('Frequency')
     
    % plot cdfs
    subplot(1,8,k*8-4:k*8) 
    totalCostFlex = sum(totalCostTime(:,:,1),2);%sum(totalCostTime{k}(:,:,1),2)
    totalCostLarge = sum(totalCostTime(:,:,2),2); %sum(totalCostTime{k}(:,:,2),2);
    %totalCostSmall = sum(totalCostTime(:,:,3),2); %sum(totalCostTime{k}(:,:,3),2)
    hold on
    c2 = cdfplot(totalCostLarge/1E6);
    c2.LineWidth = 1.5;
%     c3 = cdfplot(totalCostSmall/1E6);
%     c3.LineWidth = 1.5;
    c1 = cdfplot(totalCostFlex/1E6);
    c1.LineWidth = 1.5;
    if k == 1
        title('CDF of Total Cost')
        xlabel([])
        legend( {'Static', 'Flexible'})
        legend('boxoff')
        xlabel('Cost [M$]')
    end
    if k == 3
        xlim([180 350])
        xticks(190:20:350)
    else
        %xlim([70 200])
    end
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    if k == 3
        text(160, 1, labels{k*2})
    else
        text(54, 1, labels{k*2})
    end
    if k == 1
        text(110, .15, 'Scenario A: Low demand - 3% DR')
    elseif k == 2
        text(125, .15, 'Scenario B: Low demand - 0% DR')
    else
        text(255, .15, 'Scenario C: High demand - 0% DR')
    end
end
%s = suptitle('Simulated infrastructure decisions and costs (N=1000)');
%s.FontWeight = 'bold';
font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)


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

savename = '/Users/sarahfletcher/Documents/MATLAB/Mombasa_Climate/SDP plots/Combined/hist_cdf_combined2';
% print(gcf, '-dpdf', strcat(savename, '.pdf'));


%% Regret plot: Fig 6

% Regret for last time period
bestOption = 0;

P_regret = [68 78 88];
totalCost = squeeze(sum(totalCostTime(:,:,1:2), 2));
meanCostPnow = zeros(length(P_regret),2);
for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P = P_state(:,end) == P_regret(i);
    % Get average cost of each infra option in that P level
    totalCostPnow = totalCost(ind_P,:);
    meanCostPnow(i,:) = mean(totalCostPnow,1);
end

bestInfraCost = min(meanCostPnow,[],2);
regret = meanCostPnow - repmat(bestInfraCost, 1,2);

f = figure;
font_size = 12;
bar([meanCostPnow; regret]/1E6)
hold on
line([3.5 3.5], [0 200],'Color', 'k')
xlim([.5 6.5])
ylim([0 200]);
xticklabels({'68', '78', '88', '68', '78', '88'})
yl = ylabel('M$')
yl.Position = yl.Position - [ .3 0 0];
xl = xlabel('P in 2090 [mm/month]')
xl.Position = xl.Position - [ 0 4 0];
title('Cost and Regret for Infrastructure Alternatives by 2090 P')
l = legend('Flexible', 'Static')
l.Position = l.Position + [-.1 -.1 0 0.1]
legend('boxoff')
% FONT
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
%printsetup(f, 7, 5, 12, 1, 300, 1, 1, 'regret' )

%% Flexible Expansion Selected: New Figure 7 (Keani)
% Distribution of expansion decisions to different capacities

% frequency of each exp threshold decision
actexp = action(:,2:end,end); % action{k}(:,2:end,end);
exp = struct;
for i=3:a_exp(end)
    exp.(strcat('to',string(i))) = sum(actexp(:,1:end) == i,'all');
end

figure('Position', [354 267 506 430]);
colormap(cmap)
b1 = bar([1 1.5],[struct2array(exp); nan(1,length(struct2array(exp)))], 0.8, 'stacked');
for i=1:length(struct2array(exp))
    b1(i).FaceColor = cmap1(i,:);
end

% UPDATE LEGEND AND TITLES FOR THE SCENARIO RAN IN MULTIFLEX
l = legend(capState(3:end), 'FontSize', 7);
l.Position = l.Position + [-.25 -.5 0 0.1]

t1 = title(['Expansion Decisions, ', 'Optimized Operations: ', num2str(storage(2:end)), ' MCM']);
%t2 = sgtitle('Expansion Decisions')
ylabel('Frequency')
%ylim([0,1200])
xlim([.5,1.5])
set(gca,'XTick',[])
xlabel('Expanded Flexible Dam Scenarios')

%% Flexible Expansion Over Time
s_C_bins = s_C - 0.01;
s_C_bins(end+1) = s_C(end)+0.01;

for k=1:5
    actCounts(k,:) = histcounts(action(:,k,3), s_C_bins);
    actCounts_test(k,:) = histcounts(action(:,k,3), s_C_bins);
end

for j=2:5
    actCounts(j,1) = actCounts(1,1);
    actCounts(j,2) = actCounts(j-1,2) - sum(actCounts(j,3:end));
    actCounts(j,3:end) = actCounts(j-1,3:end) + actCounts(j,3:end);
end

figure;
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
legend(capState, 'location', 'southeast');
title(['Dam Action Decisions: Static = ', num2str(optParam.staticCap), ...
    ', Flex Unexp = ', num2str(optParam.smallCap)], 'FontSize', 13);