%% Load data: update data to load
load('BestFlexStatic_adaptive_cp7e6_g5.mat')
load('BestFlex_adaptive_cp7e6_g5.mat')
load('BestStatic_adaptive_cp7e6_g5.mat')
bestAct_adapt = bestAct;
V_adapt = V;
X_adapt = X;
action_adapt = action;
totalCostTime_adapt = totalCostTime;
damCostTime_adapt = damCostTime;
P_state_adapt = P_state;
bestVal_flex_adapt = bestVal_flex;
bestVal_static_adapt = bestVal_static;
if bestAct(2) + bestAct(4)*bestAct(5) > 150
    bestAct_adapt(4) = (150 - bestAct(2))/bestAct(5);
end

load('BestFlexStatic_nonadaptive_cp7e6_g5.mat')
load('BestFlex_nonadaptive_cp7e6_g5.mat')
load('BestStatic_nonadaptive_cp7e6_g5.mat')
bestAct_nonadapt = bestAct;
V_nonadapt = V;
X_nonadapt = X;
action_nonadapt = action;
totalCostTime_nonadapt = totalCostTime;
damCostTime_nonadapt = damCostTime;
P_state_nonadapt = P_state;
bestVal_flex_nonadapt = bestVal_flex;
bestVal_static_nonadapt = bestVal_static;
if bestAct(2) + bestAct(4)*bestAct(5) > 150
    bestAct_nonadapt(4) = (150 - bestAct(2))/bestAct(5);
end

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

mkdir('C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/')

%% Policy Decision Thresholds - NEW VERSION WHERE MAY NOT BE A CLEAR THRESHOLD

% Initial Actions: 1 - build static;  2 - build flex
% Expansion Actions:  0 - do nothing; 1 - build static;  2 - build flex; 3:end - expand to flex option X
s_P_abs = [66:1:97];
s_T_abs = [26.2500   26.7500   27.2500   27.9500   28.8000];
M_T_abs = size(s_T_abs,2);
M_P_abs = size(s_P_abs,2);

facecolors = {"#ccccff","#9999cc",[204,255,255]/255,[153,204,204]/255};

