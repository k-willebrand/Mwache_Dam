%% Load data: update data to load

% change default font style
set(groot,'defaultAxesFontName','Futura')

folder = 'Nov02optimal_dam_design_discount/Nov02optimal_dam_design_discount'; %'Multiflex_expansion_SDP/SDP_sensitivity_tests/Nov02optimal_dam_design_discount'
cd('C:/Users/kcuw9/Documents/Mwache_Dam')
mkdir('Plots/multiflex_comb')

load(strcat(folder,'/BestFlex_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestStatic_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestFlexStaticPlan_adaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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


load(strcat(folder,'/BestFlex_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestStatic_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
load(strcat(folder,'/BestFlexStaticPlan_nonadaptive_cp6e6_g7_percFlex75_percExp15_disc6_use3BestAct.mat'))
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


s_P_abs = 66:1:97;
s_T_abs = [26.25 26.75 27.25 27.95 28.8000];

% set label parameters
decade = {'2001-2020', '2021-2040', '2041-2060', '2061-2080', '2081-2100'};
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};
decadeline = {'2001-\newline2020', '2021-\newline2040', '2041-\newline2060', '2061-\newline2080', '2081-\newline2100'};

mkdir('C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex02Nov_comb/')

%% Bar plot optimal dam design capacities

facecolors = [[90, 90, 90]; [153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

facecolors_exp = [[90, 90, 89]; [153,204,203]; [204,255,254]; [153, 153, 203]; [204, 204, 254];...
    [255, 102, 101]; [255, 153, 152]]/255;

capacities = [[0 bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3) bestAct_adapt(3) ...
    bestAct_nonadapt(8) bestAct_adapt(8)];[0 0 0 bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
    bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
    bestAct_adapt(9)*bestAct_adapt(10)]]';

figure;
b = bar(capacities,'stacked', 'FaceColor','flat');

for i = 1:7
    b(1).CData(i,:) = facecolors(i,:);
    b(2).CData(i,:) = facecolors_exp(i,:);
end

hold on
yl = yline(150,'LineStyle',':','color',[0.1 0.1 0.1],'Label','Max Capacity');
yl.LabelHorizontalAlignment = 'left';
yl.FontSize = 8;
set(gca, 'XTick', [1 2 3 4 5 6]+1)
yl = ylim;
ylim([0, yl(2)+10])

set(gca,'XTickLabel',{strcat('Non-flexible Operations\newline      & Static Dam'),...
    strcat('Flexible Operations\newline      & Static Dam'),...
    strcat('Non-flexible Operations\newline   & Flexible Design'),...
    strcat('Flexible Operations\newline & Flexible Design'),...
    strcat('Non-flexible Operations\newline  & Flexible Planning'),...
    strcat('Flexible Operations\newline& Flexible Planning')});

ylabel('Optimal Dam Design Capacity (MCM)','FontWeight','bold')
xlabel('Dam Alternative','FontWeight','bold')
xlim([1.5,7.5])
title('Optimal Dam Design Capacity vs. Dam Alternative','FontSize',15)
legend('Initial Dam Capacity','Maximum Expanded Dam Capacity','Location','eastoutside',...
    'Orientation','horizontal')
%legend('Initial Dam\newlineCapacity','Maximum Expanded\newlineDam Capacity','Location','eastoutside')

% add lables with intial dam cost
xtips = [1 2 3 4 5 6]+1;
ytips = [bestAct_nonadapt(2) bestAct_adapt(2) bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5) ...
    bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5) bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10) ...
    bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)];
labels = {strcat('Initial Cost: $',string(round(damCostTime_nonadapt(1,1,2)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(damCostTime_adapt(1,1,2)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(damCostTime_nonadapt(1,1,1)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(damCostTime_adapt(1,1,1)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(damCostTime_nonadapt(1,1,3)/1E6,1)),'M'),...
    strcat('Initial Cost: $',string(round(damCostTime_nonadapt(1,1,3)/1E6,1)),'M')};
    
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',9)

figure_width = 18;
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


%im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
%    1-makehatch_plus('\',6),makehatch_plus('\',1),1-makehatch_plus('\',6),makehatch_plus('\',1)},facecolors);
im_hatchC = applyhatch_plusC(gcf,{makehatch_plus('\',1),makehatch_plus('\',1),...
    makehatch_plus('\\15',20), makehatch_plus('\',1), makehatch_plus('\\15',20), ...
    makehatch_plus('\',1),makehatch_plus('\\15',20),makehatch_plus('\',1),...
    makehatch_plus('\\15',20),makehatch_plus('\',1),makehatch_plus('\\15',20),makehatch_plus('\',1)},...
    [facecolors(2:4,:); facecolors_exp(4,:); facecolors(5,:); facecolors_exp(5,:); facecolors(6,:); facecolors_exp(6,:);...
    facecolors(7,:); facecolors_exp(7,:);facecolors(1,:); facecolors_exp(1,:)],[],300);


%% Plot flexible infrastructure decisions (SDP optimal expansion decisions)

% 0 - do nothing, 1 - expand +10, 2 - expand +20, ...
% expansion_colors = [[200, 198, 198];[144, 170, 203];[255, 176, 133];[249, 213, 167];...
%     [254, 241, 230]]/255;

% expansion_colors = [[[87, 117, 144];[67, 170, 139];[144, 190, 109];[249, 199, 79];...
%     [248, 150, 30];[243, 114, 44];[249, 65, 68]]/255];

expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;

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
                    X(X(:,:,2,N) == 0) = 3;
                    imagesc(s_P_abs,s_T_abs,(X(:,:,2,N)-3)/(bestAct(4)+1))
                    map = expansion_colors(1:bestAct(4)+1,:);
                    step = 1/(2*(1+bestAct(4)));
                    caxis([0, 1])
                    h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
                        'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_flex),"\newlineMCM")]);
                    %             caxis([2,2+bestAct(4)])
                    title({"Flexible Design Expansion Policy"; decade{N}},'FontWeight','bold')
                else % flexible planning
                    X(X(:,:,3,N) == 0) = 3+bestAct(4);
                    imagesc(s_P_abs,s_T_abs,(X(:,:,3,N)-3-bestAct(4))/(bestAct(9)+1))
                    map = expansion_colors(1:bestAct(9)+1,:);
                    step = 1/(2*(1+bestAct(9)));
                    caxis([0, 1])
                    h = colorbar('TicksMode','manual','Ticks',[step:2*step:1],...
                        'TickLabels',["Do Not\newlineExpand",strcat("+",string(expansions_plan),"\newlineMCM")]);
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
    close
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

%% Plot a comparison of best value function value
% order of colors: static non-adapt, static adapt, flex design non-adapt,
% flex design adapt, flex planning non-adapt, flex planning adapt
facecolors = {"#ccccff","#9999cc",[204,255,255]/255,[153,204,204]/255,...
    [255, 102, 102]/255,[255, 153, 153]/255};

ax = figure
bar(1,bestVal_static_nonadapt/1E6,'FaceColor',[153,204,204]/255)
hold on
bar(2,bestVal_static_adapt/1E6,'FaceColor',[204,255,255]/255)
hold on

bar(3,bestVal_flex_nonadapt/1E6,'FaceColor',[153, 153, 204]/255)
hold on
bar(4,bestVal_flex_adapt/1E6,'FaceColor',[204, 204, 255]/255)
hold on

bar(5,bestVal_plan_nonadapt/1E6,'FaceColor',[255, 102, 102]/255)
hold on
bar(6,bestVal_plan_adapt/1E6,'FaceColor',[255, 153, 153]/255)
hold on

set(gca, 'XTick', [1 2 3 4 5 6])
yl = ylim;
ylim([0, yl(2)+10])

xtips = [1 2 3 4 5 6];
ytips = [bestVal_static_nonadapt bestVal_static_adapt bestVal_flex_nonadapt...
    bestVal_flex_adapt bestVal_plan_nonadapt bestVal_plan_adapt]/1E6;
labels = string(ytips(:));
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

set(gca,'XTickLabel',{strcat('Non-Adaptive Static\newline(',num2str(bestAct_nonadapt(2))," MCM)"),...
    strcat('Adaptive Static\newline(',num2str(bestAct_adapt(2))," MCM)"),...
    strcat('Non-Adaptive Flexible\newline(',num2str(bestAct_nonadapt(3)),"-",num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Adaptive Flexible\newline(',num2str(bestAct_adapt(3)),"-",...
    num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),strcat('Non-Adaptive Flex. Plan\newline(',...
    num2str(bestAct_nonadapt(8)),"-",num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
    strcat('Adaptive Flex. Plan\newline(',num2str(bestAct_nonadapt(8)),"-",...
    num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)")});

ylabel('SDP Best Value Function (M$)','FontWeight','bold')
xlabel('Dam Alternative','FontWeight','bold')
xlim([0.5,6.5])
title('Identified Best Value Function vs. Dam Alternative','FontSize',15)

figure_width = 18;
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

%% Bar plots of Capacity State over Time (Jenny's figure)

plotThis = 1;

if plotThis == 1
    
    % infrastructure decision plots for comparison
    
nonadapt_plan_colors = [[255,102,102];[255,153,153];[255,214,214];[255,255,255];[224,224,224]];
nonadapt_flex_colors = [[153,153,204];[213,213,255];[234,234,255];[238,184,192];[255,255,255];[224,224,224]];

adapt_plan_colors = [[255,153,153];[255,204,204];[255,243,243];[255,255,255];[224,224,224]];
adapt_flex_colors = [[204,204,255];[230,230,255];[243,243,255];[235,255,255];[255,255,255];[224,224,224]];

    
    for s = 1:2 % for non-adaptive and adaptive operations
        f = figure
        
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
        
        % === SUBPLOT 1: INFRASTRUCTURE DECISIONS OVER TIME ==
        subplot(1,10,10-9:10-3)
        s_C_bins = s_C - 0.01;
        s_C_bins(end+1) = s_C(end)+0.01;
        
        clear cPnowCounts cPnowCounts_test
        
        for k=1:5
            cPnowCounts(k,:) = histcounts(action(:,k,4), s_C_bins);
            cPnowCounts_test(k,:) = histcounts(action(:,k,4), s_C_bins);
        end
        
        for j=2:5
            cPnowCounts(j,1) = cPnowCounts(1,1);
            cPnowCounts(j,2) = cPnowCounts(j-1,2) - sum(cPnowCounts(j,4:3+bestAct(4)));
            cPnowCounts(j,3) = cPnowCounts(j-1,3) - sum(cPnowCounts(j,4+bestAct(4):end));
            cPnowCounts(j,4:end) = cPnowCounts(j-1,4:end) + cPnowCounts(j,4:end);
        end
        
        colormap(cmap);
        b1 = bar(cPnowCounts, 'stacked');
        for i=1:length(b1)
            b1(i).FaceColor = cmap1(i,:);
        end
        xticklabels(decade);
        xlim([0.5,5.5])
        
        xlabel('Time Period');
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
        title('Infrastructure Decisions','FontSize',12)
        
        % == SUBPLOT 2: EXPANSION DECISIONS  ==
        subplot(1,10,10-1:10)
        
        % frequency of 1st decision (flexible or static)
        act1 = action(:,1,end);
        static = sum(act1 == 1);
        flex = sum(act1 == 2);
        plan = sum(act1 == 3);
        
        % frequency timing of of exp decisions
        actexp = action(:,2:end,end);
        exp1 = sum(actexp(:,1) == s_C(4:end),'all');
        exp2 = sum(actexp(:,2) == s_C(4:end),'all');
        exp3 = sum(actexp(:,3) == s_C(4:end),'all');
        exp4 = sum(actexp(:,4) == s_C(4:end),'all'); % any expansion s_C >=4
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
            filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/nonadaptive_decisions.jpg'];
            saveas(f, filename1)
            exportgraphics(f,filename1,'Resolution',1200)
        elseif s == 2
            filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/adaptive_decisions.jpg'];
            %saveas(f, filename2)
            exportgraphics(f,filename2,'Resolution',1200)
        end
        close
        clear flexExp_labels planExp_labels
    end
    
    % stack figures
    fcomb = figure;
    out = imtile({filename1; filename2},'BorderSize', 50,'BackgroundColor', 'white');
    imshow(out);
    title({'Infrastructure and Expansion Decisions'},'FontSize',12)
    filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/decisions_g7_percFlex5_percExp150.jpg'];
    %saveas(fcomb, filename)
    exportgraphics(fcomb,filename,'Resolution',1200);
end

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
    b1 = bar(1+0.5*(t-1),cPnowCounts(5,:)', 'stacked','FaceColor','flat');
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

    
%% COMBINE ROWS OF SUBPLOTS: Highlights from Jenny's Plots (initial infrastructure decision, final decision, timing of decisions)

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
    subplot(2,1,1)
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
    b1 = bar(1+(2*(s-1)+type),cPnowCounts(5,:)', 'stacked','FaceColor','flat');
    for i=1:length(b1)
        b1(i).FaceColor = cmap1(i,:);
    end
    hold on
    end
    
    xticklabels(decade);
    xlim([1.5 5.5])
    xline(3.5,'LineWidth',.8)
    
    xlabel('Time Period');
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
    
    subplot(2,1,2)
    
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
    b2 = bar(1+(2*(s-1)+type),[exp1 exp2 exp3 exp4 expnever]', .8, 'stacked','FaceColor','flat');
    for i = 1:5
        b2(i).FaceColor = cmap2(i+5,:);
    end
    hold on
    xlim([1.5 5.5])
    xline(3.5,'LineWidth',.8)
    
    xticklabels('Flexible Dam')
    [l1, l3] = legend({decade{1,2:end}, 'never'}, 'FontSize', 9, 'Location',"north");
    title('Expansion Decisions','FontSize',12)
    ylabel('Frequency')
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


%% Combined total costs and regret plot
% Regret for last time period

bestOption = 0;

facecolors = {[153,204,204]/255,"#9999cc",[255, 102, 102]/255,...
    [204,255,255]/255,"#ccccff",[255, 153, 153]/255};

%P_regret = [68 78 88];
P_regret = [72 79 87];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static, 3 is plan
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
meanCostPnow_adapt = zeros(length(P_regret),3);
meanCostPnow_nonadapt = zeros(length(P_regret),3);
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
meanCostPnow = [meanCostPnow_nonadapt(:,2), meanCostPnow_nonadapt(:,1),meanCostPnow_nonadapt(:,3), ...
    meanCostPnow_adapt(:,2),meanCostPnow_adapt(:,1),meanCostPnow_adapt(:,3)];

% find the infrastructure operation and design with lowest cost in each
% precipiation state
bestInfraCost = min(meanCostPnow,[],2);

% regret is difference between alternatives and optimal dam
% design-operation combination
regret = [meanCostPnow - repmat(bestInfraCost, 1,6)];

figure()
b = bar([meanCostPnow; regret]/1E6)
for i = 1:6
    b(i).FaceColor = facecolors{i};
end

hold on
line([3.5 3.5], [0 ceil(max(meanCostPnow/1E6,[],'all'))+50],'Color', 'k')
xlim([.5 6.5])


ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+50]);
%xticklabels({'68', '78', '88', '68', '78', '88'})
xticklabels({'72', '79', '87', '72', '79', '87'})
yl = ylabel('M$');
xl = xlabel('P in 2090 [mm/month]')
xl.Position = xl.Position - [ 0 4 0];
ylabel('M$');
xlabel('P in 2090 [mm/month]');
title('Cost and Regret for Infrastructure Alternatives by 2090 P','FontSize',14)
legend(strcat('Static Operations & Static Dam(',num2str(bestAct_nonadapt(2))," MCM)"),...
    strcat('Static Operations & Flexible Dam Design(',num2str(bestAct_nonadapt(3)),"-",...
    num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Static Operations & Flexible Dam Planning(',num2str(bestAct_nonadapt(8)),"-",...
    num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
    strcat('Flexible Operations & Static Dam(',num2str(bestAct_adapt(2))," MCM)"),...
    strcat('Flexible Operations & Adaptive Flexible Dam Design(',num2str(bestAct_adapt(3)),"-",...
    num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
    strcat('Flexible Operations & Flexible Dam Planning(',num2str(bestAct_adapt(8)),"-",...
    num2str(num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)))," MCM)"));

legend('boxoff')

figure_width = 16;
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

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",...
    [255, 102, 102]/255,[255, 153, 153]/255};

figure
for s=1:2 % non-adaptive and adaptive dams
    for type = 1:3
        if type == 1 % static dam
            if s == 1
                totalCost = squeeze(sum(totalCostTime_nonadapt(:,:,2), 2));
                bestVal = bestVal_static_nonadapt;
            elseif s == 2
                totalCost = squeeze(sum(totalCostTime_adapt(:,:,2), 2));
                bestVal = bestVal_static_adapt;
            end
        elseif type == 2 % flexible design dam
            if s == 1
                totalCost = squeeze(sum(totalCostTime_nonadapt(:,:,1), 2));
                bestVal = bestVal_flex_nonadapt;
            elseif s == 2
                totalCost = squeeze(sum(totalCostTime_adapt(:,:,1), 2));
                bestVal = bestVal_flex_adapt;
            end
        elseif type ==3 % flexible planned dam
            if s == 1
                totalCost = squeeze(sum(totalCostTime_nonadapt(:,:,3), 2));
                bestVal = bestVal_plan_nonadapt;
            elseif s == 2
                totalCost = squeeze(sum(totalCostTime_adapt(:,:,3), 2));
                bestVal = bestVal_plan_adapt;
            end
        end
        %k = sqrt(height(totalCost_static));
        
        % histogram for static dams
        subplot(3,2,2*(type-1)+s)
        hist_static = histogram(totalCost(:)/1E6,'FaceColor',facecolors{2*(type-1)+s},...
            'DisplayName','Histogram');
        xlim([50,600])
        xlabel('Total Cost (M$)')
        ylabel('Frequency')
        hold on
        if s == 1
            xline(bestVal/1E6,'DisplayName',strcat('SDP Best Value ($',...
                num2str(bestVal/1E6),' M)'),'LineWidth',1,'Color','r');
            hold on
            xline(mean(totalCost(:)/1E6),'DisplayName',strcat('Mean Total Cost ($',...
                num2str(mean(totalCost(:)/1E6)),' M)'),'Color','b','LineWidth',1,'LineStyle','--')
            hold on
            xline(median(totalCost(:)/1E6),'DisplayName',strcat('Median Total Cost ($',...
                num2str(median(totalCost(:)/1E6)),' M)'),'Color','b','LineWidth',1)
            title({strcat("Non-Adaptive Static Dam: ",num2str(bestAct_nonadapt(3))," MCM")});
        elseif s == 2
            xline(bestVal/1E6,'DisplayName',strcat('SDP Best Value ($',...
                num2str(bestVal/1E6),' M)'),'LineWidth',1, 'Color','r');
            hold on
            xline(mean(totalCost(:)/1E6),'DisplayName',...
                strcat('Mean Total Cost ($',num2str(mean(totalCost(:)/1E6)),' M)'),...
                'Color','b','LineWidth',1,'LineStyle','--')
            hold on
            xline(median(totalCost(:)/1E6),'DisplayName',strcat('Median Total Cost ($',...
                num2str(median(totalCost(:)/1E6)),' M)'),'Color','b','LineWidth',1)
            title({strcat("Adaptive Static Dam: ",num2str(bestAct_adapt(3))," MCM")});
        end
        legend()
        
    end
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

%% Combined CDF of Total Costs (Zoom into 10,50,90th percentiles)


facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",...
    [255, 102, 102]/255,[255, 153, 153]/255};

f = figure
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
c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 2;
c1.Color = facecolors{1};
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 2;
%c2.Color = facecolors{2};
c2.Color = facecolors{1};
c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 2;
c3.Color = facecolors{3};
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 1.5;
%c4.Color = facecolors{4};
c4.Color = facecolors{3};
c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 1.5;
c5.Color = facecolors{5};
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 1.5;
%c6.Color = facecolors{6};
c6.Color = facecolors{5};
c6.LineStyle = '--';

xlabel([])
legend(strcat('Static Dam (',num2str(bestAct_nonadapt(2))," MCM)"),...
    strcat('Flexible Ops & Static Design(',num2str(bestAct_adapt(2))," MCM)"),...
    strcat('Static Ops & Flexible Design(',num2str(bestAct_nonadapt(3)),"-",...
    num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Flexible Ops & Flexible Design(',num2str(bestAct_adapt(3)),"-",...
    num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
    strcat('Static Ops & Flexible Planning(',num2str(bestAct_nonadapt(8)),"-",...
    num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
    strcat('Flexible Ops & Flexible Planning (',num2str(bestAct_adapt(8)),"-",...
    num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)"), 'Location','southeast')
legend('boxoff')
xlabel('Cost [M$]')
xlim([0,1000])

ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'off';
box on

font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
legend('FontSize',12, 'Location','northeast')
title('CDF of Simulated Total Cost','FontSize',14)

figure_width = 20;
figure_height = 10;

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

filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/cdf.jpg'];
exportgraphics(f,filename1,'Resolution',1200)

%close

% === (2) PERCENTILE COSTS ====
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

f = figure;
percentiles = [0 40 95; 30 60 100];

for i = 1:3
    ptile = percentiles(2,i)
    
subplot(1,3,i)
c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 2;
c1.Color = facecolors(1,:);
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 2;
%c2.Color = facecolors{2};
c2.Color = facecolors(1,:);
c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 2;
c3.Color = facecolors(3,:);
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 1.5;
%c4.Color = facecolors{4};
c4.Color = facecolors(3,:);
c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 1.5;
c5.Color = facecolors(5,:);
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 1.5;
%c6.Color = facecolors{6};
c6.Color = facecolors(5,:);
c6.LineStyle = '--';

xlabel('Cost [M$]')
ylabel('Total Cost ($M)')
ylim([percentiles(1,i), percentiles(2,i)]/100)
xlim([prctile(totalCostStatic_nonadapt/1E6, percentiles(1,i)),...
    prctile(totalCostStatic_nonadapt/1E6, percentiles(2,i))])
title(strcat("Truncated CDF: ",string(mean(percentiles(:,i))),"th Percentile Costs"),'FontSize',14)
box on
grid off

font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)

end

filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/percentile.jpg'];
exportgraphics(f,filename2,'Resolution',1200)

%close

% combine figures
fcomb = figure;
out = imtile({filename1, filename2},'BorderSize', 50,'BackgroundColor', 'white','GridSize',[2,1]);
imshow(out);
title({'Simulated Total Costs vs. Dam Alternatives'},'FontSize',12)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/Costs_CDF_g7_percFlex75_percExp15.jpg'];
exportgraphics(fcomb,filename,'Resolution',1200);

%% CDF of Total Costs - zoomed in for 95 to 100th percentile

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

f = figure;
percentiles = [95;100];

for i = 1
ptile = percentiles(2,i)
    

c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 2;
c1.Color = facecolors(1,:);
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 2;
%c2.Color = facecolors{2};
c2.Color = facecolors(1,:);
c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 2;
c3.Color = facecolors(3,:);
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 1.5;
%c4.Color = facecolors{4};
c4.Color = facecolors(3,:);
c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 1.5;
c5.Color = facecolors(5,:);
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 1.5;
%c6.Color = facecolors{6};
c6.Color = facecolors(5,:);
c6.LineStyle = '--';

xlabel('Cost [M$]')
ylabel('Total Cost ($M)')
ylim([percentiles(1,i), percentiles(2,i)]/100)
xlim([prctile(totalCostStatic_nonadapt/1E6, percentiles(1,i)),...
    prctile(totalCostStatic_nonadapt/1E6, percentiles(2,i))])
title(strcat("Truncated CDF: ",string(mean(percentiles(:,i))),"th Percentile Costs"),'FontSize',14)
box on
grid off
%xlim([150,1800])

font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
end

%% Combined CDF of Total Costs (Bars for percentiles)

facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",...
    [255, 102, 102]/255,[255, 153, 153]/255};

f = figure;
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
c1 = cdfplot(totalCostStatic_nonadapt/1E6);
c1.LineWidth = 2;
c1.Color = facecolors{1};
hold on
c2 = cdfplot(totalCostStatic_adapt/1E6);
c2.LineWidth = 2;
%c2.Color = facecolors{2};
c2.Color = facecolors{1};
c2.LineStyle = '--';
hold on
c3 = cdfplot(totalCostFlex_nonadapt/1E6);
c3.LineWidth = 2;
c3.Color = facecolors{3};
hold on
c4 = cdfplot(totalCostFlex_adapt/1E6);
c4.LineWidth = 1.5;
%c4.Color = facecolors{4};
c4.Color = facecolors{3};
c4.LineStyle = '--';
hold on
c5 = cdfplot(totalCostPlan_nonadapt/1E6);
c5.LineWidth = 1.5;
c5.Color = facecolors{5};
hold on
c6 = cdfplot(totalCostPlan_adapt/1E6);
c6.LineWidth = 1.5;
%c6.Color = facecolors{6};
c6.Color = facecolors{5};
c6.LineStyle = '--';

xlabel([])
legend(strcat('Static Dam (',num2str(bestAct_nonadapt(2))," MCM)"),...
    strcat('Flexible Ops & Static Design(',num2str(bestAct_adapt(2))," MCM)"),...
    strcat('Static Ops & Flexible Design(',num2str(bestAct_nonadapt(3)),"-",...
    num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
    strcat('Flexible Ops & Flexible Design(',num2str(bestAct_adapt(3)),"-",...
    num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
    strcat('Static Ops & Flexible Planning(',num2str(bestAct_nonadapt(8)),"-",...
    num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
    strcat('Flexible Ops & Flexible Planning (',num2str(bestAct_adapt(8)),"-",...
    num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)"), 'Location','southeast')
legend('boxoff')
xlabel('Cost [M$]')

ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'off';
box on

font_size = 12;
allaxes = findall(f, 'type', 'axes');
set(allaxes,'FontSize', font_size)
set(findall(allaxes,'type','text'),'FontSize', font_size)
legend('FontSize',12, 'Location','northeast')
title('CDF of Simulated Total Cost','FontSize',14)

figure_width = 20;
figure_height = 10;

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

filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/cdf.jpg'];
exportgraphics(f,filename1,'Resolution',1200)

close

% === (2) PERCENTILE COSTS ====
facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

% 95th, 50th, and 10th percentile costs
p90_nonadapt = prctile(totalCost_nonadapt(:,1:3),90)/1E6;
p50_nonadapt = prctile(totalCost_nonadapt(:,1:3),50)/1E6;
p10_nonadapt = prctile(totalCost_nonadapt(:,1:3),10)/1E6;

p90_adapt = prctile(totalCost_adapt(:,1:3),90)/1E6;
p50_adapt = prctile(totalCost_adapt(:,1:3),50)/1E6;
p10_adapt = prctile(totalCost_adapt(:,1:3),10)/1E6;

f = figure;

subplot(1,3,1)
bar_val = [p10_nonadapt(2); p10_adapt(2); p10_nonadapt(1); p10_adapt(1); p10_nonadapt(3); p10_adapt(3)];
for i = 1:6
    b = bar(i, bar_val(i),'facecolor', 'flat');
    b.CData = facecolors(i,:);
    hold on
end
ylabel('Total Cost ($M)')
xlabel('Dam Alternative')
set(gca,'XTick',[])
title('10th Percentile Total Costs')
ylim([0,350])

subplot(1,3,2)
bar_val = [p50_nonadapt(2); p50_adapt(2); p50_nonadapt(1); p50_adapt(1); p50_nonadapt(3); p50_adapt(3)];
for i = 1:6
    b = bar(i, bar_val(i),'facecolor', 'flat');
    b.CData = facecolors(i,:);
    hold on
end
xlabel('Dam Alternative')
ylabel('Total Cost ($M)')
set(gca,'XTick',[])
title('50th Percentile Total Costs')
ylim([0,350])


subplot(1,3,3)
bar_val = [p90_nonadapt(2) p90_adapt(2) p90_nonadapt(1) p90_adapt(1) p90_nonadapt(3) p90_adapt(3)];
for i = 1:6
    b = bar(i, bar_val(i),'facecolor', 'flat');
    b.CData = facecolors(i,:);
    hold on
end
ylabel('Total Cost ($M)')
xlabel('Dam Alternative')
set(gca,'XTick',[])
title('90th Percentile Total Costs')
ylim([0,350])


sgtitle('Percentiles of Simulated Total Cost','FontSize',14,'FontWeight','bold')

figure_width = 20;
figure_height = 10;

% DERIVED PROPERTIES (cannot be changed; for info only)
screen_ppi = 72;
screen_figure_width = round(figure_width*screen_ppi); % in pixels
screen_figure_height = round(figure_height*screen_ppi); % in pixels

% SET UP FIGURE SIZE
set(f, 'Position', [100, 100, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(f, 'OuterPosition', [100, 150, round(figure_width*screen_ppi), round(figure_height*screen_ppi)]);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);


% hL = legend({strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
%     strcat("Static Ops & Flexible\newlineDesign(",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
%     string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
%     ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
%     strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
%     string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 10);

hL = legend({strcat("Static Dam\newline(",string(bestAct_nonadapt(2)),"MCM)"),strcat("Flexible Ops & Static\newlineDesign (",string(bestAct_adapt(2)),"MCM)"),...
    strcat("Static Ops & Flexible\newlineDesign(",string(bestAct_nonadapt(3)),"-",string(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlineDesign (", string(bestAct_adapt(3)),"-",...
    string(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5)),"MCM)"),strcat("Static Ops & Flexible\newlinePlanning ("...
    ,string(bestAct_nonadapt(8)),"-",string(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),"MCM)"),...
    strcat("Flexible Ops & Flexible\newlinePlanning (",string(bestAct_adapt(8)),"-",...
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9);


% Programatically move the Legend
newPosition = [0.4 0.03 0.2 0];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);

filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/percentile.jpg'];
exportgraphics(f,filename2,'Resolution',1200)

close

% combine figures
fcomb = figure;
out = imtile({filename1, filename2},'BorderSize', 50,'BackgroundColor', 'white','GridSize',[2,1]);
imshow(out);
title({'Simulated Total Costs vs. Dam Alternatives'},'FontSize',12)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/Costs_CDF_g7_percFlex75_percExp15.jpg'];
exportgraphics(fcomb,filename,'Resolution',1200);


%% Distribution of costs: total dam cost time vs. total cost

bestOption = 0;

%facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",[255, 102, 102]/255,[255, 153, 153]/255};
facecolors = {[124,152,179]/255,[150,189,217]/255}

%P_regret = [68 78 88];
P_regret = [72 79 87];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_adapt = squeeze(sum(damCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_nonadapt = squeeze(sum(damCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
% damCost_adapt_plan = squeeze(sum(damCostTime_adapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static
% damCost_nonadapt_plan = squeeze(sum(damCostTime_nonadapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static

% preallocate matrices
meanCostPnow_adapt = zeros(length(P_regret),3);
meanCostPnow_nonadapt = zeros(length(P_regret),3);
meanDamCostPnow_adapt = zeros(length(P_regret),3);
meanDamCostPnow_nonadapt = zeros(length(P_regret),3);
% meanDamCostPnow_adapt_plan = zeros(length(P_regret),3);
% meanDamCostPnow_nonadapt_plan = zeros(length(P_regret),3);


for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    
    % Get average cost of each infra option in that P level
    damCostPnow_adapt = damCost_adapt(ind_P_adapt,:);
    damCostPnow_nonadapt = damCost_nonadapt(ind_P_nonadapt,:);
    
    % total shortage costs
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:)-damCostPnow_adapt;
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:)-damCostPnow_nonadapt;
   
    % mean shortage costs
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
    meanCostPnow = [[meanDamCostPnow_nonadapt(f,2) meanDamCostPnow_nonadapt(f,1) meanDamCostPnow_nonadapt(f,3),...
        meanDamCostPnow_adapt(f,2), meanDamCostPnow_adapt(f,1), meanDamCostPnow_adapt(f,3)];...
        [meanCostPnow_nonadapt(f,2),meanCostPnow_nonadapt(f,1),meanCostPnow_nonadapt(f,3),...
        meanCostPnow_adapt(f,2), meanCostPnow_adapt(f,1),meanCostPnow_adapt(f,3)]]';
    
    b = bar([meanCostPnow]/1E6,'stacked')
    for i=1:length(b)
        b(i).FaceColor = facecolors{i};
    end
    
    
    %xlim([.5 6.5])
    
    ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+100]);
    xticklabels({strcat('Static Dam\newline(',num2str(bestAct_nonadapt(2))," MCM)"),...
        strcat('Static Ops. &\newlineFlexible Design\newline(',num2str(bestAct_nonadapt(3)),"-",num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
        strcat('Static Ops &\newlineFlexible Planning\newline(',num2str(bestAct_nonadapt(8)),"-",num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
        strcat('Adaptive Ops &\newlineStatic Design\newline(',num2str(bestAct_adapt(2))," MCM)"),...
        strcat('Adaptive Ops &\newlineFlexible Design\newline(',num2str(bestAct_adapt(3)),"-",...
        num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
        strcat('Adaptive Ops &\newlineFlexible Planning\newline(',num2str(bestAct_adapt(8)),"-",...
        num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)")});
    xlim([0.5,6.5]);
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

%%
%% VERTICAL: Distribution of costs: total dam cost time vs. total cost
plot_this = 0;

if plot_this == 1

bestOption = 0;

%facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",[255, 102, 102]/255,[255, 153, 153]/255};
facecolors = {[124,152,179]/255,[150,189,217]/255}

%P_regret = [68 78 88];
P_regret = [72 79 87];
totalCost_adapt = squeeze(sum(totalCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(sum(totalCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_adapt = squeeze(sum(damCostTime_adapt(:,:,1:3), 2));% 1 is flex, 2 is static
damCost_nonadapt = squeeze(sum(damCostTime_nonadapt(:,:,1:3), 2));% 1 is flex, 2 is static
% damCost_adapt_plan = squeeze(sum(damCostTime_adapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static
% damCost_nonadapt_plan = squeeze(sum(damCostTime_nonadapt_plan(:,:,1:2), 2));% 1 is flex, 2 is static

% preallocate matrices
meanCostPnow_adapt = zeros(length(P_regret),3);
meanCostPnow_nonadapt = zeros(length(P_regret),3);
meanDamCostPnow_adapt = zeros(length(P_regret),3);
meanDamCostPnow_nonadapt = zeros(length(P_regret),3);
% meanDamCostPnow_adapt_plan = zeros(length(P_regret),3);
% meanDamCostPnow_nonadapt_plan = zeros(length(P_regret),3);


for i = 1:length(P_regret)
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    
    % Get average cost of each infra option in that P level
    damCostPnow_adapt = damCost_adapt(ind_P_adapt,:);
    damCostPnow_nonadapt = damCost_nonadapt(ind_P_nonadapt,:);
    damCostPnow_adapt_plan = damCost_adapt_plan(ind_P_adapt,:);
    damCostPnow_nonadapt_plan = damCost_nonadapt_plan(ind_P_nonadapt,:);
    
    % total shortage costs
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:)-damCostPnow_adapt;
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:)-damCostPnow_nonadapt;
    totalCostPnow_adapt_plan = totalCost_adapt_plan(ind_P_adapt,:)-damCostPnow_adapt_plan;
    totalCostPnow_nonadapt_plan = totalCost_nonadapt_plan(ind_P_nonadapt,:)-damCostPnow_nonadapt_plan;
    
    % mean shortage costs
    meanCostPnow_adapt(i,:) = mean(totalCostPnow_adapt,1);
    meanCostPnow_nonadapt(i,:) = mean(totalCostPnow_nonadapt,1);
%     meanCostPnow_adapt_plan(i,:) = mean(totalCostPnow_adapt_plan,1);
%     meanCostPnow_nonadapt_plan(i,:) = mean(totalCostPnow_nonadapt_plan,1);
    
    meanDamCostPnow_adapt(i,:) = mean(damCostPnow_adapt,1);
    meanDamCostPnow_nonadapt(i,:) = mean(damCostPnow_nonadapt,1);
%     meanDamCostPnow_adapt_plan(i,:) = mean(damCostPnow_adapt_plan,1);
%     meanDamCostPnow_nonadapt_plan(i,:) = mean(damCostPnow_nonadapt_plan,1);
end

% matrix rows: 67, 78, 88 mm/mo.
% reshaped matrix columns: nonadaptive static, nonadaptive flex, adaptive
% static, adaptive flex

figure
for f = 1:3
    subplot(1,3,f)
    meanCostPnow = [[meanDamCostPnow_nonadapt(f,2) meanDamCostPnow_nonadapt(f,1) meanDamCostPnow_nonadapt(f,3),...
        meanDamCostPnow_adapt(f,2), meanDamCostPnow_adapt(f,1), meanDamCostPnow_adapt(f,3)];...
        [meanCostPnow_nonadapt(f,2),meanCostPnow_nonadapt(f,1),meanCostPnow_nonadapt(f,3),...
        meanCostPnow_adapt(f,2), meanCostPnow_adapt(f,1),meanCostPnow_adapt(f,3)]]';
    
    b = bar([meanCostPnow]/1E6,'stacked')
    for i=1:length(b)
        b(i).FaceColor = facecolors{i};
    end
    
    
    %xlim([.5 6.5])
    
    ylim([0 ceil(max(meanCostPnow/1E6,[],'all'))+100]);
    xticklabels({strcat('Static Dam\newline(',num2str(bestAct_nonadapt(2))," MCM)"),...
        strcat('Static Ops. &\newlineFlexible Design\newline(',num2str(bestAct_nonadapt(3)),"-",num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM)"),...
        strcat('Static Ops &\newlineFlexible Planning\newline(',num2str(bestAct_nonadapt(8)),"-",num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM)"),...
        strcat('Adaptive Ops &\newlineStatic Design\newline(',num2str(bestAct_adapt(2))," MCM)"),...
        strcat('Adaptive Ops &\newlineFlexible Design\newline(',num2str(bestAct_adapt(3)),"-",...
        num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM)"),...
        strcat('Adaptive Ops &\newlineFlexible Planning\newline(',num2str(bestAct_adapt(8)),"-",...
        num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM)")});
    yl = ylabel('M$','FontWeight','bold');
    if f == 3
        xl = xlabel('Infrastructure Alternative','FontWeight','bold')
        xl.Position = xl.Position - [ 0 4 0];
    end
    ylabel('M$');
    title(strcat("P in 2090: ",num2str(P_regret(f))," mm/month"));
    if f==3
        legend('Total Infrastructure Cost','Total Expected Shortage Costs')
    end
end

sgtitle('Cost Breakdown for Infrastructure Alternatives by 2090 P','FontSize',14,'FontWeight','bold')

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

end

%% Time series of decisions: starting with flex option in first time period (from forward simulations)

%P_sample = [68 78 88];
P_sample = [72 79 87];
decade_short = {'2001-20', '2021-40', '2041-60', '2061-80', '2081-00'};

%expansion_colors = [[99,112,129];[65,132,180];[150,189,217];[124,152,179];[223,238,246]]/255;


nonadapt_plan_colors = [[255,102,102];[255,153,153];[255,214,214];[255,255,255];[224,224,224]]/255;
nonadapt_flex_colors = [[153,153,204];[213,213,255];[234,234,255];[238,184,192];[255,255,255];[224,224,224]]/255;

adapt_plan_colors = [[255,153,153];[255,204,204];[255,243,243];[255,255,255];[224,224,224]]/255;
adapt_flex_colors = [[204,204,255];[230,230,255];[243,243,255];[235,255,255];[255,255,255];[224,224,224]]/255;


for s=1:2 % for each non-adadaptive vs adaptive operations
    
    f = figure;
    
    for z=1:2 %flex design, flex planning
        
        for p = 1:length(P_sample) % for each desired final precipiation state
            
            if z == 1
                % load the appropriate data
                if s == 1
                    P_state = P_state_nonadapt;
                    C_state = C_nonadapt(:,:,z);
                    bestAct = bestAct_nonadapt;
                else
                    P_state = P_state_adapt;
                    C_state = C_adapt(:,:,z);
                    bestAct = bestAct_adapt;
                end
        elseif z==2 % Flexible Planning
            
            if s == 1
                P_state = P_state_nonadapt;
                C_state = C_nonadapt(:,:,3);
                bestAct = bestAct_nonadapt;
            else
                P_state = P_state_adapt;
                C_state = C_adapt(:,:,3);
                bestAct = bestAct_adapt;
            end
            end
        
        s_C_sized = zeros(1,3+bestAct(4)+bestAct(9));
        if z == 1 % flex design
            s_C = [bestAct(3):bestAct(5):bestAct(3)+bestAct(4)*bestAct(5)];
            s_C_sized(1, 2) = bestAct(3);
            s_C_sized(1, 4:3+bestAct(4)) = s_C(2:end);
            s_C_bins = [bestAct(3):bestAct(5):bestAct(3)+bestAct(4)*bestAct(5)]-0.1;
        else
            s_C = [bestAct(8):bestAct(10):bestAct(8)+bestAct(9)*bestAct(10)];
            s_C_sized(1, 3) = bestAct(8);
            s_C_sized(1, 4+bestAct(4):end) = s_C(2:end);
            s_C_bins = [bestAct(8):bestAct(10):bestAct(8)+bestAct(9)*bestAct(10)]-0.1;
        end
        s_C_bins(end+1) = s_C(end)+0.1;
        
        % Find simulations with this level of precip at the end of the
        % time period
        [indP_rows, ~] = find(P_state(:,end) == P_sample(p));
        C_state_Pnow = C_state(indP_rows,:);
        
        %C_Pnow = capacities(C_state_Pnow);
        C_Pnow = s_C_sized(C_state_Pnow);
        
        %subplot(3,2,(z-1)*s+s)
        subplot(2,3,(z-1)*3+p)
        
        
        clear cPnowCounts cPnowCounts_test
        
        for k=1:5
            for i = 1:length(s_C)-1
                cPnowCounts(k,i) = sum(C_Pnow(:,k)==s_C(i+1));
            end
            cPnowCounts_test(k,:) = histcounts(C_Pnow(:,k), s_C_bins);
        end
        
        if s == 1
            if z== 1 % flex design
                cmap = nonadapt_flex_colors(1:bestAct(4)+1,:);
            else % flex planning
                cmap = nonadapt_plan_colors(1:bestAct(9)+1,:);
            end
        elseif s==2
            if z==1
                cmap = adapt_flex_colors(1:bestAct(4)+1,:);
            else
                cmap = adapt_plan_colors(1:bestAct(9)+1,:);
            end
        end
        
        %cmap = expansion_colors(1:bestAct(4)+1,:);
        
        colormap(cmap);
            b1 = bar(cPnowCounts_test, 'stacked');
            for i=1:length(b1)
                b1(i).FaceColor = cmap(i,:);
            end
            xticklabels(decade_short);
            xlim([0.5,5.5])
            
            xlabel('Time Period');
            ylabel('Frequency');
            ylim([0,sum(cPnowCounts_test(1,:))])
            
            if p==3
                if z==1 % flexible
                    for n = 1:bestAct(4)
                        flexExp_labels(n) = {strcat("Flex Design, Exp:", num2str(bestAct(3)+n*bestAct(5)),"MCM")};
                    end
                    capState = {strcat('Flex Design, Unexpanded:',num2str(bestAct(3))),...
                        flexExp_labels{:}};
                    l = legend(capState,'Location',"northwest",'FontSize', 9);
                    %l.Position == l.Position + [-0.15 -0.15 0 0.05];
                else
                    for n = 1:bestAct(9)
                        flexExp_labels(n) = {strcat("Flex Plan, Exp:", num2str(bestAct(8)+n*bestAct(10)),"MCM")};
                    end
                    capState = {strcat('Flex Plan, Unexpanded:',num2str(bestAct(8))),...
                        flexExp_labels{:}};
                    l = legend(capState,'Location',"northwest",'FontSize', 9);
                end
            end
            box
            
            ax = gca;
            ax.XGrid = 'off';
            ax.YGrid = 'off';
            box
            allaxes = findall(f, 'type', 'axes');
            set(allaxes,'FontSize', 10)
            set(findall(allaxes,'type','text'),'FontSize', 10);
            title('Infrastructure Decisions','FontSize',12)
            
            
            
            title({"Final Precipitation State:";strcat(string(P_sample(p))," mm/month")})
            
        end
        if s==1
            sgtitle({'Static Operations';strcat("Flexible Dam Design = ", num2str(bestAct_nonadapt(3)),"-",...
                num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM & Flexible Dam Plan = ",...
                num2str(bestAct_nonadapt(8)),"-",num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10)),...
                " MCM")},'FontWeight','bold');
        else
            sgtitle({'Flexible Operations';strcat("Flexible Dam Design = ", num2str(bestAct_adapt(3)),"-",...
                num2str(bestAct_adapt(3)+bestAct_adapt(4)*bestAct_adapt(5))," MCM & Flexible Dam Plan = ",...
                num2str(bestAct_adapt(8)),"-",num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),...
                " MCM")},'FontWeight','bold');
        end

    end
    
    figure_width = 45;
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
    
    % save figure
    if s == 1
        filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/nonadaptive_fsimPstate.jpg'];
        %saveas(f, filename1)
        exportgraphics(f,filename1,'Resolution',1200)
    elseif s == 2
        filename2 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/adaptive_fsimPstate.jpg'];
        %saveas(f, filename2)
        exportgraphics(f,filename2,'Resolution',1200)
    end
    close
end



% stack figures
fcomb = figure;
out = imtile({filename1; filename2},'GridSize',[2 NaN],'BorderSize', 50,'BackgroundColor', 'white');
imshow(out);
title({'Simulated Infrastructure Expansion Decisions'},'FontSize',15)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/fsimPstate_g7_percFlex5_percExp15.jpg'];
saveas(fcomb, filename)
exportgraphics(fcomb,filename,'Resolution',1200);

%% Plot most common forward realization time series of capcaity for different climate states

facecolors = [[153,204,204]; [204,255,255]; [153, 153, 204]; [204, 204, 255];...
    [255, 102, 102]; [255, 153, 153]]/255;

P_regret = [72 79 87];

s_C_adapt = [bestAct_adapt(2) bestAct_adapt(3), bestAct_adapt(8) (bestAct_adapt(3)+[1:bestAct_adapt(4)]*bestAct_adapt(5)),...
    (bestAct_adapt(8)+[1:bestAct_adapt(9)]*bestAct_adapt(10))];

s_C_nonadapt = [bestAct_nonadapt(2) bestAct_nonadapt(3), bestAct_nonadapt(8) (bestAct_nonadapt(3)+[1:bestAct_nonadapt(4)]*bestAct_nonadapt(5)),...
    (bestAct_nonadapt(8)+[1:bestAct_nonadapt(9)]*bestAct_adapt(10))];

f = figure;
for p = 1:length(P_regret) % for each transition to drier or wetter climate
    
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(p));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(p));
    
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
    modeIdx = mode(uIdx);
    modeRowPlan_adapt(1,:) = uA(modeIdx,:); %# the first output argument
    for ia = 2:length(modeRowPlan_adapt)
        if modeRowPlan_adapt(1,ia) == 0
            modeRowPlan_adapt(1,ia) = modeRowPlan_adapt(1,ia-1);
        end
    end

    [uA,~,uIdx] = unique(ActionPnow_nonadapt(:,:,2),'rows');
    modeIdx = mode(uIdx);
    modeRowPlan_nonadapt(1,:) = uA(modeIdx,:); %# the first output argument
    for ia = 2:length(modeRowPlan_nonadapt)
        if modeRowPlan_nonadapt(1,ia) == 0
            modeRowPlan_nonadapt(1,ia) = modeRowPlan_nonadapt(1,ia-1);
        end
    end    
    
    subplot(1,3,p)
    modeRows_comb = [modeRowStatic_nonadapt; modeRowStatic_adapt; ...
        s_C_nonadapt(modeRowFlex_nonadapt); s_C_adapt(modeRowFlex_adapt);...
        s_C_nonadapt(modeRowPlan_nonadapt); s_C_adapt(modeRowPlan_adapt)];
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

%% Time series of moving average of total costs

%P_regret = [68 78 88];
P_regret = [72 79 87];
facecolors = {[153,204,204]/255,[204,255,255]/255,"#9999cc","#ccccff",...
    [255, 102, 102]/255,[255, 153, 153]/255};

totalCost_adapt = squeeze(cumsum(totalCostTime_adapt(:,:,1:3), 2))/1E6;% 1 is flex, 2 is static
totalCost_nonadapt = squeeze(cumsum(totalCostTime_nonadapt(:,:,1:3), 2))/1E6;% 1 is flex, 2 is static
% totalCost_adapt_plan = squeeze(cumsum(totalCostTime_adapt_plan(:,:,1:2), 2))/1E6;% 1 is flex, 2 is static
% totalCost_nonadapt_plan = squeeze(cumsum(totalCostTime_nonadapt_plan(:,:,1:2), 2))/1E6;% 1 is flex, 2 is static
damCost_adapt = squeeze(cumsum(damCostTime_adapt(:,:,1:3), 2))/1E6;% 1 is flex, 2 is static
damCost_nonadapt = squeeze(cumsum(damCostTime_nonadapt(:,:,1:3), 2))/1E6;% 1 is flex, 2 is static
% damCost_adapt_plan = squeeze(cumsum(damCostTime_adapt_plan(:,:,1:2), 2))/1E6;% 1 is flex, 2 is static
% damCost_nonadapt_plan = squeeze(cumsum(damCostTime_nonadapt_plan(:,:,1:2), 2))/1E6;% 1 is flex, 2 is static

% preallocate matrices
meanCostPnow_adapt = zeros(length(P_regret),5,3);
meanCostPnow_nonadapt = zeros(length(P_regret),5,3);
% meanCostPnow_adapt_plan = zeros(length(P_regret),5,2);
% meanCostPnow_nonadapt_plan = zeros(length(P_regret),5,2);
meanDamCostPnow_adapt = zeros(length(P_regret),5,3);
meanDamCostPnow_nonadapt = zeros(length(P_regret),5,3);
% meanDamCostPnow_adapt_plan = zeros(length(P_regret),5,2);
% meanDamCostPnow_nonadapt_plan = zeros(length(P_regret),5,2);

% % interval of shortage costs:
% UB_totalCost = zeros(length(P_regret),5,3);
% LB_totalCost = zeros(length(P_regret),5,3);
% 
% % interval of dam costs:
% UB_damCost = zeros(length(P_regret),5,3);
% LB_damCost = zeros(length(P_regret),5,3);

for i = 1:length(P_regret)
    
    % Find simulations with this level of precip
    ind_P_adapt = (P_state_adapt(:,end) == P_regret(i));
    ind_P_nonadapt = (P_state_nonadapt(:,end) == P_regret(i));
    
    % Get average cost of each infra option in that P level
    damCostPnow_adapt = damCost_adapt(ind_P_adapt,:,:);
    damCostPnow_nonadapt = damCost_nonadapt(ind_P_nonadapt,:,:);
%     damCostPnow_adapt_plan = damCost_adapt_plan(ind_P_adapt,:,:);
%     damCostPnow_nonadapt_plan = damCost_nonadapt_plan(ind_P_nonadapt,:,:);
    
    % total shortage costs
    totalCostPnow_adapt = totalCost_adapt(ind_P_adapt,:,:)-damCostPnow_adapt;
    totalCostPnow_nonadapt = totalCost_nonadapt(ind_P_nonadapt,:,:)-damCostPnow_nonadapt;
%     totalCostPnow_adapt_plan = totalCost_adapt_plan(ind_P_adapt,:,:)-damCostPnow_adapt_plan;
%     totalCostPnow_nonadapt_plan = totalCost_nonadapt_plan(ind_P_nonadapt,:,:)-damCostPnow_nonadapt_plan;
%     
    % mean shortage costs
    meanCostPnow_adapt(i,:,:) = mean(totalCostPnow_adapt,1);
    meanCostPnow_nonadapt(i,:,:) = mean(totalCostPnow_nonadapt,1);
%     meanCostPnow_adapt_plan(i,:,:) = mean(totalCostPnow_adapt_plan,1);
%     meanCostPnow_nonadapt_plan(i,:,:) = mean(totalCostPnow_nonadapt_plan,1);
    
    meanDamCostPnow_adapt(i,:,:) = mean(damCostPnow_adapt,1);
    meanDamCostPnow_nonadapt(i,:,:) = mean(damCostPnow_nonadapt,1);
%     meanDamCostPnow_adapt_plan(i,:,:) = mean(damCostPnow_adapt_plan,1);
%     meanDamCostPnow_nonadapt_plan(i,:,:) = mean(damCostPnow_nonadapt_plan,1);
    
%     UB_totalCost_adapt(i,:,:) = prctile(totalCostPnow_adapt,100);
%     LB_totalCost_adapt(i,:,:) = prctile(totalCostPnow_adapt,0);
%     UB_totalCost_nonadapt(i,:,:) = prctile(totalCostPnow_nonadapt,100);
%     LB_totalCost_nonadapt(i,:,:) = prctile(totalCostPnow_nonadapt,0);
%     UB_totalCost_nonadapt_plan(i,:,:) = prctile(totalCostPnow_nonadapt_plan,100);
%     LB_totalCost_nonadapt_plan(i,:,:) = prctile(totalCostPnow_nonadapt_plan,0);
%     UB_totalCost_adapt_plan(i,:,:) = prctile(totalCostPnow_adapt_plan,100);
%     LB_totalCost_adapt_plan(i,:,:) = prctile(totalCostPnow_adapt_plan,0);
    
    
%     UB_damCost_adapt(i,:,:) = prctile(damCostPnow_adapt,100);
%     LB_damCost_adapt(i,:,:) = prctile(damCostPnow_adapt,0);
%     UB_damCost_nonadapt(i,:,:) = prctile(damCostPnow_nonadapt,100);
%     LB_damCost_nonadapt(i,:,:) = prctile(damCostPnow_nonadapt,0);
%     UB_damCost_adapt_plan(i,:,:) = prctile(damCostPnow_adapt_plan,100);
%     LB_damCost_adapt_plan(i,:,:) = prctile(damCostPnow_adapt_plan,0);
%     UB_damCost_nonadapt_plan(i,:,:) = prctile(damCostPnow_nonadapt_plan,100);
%     LB_damCost_nonadapt_plan(i,:,:) = prctile(damCostPnow_nonadapt_plan,0);
end

f = figure

for i = 1:3
    subplot(2,3,i)
    for s = 1:6
        if s == 1 % non-adaptive static
            %inBetween = [LB_damCost_nonadapt(i,:,2) fliplr(UB_damCost_nonadapt(i,:,2))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            plot(1:5,meanDamCostPnow_nonadapt(i,:,2),'Color',facecolors{s},'LineWidth',1.5)
            hold on
        elseif s == 2 % adaptive static
            %inBetween = [LB_damCost_adapt(i,:,2) fliplr(UB_damCost_adapt(i,:,2))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            if i == 3
                plot(1:5,meanDamCostPnow_adapt(i,:,2),'Color',facecolors{s-1},'LineWidth',4, 'LineStyle','--')
            else
                plot(1:5,meanDamCostPnow_adapt(i,:,2),'Color',facecolors{s-1},'LineWidth',2, 'LineStyle','--')
            end
            hold on
        elseif s ==3 % non-adaptive flex design
            %inBetween = [LB_damCost_nonadapt(i,:,1) fliplr(UB_damCost_nonadapt(i,:,1))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            plot(1:5,meanDamCostPnow_nonadapt(i,:,1),'Color',facecolors{s},'LineWidth',1.5)
            hold on
        elseif s == 4 % adaptive flex design
            %inBetween = [LB_damCost_adapt(i,:,1) fliplr(UB_damCost_adapt(i,:,1))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            
            plot(1:5,meanDamCostPnow_adapt(i,:,1),'Color',facecolors{s-1},'LineWidth',2, 'LineStyle','--')
            
            hold on
        elseif s == 5
            %inBetween = [LB_damCost_nonadapt(i,:,3) fliplr(UB_damCost_nonadapt_plan(i,:,1))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            plot(1:5,meanDamCostPnow_nonadapt(i,:,3),'Color',facecolors{5},'LineWidth',1.5)
            hold on
        elseif s==6
            %inBetween = [LB_damCost_adapt(i,:,3) fliplr(UB_damCost_adapt_plan(i,:,1))];
            %fill([1:5, 5:-1:1], inBetween, 'g');
            plot(1:5,meanDamCostPnow_adapt(i,:,3),'Color',facecolors{5},'LineWidth',2, 'LineStyle','--')
            hold on
        end
    end
    

    box on
    xlim([1,5])
    xlabel('Time Period','FontWeight','bold')
    ylabel({'Mean Cumulative Infrastructure Cost';'[M$]'},'HorizontalAlignment','center')
    xticklabels(decade_short)
    if i == 2
        title({'Infrastructure Costs vs. Time';strcat("Moderate Final Precipitation State")},'FontWeight','bold','FontSize',12)
    elseif i == 1
        %title(strcat("P in 2019: ",num2str(P_regret(i))," mm/mo"),'FontWeight','bold','FontSize',14)
        title(strcat("Dry Final Precipitation State"),'FontWeight','bold','FontSize',12)
    else
        title(strcat("Wet Final Precipitation State"),'FontWeight','bold','FontSize',12)
    end
end

%legend('Static Dam','Static Ops &\newlineFlexible Design','Flexible Ops &\newlineStatic Design',...
%    'Flexible Ops &\newlineFlexible Design','Static Ops &\newlineFlexible Planning','Flexible Ops &\newlineFlexible Planning')

for i = 1:3
     subplot(2,3,3+i)
     for s = 1:6
         if s == 1 % non-adaptive static
%             inBetween = [LB_totalCost_nonadapt(i,:,2) fliplr(UB_totalCost_nonadapt(i,:,2))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on
             plot(1:5,meanCostPnow_nonadapt(i,:,2),'Color',facecolors{s},'LineWidth',1.5)
             hold on
         elseif s == 2 % adaptive static
%             inBetween = [LB_totalCost_adapt(i,:,2) fliplr(UB_totalCost_adapt(i,:,2))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on
             plot(1:5,meanCostPnow_adapt(i,:,2),'Color',facecolors{s-1},'LineWidth',2, 'LineStyle','--')
             hold on
         elseif s ==3 % non-adaptive flex design
%             inBetween = [LB_totalCost_nonadapt(i,:,1) fliplr(UB_totalCost_nonadapt(i,:,1))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on
             plot(1:5,meanCostPnow_nonadapt(i,:,1),'Color',facecolors{s},'LineWidth',1.5)
             hold on
         elseif s == 4 % adaptive flex design
%             inBetween = [LB_totalCost_adapt(i,:,1) fliplr(UB_totalCost_adapt(i,:,1))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on

            if i == 3
                plot(1:5,meanCostPnow_adapt(i,:,1),'Color',facecolors{s-1},'LineWidth',4, 'LineStyle','--')
            else
                plot(1:5,meanCostPnow_adapt(i,:,1),'Color',facecolors{s-1},'LineWidth',2, 'LineStyle','--')
            end
            
             %plot(1:5,meanCostPnow_adapt(i,:,1),'Color',facecolors{s-1},'LineWidth',2, 'LineStyle','--')
             hold on
         elseif s == 5
%             inBetween = [LB_totalCost_nonadapt_plan(i,:,1) fliplr(UB_totalCost_nonadapt_plan(i,:,1))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on
             plot(1:5,meanCostPnow_nonadapt(i,:,3),'Color',facecolors{5},'LineWidth',1.5)
             hold on
         elseif s==6
%             inBetween = [LB_totalCost_adapt_plan(i,:,1) fliplr(UB_totalCost_adapt_plan(i,:,1))];
%             %fill([1:5, 5:-1:1], inBetween, 'g');
%             hold on
             plot(1:5,meanCostPnow_adapt(i,:,3),'Color',facecolors{5},'LineWidth',2, 'LineStyle','--')
             hold on
         end
    end
    box on
    xlim([1,5])
    xlabel('Time Period\newline \newline \newline \newline', 'FontWeight','bold')
    ylabel({'Mean Cumulative Infrastructure Cost';'[M$]'},'HorizontalAlignment','center')
    xticklabels(decade_short)
    if i == 2
        title({'Shortage Costs vs. Time';strcat("Moderate Final Precipitation State")},'FontWeight','bold','FontSize',12)
    elseif i == 1
        %title(strcat("P in 2019: ",num2str(P_regret(i))," mm/mo"),'FontWeight','bold','FontSize',14)
        title(strcat("Dry Final Precipitation State"),'FontWeight','bold','FontSize',12)
    else
        title(strcat("Wet Final Precipitation State"),'FontWeight','bold','FontSize',12)
    end
end


figure_width = 25;
figure_height = 10;

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
    string(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10)),"MCM)")},'Orientation','horizontal', 'FontSize', 9)

% Programatically move the Legend
newPosition = [0.4 0.05 0.2 0];
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);

sgtitle({'Expected Costs vs. Time for Different Infrastructure Alternatives'},'FontWeight','bold');

% sgtitle({'Expected Costs vs. Time for Different Infrastructure Alternatives';...
%     strcat('Static Operations: Static Dam = ',...
%     num2str(bestAct_nonadapt(2))," MCM , Flexible Design Dam = ", num2str(bestAct_nonadapt(3)),"-",...
%     num2str(bestAct_nonadapt(3)+bestAct_nonadapt(4)*bestAct_nonadapt(5))," MCM , Flexible Planned Dam = ",...
%     num2str(bestAct_nonadapt(8)),"-",...
%     num2str(bestAct_nonadapt(8)+bestAct_nonadapt(9)*bestAct_nonadapt(10))," MCM");...
%     strcat('Flexible Operations: Static Dam = ',...
%     num2str(bestAct_adapt(2))," MCM , Flexible Design Dam = ", num2str(bestAct_adapt(3)),"-",...
%     num2str(bestAct_adapt(2)+bestAct_adapt(4)*bestAct_adapt(5))," MCM , Flexible Planned Dam = ",...
%     num2str(bestAct_adapt(8)),"-",...
%     num2str(bestAct_adapt(8)+bestAct_adapt(9)*bestAct_adapt(10))," MCM")},'FontWeight','bold')

% export figure to combine with time series of total costs plot
filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/costTimeSeriesSimPstate.jpg'];
exportgraphics(f,filename1,'Resolution',1200)

%% Combine time series for costs and mode expansion time series
% stack figures

fcomb = figure;
filename1 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/costTimeSeriesSimPstate.jpg'];
filename3 = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/modeExpSimPstate.jpg'];

out = imtile({filename1, filename3},'ThumbnailSize',[],'GridSize',[2,NaN],'BorderSize',100,'BackgroundColor', 'w');
imshow(out);
title({'Simulated Infrastructure Costs and Expansion Decisions'},'FontSize',14)
filename = ['C:/Users/kcuw9/Documents/Mwache_Dam/Plots/multiflex_comb/CostExpansionSimCombinePstate.jpg'];
%saveas(fcomb, filename)
exportgraphics(fcomb,filename,'Resolution',1200);

%% Sankey Diagram of Expansion Decisions for flexible Dam at different P States


% count the number of simulations at each capacity state at each time
% period for each target final precipiation state

cap_colors = [[87, 117, 144];[67, 170, 139];[144, 190, 109];[249, 199, 79];...
    [248, 150, 30];[243, 114, 44];[249, 65, 68]]/255;
P_sample = [68 78 88];


for z=1%:3 %flex design, static, flex planning
    f = figure;
    
    for s=1:2 % for each non-adadaptive vs adaptive operations
        
        for p = 1:length(P_sample) % for each desired final precipiation state
            
            if z == 1 || 2 % z=1 is flexible design/planning, z=2 is static
                
                % load the appropriate data
                if s == 1
                    P_state = P_state_nonadapt;
                    C_state = C_nonadapt(:,:,z);
                    bestAct = bestAct_nonadapt;
                else
                    P_state = P_state_adapt;
                    C_state = C_adapt(:,:,z);
                    bestAct = bestAct_adapt;
                end
            else % Flexible Planning
                if s == 1
                    P_state = P_state_nonadapt_plan;
                    C_state = C_nonadapt_plan(:,:,1);
                    bestAct = bestAct_nonadapt_plan;
                else
                    P_state = P_state_adapt_plan;
                    C_state = C_adapt_plan(:,:,1);
                    bestAct = bestAct_nonadapt_plan;
                end
            end
            
            
            % define the capacity states: static, flex unexpanded, then
            % flex expanded options
            capacities = [bestAct(3) bestAct(2), bestAct(2) + [1:bestAct(4)]*bestAct(5)];
            flex_capacities = capacities(2:end);
            
            % Find simulations with this level of precip at the end of the
            % time period
            [indP_rows, ~] = find(P_state(:,end) == P_sample(p));
            C_state_Pnow = C_state(indP_rows,:);
            
            C_Pnow = capacities(C_state_Pnow);
            
            C_counts = NaN(length(flex_capacities),5);
            for N=1:5
                for i = 1:length(flex_capacities) % note: counts static dams when i = 1, else flex for i>1
                    C_counts(i,N) = sum(C_Pnow(:,N)== flex_capacities(i));
                end
            end
            
            % 4 blocks for N=5 20-year time periods!
            % data of the left panel in each block
            for N=1:4
                %data1{N}= [C_counts(:,N)]';
                data1{N} = [C_counts(C_counts(:,N)>0,N)]';
                caps1{N} = [flex_capacities(C_counts(:,N)>0)]';
            end
            
            % data of the right panel in each block
            for N=2:5
                %data2{N-1}=[C_counts(:,N)]';
                data2{N-1} = [C_counts(C_counts(:,N)>0,N)]';
                caps2{N-1} = [flex_capacities(C_counts(:,N)>0)]';
            end
            
            % data of flows in each block
            data = {};
            for N=1:4
                for i = 1:length(caps1{N})
                    for j = 1:length(caps2{N})
                        data{N}(i,j) = sum((C_Pnow(:,N)== caps1{N}(i)) & ...
                            (C_Pnow(:,N+1) ==caps2{N}(j)));
                    end
                    
                end
            end
            
            % x-axis
            X=[0 1 2 3 4];
            
            % panel color
            colors = cap_colors(1:length(flex_capacities),:);
            for N=1:5
                barcolors{N}=colors(C_counts(:,N)>0,:);
            end
            
            % flow color
            c = [.7 .7 .7];
            
            % Panel width
            w = 25;
            
            for j=1:4 % for each panel: we have 4 panels for N=5 time periods
                if j>1
                    ymax=max(ymax,sankey_yheight(data1{j-1},data2{j-1}));
                    y1_category_points=sankey_alluvialflow(data1{j}, data2{j}, data{j}, X(j), X(j+1), y1_category_points,ymax,barcolors{j},barcolors{j+1},w,c);
                else
                    y1_category_points=[];
                    ymax=sankey_yheight(data1{j},data2{j});
                    y1_category_points=sankey_alluvialflow(data1{j}, data2{j}, data{j}, X(j), X(j+1), y1_category_points,ymax,barcolors{j},barcolors{j+1},w,c);
                end
            end
        end
    end
end