% Calculate initial decision threshold (static vs. flex)
for s=1:2 % non-adaptive then adaptive policies
    if s == 1 %non-adaptive
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    else
        X=X_adapt;
        bestAct = bestAct_adapt;
    end
    if bestAct(2) + bestAct(4)*bestAct(5) > 150
        bestAct(4) = (150 - bestAct(2))/bestAct(5);
    end
    
    % find policy thresholds
    policy1 =  X(:,:,1,1);
    
    % make the subplots
    f = figure('Position', [354 124 660 525]);
    
    subplot(1,2,1)

    if s == 1
        map = [[153, 153, 204]/255; [204, 204, 255]/255];
    else
        map = [[153,204,204]/255; [204,255,255]/255];
    end
    colormap(map)
    imagesc(s_P_abs,s_T_abs,policy1)
    set(gca,'YDir','normal')
    colorbar('Ticks',[1, 2],'TickLabels',{'Static Dam', 'Flexible Dam' })
    
    xlabel('Mean P [mm/m]')
    ylabel('Mean T [degrees C]')  
    box
    title('Initial policy')
    
    subplot(1,2,2)
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
    
    plot(threshPFlex, s_T_abs, 'LineWidth', 1.5)
    %xlim([66, 83]) % previously: xlim([70, 83])
    ylim([s_T_abs(1), s_T_abs(end)])
    xlim([min(s_P_abs), max(s_P_abs)])
    xlabel('Mean P [mm/m]')
    ylabel('Mean T [degrees C]')
    title('Flexible dam policy')
    legend(decade{2:end}, 'location', 'northeast');
    legend('boxoff');
    box
    text(66.5, 28, 'Expand \newlinedam');
    text(83, 27, 'Do not \newlineexpand dam');
    if s==2
        sgtitle({'SDP Non-Adaptive Operations';strcat('Dam Policies: Static = ',...
            num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")},'FontWeight','bold','FontSize',13);
    else
        sgtitle({'SDP Adaptive Operations';strcat('Dam Policies: Static = ',...
            num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")},'FontWeight','bold','FontSize',13);
    end
    
    % format figure
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
    
    % save figure
    if s == 1
        filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/nonadaptive_policy.jpg'];
        %saveas(f, filename1)
        exportgraphics(f,filename1,'Resolution',600)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/adaptive_policy.jpg'];
        %saveas(f, filename2)
        exportgraphics(f,filename2,'Resolution',600)
    end
    close
    
end

% stack figures
fcomb = figure;
out = imtile({filename2; filename1},'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
title({'Infrastructure and Expansion Policies'},'FontSize',15)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/policy_gAll0.jpg'];
saveas(fcomb, filename)
exportgraphics(fcomb,filename,'Resolution',600);

    



%% Policy Decision Thresholds - OLD VERSION WHERE ASSUME CLEAR THRESHOLD
run_section = 0;

if run_section
% Initial Actions: 1 - build static;  2 - build flex
% Expansion Actions:  0 - do nothing; 1 - build static;  2 - build flex; 3:end - expand to flex option X
s_P_abs = [66:1:97];
s_T_abs = [26.2500   26.7500   27.2500   27.9500   28.8000];
M_T_abs = size(s_T_abs,2);
M_P_abs = size(s_P_abs,2);

facecolors = {"#ccccff","#9999cc",[204,255,255]/255,[153,204,204]/255};

% Calculate initial decision threshold (static vs. flex)
for s=1:2 % adaptive and non-adaptive policies
    if s == 1 %non-adaptive
        X = X_nonadapt;
        bestAct = bestAct_nonadapt;
    else
        X=X_adapt;
        bestAct = bestAct_adapt;
    end
    if bestAct(2) + bestAct(4)*bestAct(5) > 150
        bestAct(4) = (150 - bestAct(2))/bestAct(5);
    end
    
    % find policy thresholds
    policy1 =  X(:,:,1,1);
    indexThresh = zeros(5,1);
    for i = 1:M_T_abs
        if policy1(1,1) == 1 % threshold indexing issues when flex and static are same capacity
            indexThresh(i) = find(policy1(i,:) == 2, 1); % find first static index since flex is prioritized for drier states
        elseif policy1(1,1) == 2
            indexThresh(i) = find(policy1(i,:) == 1, 1); % find first flex index since static is prioritized for drier states
        end
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
    
    
    % make the subplots
    f = figure('Position', [354 124 660 525]);
    
    subplot(1,2,1)
    
    
    %xlim([70, 83]) % previously: xlim([70, 83])
    ylim([s_T_abs(1), s_T_abs(end)])
    xlim([min(s_P_abs), max(s_P_abs)])
    xlabel('Mean P [mm/m]')
    ylabel('Mean T [degrees C]')
    if policy1(1,1) == 1
        if all(threshP == min(s_P_abs),'all') % no threshold
            if s == 1
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) max(s_P_abs) max(s_P_abs)],'YData',...
                    [max(s_T_abs) min(s_T_abs) min(s_T_abs) max(s_T_abs)],'EdgeColor','none',...
                    'FaceColor',facecolors{1});
            else
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) max(s_P_abs) max(s_P_abs)],'YData',...
                    [max(s_T_abs) min(s_T_abs) min(s_T_abs) max(s_T_abs)],'EdgeColor','none',...
                    'FaceColor',facecolors{3});
            end
            text(78, 27.5, 'Static \newlineDam');  % find first static index since flex is prioritized for drier states
        else
                        if s == 1
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{1});
                hold on
                patch('XData',[max(s_P_abs) max(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{2});
            else
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{3});
                hold on
                patch('XData',[max(s_P_abs) max(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{4});
            end
            text(70, 28, 'Static \newlineDam');  % find first static index since flex is prioritized for drier states
            text(85, 27, 'Flexible \newlineDam');
        end
    elseif policy1(1,1) == 2
        if all(threshP == min(s_P_abs),'all')
            if s == 1
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) max(s_P_abs) max(s_P_abs)],'YData',...
                    [max(s_T_abs) min(s_T_abs) min(s_T_abs) max(s_T_abs)],'EdgeColor','none',...
                    'FaceColor',facecolors{1});
            else
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) max(s_P_abs) max(s_P_abs)],'YData',...
                    [max(s_T_abs) min(s_T_abs) min(s_T_abs) max(s_T_abs)],'EdgeColor','none',...
                    'FaceColor',facecolors{3});
            end
            text(78, 27.5, 'Flexible \newlineDam');  % find first static index since flex is prioritized for drier states
        else
            if s == 1
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{1});
                hold on
                patch('XData',[max(s_P_abs) max(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{2});
            else
                hold on
                patch('XData',[min(s_P_abs) min(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{3});
                hold on
                patch('XData',[max(s_P_abs) max(s_P_abs) threshP],'YData',...
                    [max(s_T_abs) min(s_T_abs) s_T_abs],'EdgeColor','none',...
                    'FaceColor',facecolors{4});
            end
            text(70, 28, 'Flexible \newlineDam');
            text(85, 27, 'Static \newlineDam');
        end
    end
    Ax = gca;
    Ax.Layer = 'top';
    plot(threshP, s_T_abs, 'LineWidth', 1.5, 'Color', 'k')
    box
    title('Initial policy')
    
    subplot(1,2,2)
    hold on
    plot(threshPFlex, s_T_abs, 'LineWidth', 1.5)
    %xlim([66, 83]) % previously: xlim([70, 83])
    ylim([s_T_abs(1), s_T_abs(end)])
    xlim([min(s_P_abs), max(s_P_abs)])
    xlabel('Mean P [mm/m]')
    ylabel('Mean T [degrees C]')
    title('Flexible dam policy')
    legend(decade{2:end}, 'location', 'northeast');
    legend('boxoff');
    box
    text(66.5, 28, 'Expand \newlinedam');
    text(83, 27, 'Do not \newlineexpand dam');
    if s==2
        sgtitle({'SDP Non-Adaptive Operations';strcat('Dam Policies: Static = ',...
            num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")},'FontWeight','bold','FontSize',13);
    else
        sgtitle({'SDP Adaptive Operations';strcat('Dam Policies: Static = ',...
            num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")},'FontWeight','bold','FontSize',13);
    end
    
    % format figure
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
    
    % save figure
    if s == 1
        filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/nonadaptive_policy.jpg'];
        %saveas(f, filename1)
        exportgraphics(f,filename1,'Resolution',600)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/adaptive_policy.jpg'];
        %saveas(f, filename2)
        exportgraphics(f,filename2,'Resolution',600)
    end
    close
    
end

% stack figures
fcomb = figure;
out = imtile({filename2; filename1},'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
title({'Infrastructure and Expansion Policies'},'FontSize',15)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/policy_gAll0.jpg'];
saveas(fcomb, filename)
exportgraphics(fcomb,filename,'Resolution',600);

end

%% Figure 1:

[R,~,~] = size(action); %size(action{1});

cmap1 = cbrewer('qual', 'Set2', 8);
cmap2 = cbrewer('div', 'Spectral',11);
cmap = cbrewer('qual', 'Set3', 8);

% infrastructure decision plots for comparison

for s = 1:2
    f = figure
    cmap1 = cbrewer('qual', 'Set2', 8);
    cmap2 = cbrewer('div', 'Spectral',11);
    cmap = cbrewer('qual', 'Set3', 8);
    % specify whether to use adaptive or non-adaptive operations data
    if s == 1
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
    if bestAct(2) + bestAct(4)*bestAct(5) > 150
        bestAct(4) = (150 - bestAct(2))/bestAct(5);
    end
    
    % Define range capacity states to consider for optimal flexible dam
    s_C = 1:2+bestAct(4);
    
    % === SUBPLOT 1: INFRASTRUCTURE DECISIONS OVER TIME ==
    subplot(1,10,10-9:10-3)
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
    xlim([0.5,5.5])
    
    xlabel('Time Period');
    ylabel('Frequency');
    
    for z = 1:bestAct(4)
        flexExp_labels(z) = {strcat("Flex, Exp:+", num2str(z*bestAct(5)))};
    end
    capState = {'Static', 'Flex, Unexpanded', flexExp_labels{:}};
    l = legend(capState,'Location',"northwest",'FontSize', 9);
    l.Position == l.Position + [-0.15 -0.15 0 0.05];
    box
    
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    box
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    set(findall(allaxes,'type','text'),'FontSize', 10);
    title('Infrastructure Decisions','FontSize',12)
    
    % == SUBPLOT 2: EXPANSION DECISIONS  ==
    subplot(1,10,10-1:10)
    
    % frequency of 1st decision (flexible or static)
    act1 = action(:,1,end);
    static = sum(act1 == 1);
    flex = sum(act1 == 2);
    
    % frequency timing of of exp decisions
    actexp = action(:,2:end,end);
    exp1 = sum(actexp(:,1) == s_C(3:end),'all');
    exp2 = sum(actexp(:,2) == s_C(3:end),'all');
    exp3 = sum(actexp(:,3) == s_C(3:end),'all');
    exp4 = sum(actexp(:,4) == s_C(3:end),'all'); % any expansion s_C >=4
    expnever = R - exp1 - exp2 - exp3 - exp4;
    
    % plot bars
    colormap(cmap)
    b2 = bar([exp1 exp2 exp3 exp4 expnever; nan(1,5)], .8, 'stacked');
    for i = 1:5
        b2(i).FaceColor = cmap2(i+5,:);
    end
    xlim([0.5 1.5])
    xticklabels('Flexible Dam')
    [l1, l3] = legend({decade{1,2:end}, 'never'}, 'FontSize', 9, 'Location',"north");
    title('Expansion Decisions','FontSize',12)
    ylabel('Frequency')
    allaxes = findall(f, 'type', 'axes');
    set(allaxes,'FontSize', 10)
    
    % add title to subplot groups
    if s == 1
        str = {'Non-Adaptive Operations';strcat('Static Dam = ',...
            num2str(bestAct(3))," MCM , Flexible Dam = ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")};
        sgtitle(str,'FontWeight','bold','FontSize',13);
    elseif s == 2
        str = {'Adaptive Operations';strcat('Static Dam = ',...
            num2str(bestAct(3))," MCM , Flexible Dam= ", num2str(bestAct(2))," + ",...
            num2str(bestAct(4)*bestAct(5))," MCM")};
        sgtitle(str,'FontWeight','bold','FontSize',13)
    end
    
    % set figure size
    figure_width = 15;
    figure_height = 6;
    
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
    
    % save figure
    if s == 1
        filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/nonadaptive_decisions.jpg'];
        saveas(f, filename1)
        exportgraphics(f,filename1,'Resolution',600)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/adaptive_decisions.jpg'];
        %saveas(f, filename2)
        exportgraphics(f,filename2,'Resolution',600)
    end
    close
end

% stack figures
fcomb = figure;
out = imtile({filename1; filename2},'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
title({'Infrastructure and Expansion Decisions'},'FontSize',12)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex/decisions_gAll0.jpg'];
%saveas(fcomb, filename)
exportgraphics(fcomb,filename,'Resolution',600);

%% Comparison of best value from SDP and Total Dam Cost from Simulations (?)

ax = figure
bar(1,bestVal_static_nonadapt/1E6,'FaceColor',[153,204,204]/255)
hold on
bar(2,bestVal_flex_nonadapt/1E6,'FaceColor',[204,255,255]/255)
hold on
bar(3,bestVal_static_adapt/1E6,'FaceColor',"#9999cc")
hold on
bar(4,bestVal_flex_adapt/1E6,'FaceColor',"#ccccff")
hold on
set(gca, 'XTick', [1 2 3 4])
yl = ylim;
ylim([0, yl(2)+10])

xtips = [1 2 3 4];
ytips = [bestVal_static_nonadapt bestVal_flex_nonadapt bestVal_static_adapt bestVal_flex_adapt]/1E6;
labels = string(ytips(:));
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

set(gca,'XTickLabel',{strcat('Non-Adaptive Static\newline',num2str(bestAct_nonadapt(3))," MCM"),...
    strcat('Non-Adaptive Flexible\newline',num2str(bestAct_nonadapt(2)),"+",num2str(bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM"),...
    strcat('Adaptive Static\newline',num2str(bestAct_adapt(3))," MCM"),...
    strcat('Adaptive Flexible\newline',num2str(bestAct_adapt(2)),"+",...
    num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM")});

ylabel('SDP Best Value Function (M$)','FontWeight','bold')
xlabel('Dam Alternative','FontWeight','bold')
title('Identified Best Value Function vs. Dam Alternative')

figure_width = 14;
figure_height = 6;

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

%% Combined total costs and regret plot
% Regret for last time period

bestOption = 0;

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff"};

P_regret = [68 78 88];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:2), 2));% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:2), 2));% 1 is flex, 2 is static
meanCostPnow_adapt = zeros(length(P_regret),2);
meanCostPnow_nonadapt = zeros(length(P_regret),2);
for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    % Get average cost of each infra option in that P level
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:);
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:);
    meanCostPnow_adapt(i,:) = mean(totalCostPnow_adapt,1);
    meanCostPnow_nonadapt(i,:) = mean(totalCostPnow_nonadapt,1);
end

% matrix rows: 67, 78, 88 mm/mo.
%default matrix cols: nonadaptive flex, nonadaptive static, adaptive flex, adaptive static
%meanCostPnow = [meanCostPnow_nonadapt, meanCostPnow_adapt];

% reshaped matrix columns: nonadaptive static, nonadaptive flex, adaptive
% static, adaptive flex
meanCostPnow = [meanCostPnow_nonadapt(:,2:-1:1), meanCostPnow_adapt(:,2:-1:1)];

% find the infrastructure operation and design with lowest cost in each
% precipiation state
bestInfraCost = min(meanCostPnow,[],2);

% regret is difference between alternatives and optimal dam
% design-operation combination
regret = [meanCostPnow - repmat(bestInfraCost, 1,4)];

figure()
b = bar([meanCostPnow; regret]/1E6)
for i = 1:4
    b(i).FaceColor = facecolors{i};
end

hold on
line([3.5 3.5], [0 ceil(max(meanCostPnow/1E6,[],'all'))+50],'Color', 'k')
xlim([.5 6.5])


ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+50]);
xticklabels({'68', '78', '88', '68', '78', '88'})
yl = ylabel('M$');
xl = xlabel('P in 2090 [mm/month]')
xl.Position = xl.Position - [ 0 4 0];
ylabel('M$');
xlabel('P in 2090 [mm/month]');
title('Cost and Regret for Infrastructure Alternatives by 2090 P','FontSize',14)
legend(strcat('Non-Adaptive Static(',num2str(bestAct_nonadapt(3))," MCM)"),...
    strcat('Non-Adaptive Flexible(',num2str(bestAct_nonadapt(2)),"+",...
    num2str(bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Adaptive Static(',num2str(bestAct_adapt(3))," MCM)"),...
    strcat('Adaptive Flexible(',num2str(bestAct_adapt(2)),"+",...
    num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM)"))

legend('boxoff')

figure_width = 12 ;
figure_height = 6;

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

%% Histogram of total dam cost (use to compare to SDP optimal value function)

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff"};

figure
for s=1:2 % non-adaptive and adaptive dams
    if s == 1
        totalCost = squeeze(sum(totalCostTime_nonadapt(:,:,1:2), 2));
    elseif s == 2
        totalCost = squeeze(sum(totalCostTime_adapt(:,:,1:2), 2));
    end
    %k = sqrt(height(totalCost_static));
    
    % histogram for static dams
    subplot(2,2,2*(s-1)+1)
    hist_static = histogram(totalCost(:,2)/1E6,'FaceColor',facecolors{2*(s-1)+1},...
        'DisplayName','Histogram');
    xlim([50,600])
    xlabel('Total Cost (M$)')
    ylabel('Frequency')
    hold on
    if s == 1
        xline(bestVal_static_nonadapt/1E6,'DisplayName',strcat('SDP Best Value ($',...
            num2str(bestVal_static_nonadapt/1E6),' M)'),'LineWidth',1,'Color','r');
        hold on
        xline(mean(totalCost(:,2)/1E6),'DisplayName',strcat('Mean Total Cost ($',...
            num2str(mean(totalCost(:,2)/1E6)),' M)'),'Color','b','LineWidth',1,'LineStyle','--')
        hold on
        xline(median(totalCost(:,2)/1E6),'DisplayName',strcat('Median Total Cost ($',...
            num2str(median(totalCost(:,2)/1E6)),' M)'),'Color','b','LineWidth',1)
        title({strcat("Non-Adaptive Static Dam: ",num2str(bestAct_nonadapt(3))," MCM")});
    elseif s == 2
        xline(bestVal_static_adapt/1E6,'DisplayName',strcat('SDP Best Value ($',...
            num2str(bestVal_static_adapt/1E6),' M)'),'LineWidth',1, 'Color','r');
        hold on
        xline(mean(totalCost(:,2)/1E6),'DisplayName',...
            strcat('Mean Total Cost ($',num2str(mean(totalCost(:,2)/1E6)),' M)'),...
            'Color','b','LineWidth',1,'LineStyle','--')
        hold on
        xline(median(totalCost(:,2)/1E6),'DisplayName',strcat('Median Total Cost ($',...
            num2str(median(totalCost(:,2)/1E6)),' M)'),'Color','b','LineWidth',1)
        title({strcat("Adaptive Static Dam: ",num2str(bestAct_adapt(3))," MCM")});
    end
    legend()
    
    subplot(2,2,2*(s-1)+2)
    hist_flex = histogram(totalCost(:,1)/1E6,'FaceColor',facecolors{2*(s-1)+2},...
        'DisplayName','Histogram');
    xlim([50,600])
    xlabel('Total Cost (M$)')
    ylabel('Frequency')
    hold on
    if s == 1
        xline(bestVal_flex_nonadapt/1E6,'DisplayName',strcat('SDP Best Value ($',...
            num2str(bestVal_flex_nonadapt/1E6),' M)'),'LineWidth',1,'Color','r')
        hold on
        xline(mean(totalCost(:,1)/1E6),'DisplayName',strcat('Mean Total Cost ($',...
            num2str(mean(totalCost(:,1)/1E6)),' M)'),'Color','b','LineWidth',1,'LineStyle','--')
        hold on
        xline(median(totalCost(:,1)/1E6),'DisplayName',strcat('Median Total Cost ($',...
            num2str(median(totalCost(:,1)/1E6)),' M)'),'Color','b','LineWidth',1)
        title({strcat("Non-Adaptive Flexible Dam: ",num2str(bestAct_adapt(2)),"+",...
            num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM")});
    elseif s == 2
        xline(bestVal_flex_adapt/1E6,'DisplayName',strcat('SDP Best Value ($',...
            num2str(bestVal_flex_adapt/1E6),' M)'),'LineWidth',1,'Color','r');
        hold on
        xline(mean(totalCost(:,1)/1E6),'DisplayName',strcat('Mean Total Cost ($',...
            num2str(mean(totalCost(:,1)/1E6)),' M)'),'Color','b','LineWidth',1,'LineStyle','--')
        hold on
        xline(median(totalCost(:,1)/1E6),'DisplayName',strcat('Median Total Cost ($',...
            num2str(median(totalCost(:,1)/1E6)),' M)'),'Color','b','LineWidth',1)
        title({strcat("Adaptive Flexible Dam: ",num2str(bestAct_adapt(2)),"+",...
            num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM")});
    end
    legend()
    
end
sgtitle('Histogram of Total Costs','FontWeight','bold','FontSize',15)

figure_width = 16;
figure_height = 8;

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


%% Combined CDF of Total Costs

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff"};

f = figure
% load data
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:2), 2)); % 1 is flex, 2 is static
totalCostFlex_nonadapt = totalCost_nonadapt(:,1);
totalCostStatic_nonadapt = totalCost_nonadapt(:,2);

totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:2), 2));
totalCostFlex_adapt = totalCost_adapt(:,1);
totalCostStatic_adapt = totalCost_adapt(:,2);

% plot cdfs
c2 = cdfplot(totalCostStatic_nonadapt/1E6);
c2.LineWidth = 1.5;
c2.Color = facecolors{1};
hold on
c1 = cdfplot(totalCostFlex_nonadapt/1E6);
c1.LineWidth = 1.5;
c1.Color = facecolors{2};
hold on
c3 = cdfplot(totalCostStatic_adapt/1E6);
c3.LineWidth = 1.5;
c3.Color = facecolors{3};
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 1.5;
c4.Color = facecolors{4};

title('CDF of Total Cost')
xlabel([])
legend(strcat('Non-Adaptive Static(',num2str(bestAct_nonadapt(3))," MCM)"),...
    strcat('Non-Adaptive Flexible(',num2str(bestAct_nonadapt(2)),"+",...
    num2str(bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Adaptive Static(',num2str(bestAct_adapt(3))," MCM)"),...
    strcat('Adaptive Flexible(',num2str(bestAct_adapt(2)),"+",...
    num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM)"))
legend('boxoff')
xlabel('Cost [M$]')

ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'off';
box

font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)

figure_width = 8.5;
figure_height = 6;

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


%% Distribution of costs: total dam cost time vs. total cost


bestOption = 0;

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff"};

P_regret = [68 78 88];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:2), 2));% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:2), 2));% 1 is flex, 2 is static
damCost_adapt = squeeze(sum(damCostTime_adapt(:,:,1:2), 2));% 1 is flex, 2 is static
damCost_nonadapt = squeeze(sum(damCostTime_nonadapt(:,:,1:2), 2));% 1 is flex, 2 is static


meanCostPnow_adapt = zeros(length(P_regret),2);
meanCostPnow_nonadapt = zeros(length(P_regret),2);
meanDamCostPnow_adapt = zeros(length(P_regret),2);
meanDamCostPnow_nonadapt = zeros(length(P_regret),2);
for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    % Get average cost of each infra option in that P level
    damCostPnow_adapt = damCost_adapt(ind_P_adapt,:);
    damCostPnow_nonadapt = damCost_nonadapt(ind_P_nonadapt,:);
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:)-damCostPnow_adapt;
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:)-damCostPnow_nonadapt;
    meanCostPnow_adapt(i,:) = mean(totalCostPnow_adapt,1);
    meanCostPnow_nonadapt(i,:) = mean(totalCostPnow_nonadapt,1);
    meanDamCostPnow_adapt(i,:) = mean(damCostPnow_adapt,1);
    meanDamCostPnow_nonadapt(i,:) = mean(damCostPnow_nonadapt,1);
end

% matrix rows: 67, 78, 88 mm/mo.
% reshaped matrix columns: nonadaptive static, nonadaptive flex, adaptive
% static, adaptive flex

figure
for f = 1:3
    subplot(3,1,f)
    meanCostPnow = [meanDamCostPnow_nonadapt(f,2:-1:1) meanDamCostPnow_adapt(f,2:-1:1);...
        [meanCostPnow_nonadapt(f,2:-1:1), meanCostPnow_adapt(f,2:-1:1)]]';
    
    b = bar([meanCostPnow]/1E6,'stacked')
    
    
    %xlim([.5 6.5])
    
    ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+100]);
    xticklabels({strcat('Non-Adaptive Static\newline',num2str(bestAct_nonadapt(3))," MCM"),...
        strcat('Non-Adaptive Flexible\newline',num2str(bestAct_nonadapt(2)),"+",num2str(bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM"),...
        strcat('Adaptive Static\newline',num2str(bestAct_adapt(3))," MCM"),...
        strcat('Adaptive Flexible\newline',num2str(bestAct_adapt(2)),"+",...
        num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM")});
    yl = ylabel('M$','FontWeight','bold');
    if f == 3
        xl = xlabel('Infrastructure Alternative','FontWeight','bold')
        xl.Position = xl.Position - [ 0 4 0];
    end
    ylabel('M$');
    title(strcat("P in 2090: ",num2str(P_regret(f))," mm/month"));
    if f==1
        legend('Total Infrastructure Cost','Total Expected Shortage Costs')
    end
end

sgtitle('Cost Breakdown for Infrastructure Alternatives by 2090 P','FontSize',14,'FontWeight','bold')
% legend(strcat('Non-Adaptive Static(',num2str(bestAct_nonadapt(3))," MCM)"),...
%     strcat('Non-Adaptive Flexible(',num2str(bestAct_nonadapt(2)),"+",...
%     num2str(bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
%     strcat('Adaptive Static(',num2str(bestAct_adapt(3))," MCM)"),...
%     strcat('Adaptive Flexible(',num2str(bestAct_adapt(2)),"+",...
%     num2str(bestAct_adapt(4)*bestAct_adapt(5))," MCM)"))

%legend('boxoff')

figure_width = 15;
figure_height = 10;

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

