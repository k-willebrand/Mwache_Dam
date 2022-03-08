% LOGNORMAL DISTRIBUTION ASSUMPTION
% Test that monthly inflow for each climate state follows a log normal
% distribution that is statistically significant (K-S test)

% load runoff data
%load('runoff_by_state_June16_knnboot_1t.mat'); % 5 T states, 32 P states
%load('runoff_by_state_05Aug2021.mat'); % Jenny's updated runoff from CLIRUN (non-expanded)
load('runoff_by_state_19Aug2021.mat'); % Jenny's final updated de-trended data [49:1:119] mm/month

% Keani works with 66 to 97 mm/month; Jenny considers entire precip. range
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % mm/month 

% set algorithm parameters
sys_param.algorithm.name = 'sdp';
sys_param.algorithm.Hend = 0 ; % penalty set to 0
sys_param.algorithm.T = 12;    % the period is equal 1 year
climParam.numSampTS = 100;
runParam.steplen = 20;
sys_param.algorithm.numSampTS = climParam.numSampTS;
sys_param.algorithm.gamma = 1; % set future discount factor
tol = -1;    % accuracy level for termination
max_it = 10; % maximum iteration for termination

% Estimate cyclostationary pdf (assuming log-normal distribution)
T = sys_param.algorithm.T ;

% test climate states and storage capacities
%test_P = [1, 11, 22, 32]; % test precipitation states

%% Run K-S test for each month of the year for each climate state

% h_table = cell(5, 32);
% p_table = cell(5, 32);

h_table = cell(5, 71);
p_table = cell(5, 71);

% calculate test statistics
for s_p=1:71 %:32
    
    P_state = s_p;
    
    for s_t=1:5
        
        T_state = s_t;
        
        qq = runoff{T_state,P_state,1}';
        sys_param.simulation.q = qq;
        Ny = length(sys_param.simulation.q)/T*climParam.numSampTS;
   
        Q = reshape( sys_param.simulation.q, T, Ny );
        q_stat = nan(T,2);
        h = nan(T,1);
        p = nan(T,1);
        
        
        for i = 1:12 % for each month
            qi = Q(i,:);
            q_stat(i,:) = lognfit(qi);
            mu = q_stat(i,1);
            sigma = q_stat(i,2);
            r = lognrnd(mu,sigma);
            [h(i,1),p(i,1)] = kstest2(r,qi);
        end
        h_table{s_t, s_p} = h; % h parameter of ln inflow
        p_table{s_t,s_p} = p; % p-value of ln inflow
        
    end
end

%% Plot K-S test results (p-value)

% K-S test p-value plots (multiple figures)
s_ts = 1:5;


for i=1:9
    
    figure('units','normalized','outerposition',[0 0 1 1])
    if i == 9
        s_ps = [1+8*(i-1):8+8*(i-1)-1];
    else
        s_ps = [1+8*(i-1):8+8*(i-1)];
    end
    
    for p=1:length(s_ps)
        for t=1:length(s_ts)
            s_t = s_ts(t);
            s_p = s_ps(p);
            subplot(length(s_ps),length(s_ts),(p-1)*length(s_ts)+t);
            bar(1:12,p_table{s_t,s_p});
            hold on
            plot(0:13,ones(14)*0.05,'r');
            ylim([0,1]);
            if mod((p-1)*length(s_ts)+t,length(s_ts)) == 1
                label_p = ylabel({'P State: '; strcat(string(s_P_abs(s_p)),' mm/month')},'fontweight','bold');
                label_p.Position(1) = -5; % change horizontal position of ylabel
                set(get(gca,'YLabel'),'Rotation',0)
            end
            if p == 1
                title(strcat('T State: ',string(s_T_abs(s_t)),' C'))
            end
            if p == length(s_ps)
                xlabel('month of year')
            end
        end
    end
    sgtitle({strcat('K-S Test p-values: Log Normal Inflow (', string(i), '/9)');'\alpha = 0.05'})
end


%% Plot K-S test statistic (statistic)
% if h is 1, then the inflow fails to pass log-normal hypothesis

figure
for t=1:length(s_ts)
    s_t = s_ts(t);
    for p=1:length(s_ps)
        s_p = s_ps(p);
        subplot(length(s_ps),length(s_ts),(t-1)*length(s_ps)+p);
        bar(1:12,h_table{s_t,s_p});
        ylim([0,1]);
        title(strcat('T: ',string(s_t),' P: ',string(s_p)))
        xlabel('month of year')
        ylabel('p value')
    end
end
sgtitle('K-S Test Statistic')


% LOGNORMAL DISTRIBUTION ASSUMPTION
% Test that monthly inflow for each climate state follows a log normal
% distribution that is statistically significant (K-S test)

% load runoff data
%load('runoff_by_state_June16_knnboot_1t.mat'); % 5 T states, 32 P states
%load('runoff_by_state_05Aug2021.mat'); % Jenny's updated runoff from CLIRUN (non-expanded)
load('runoff_by_state_19Aug2021.mat'); % Jenny's final updated de-trended data [49:1:119] mm/month

% Keani works with 66 to 97 mm/month; Jenny considers entire precip. range
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % mm/month 

% set algorithm parameters
sys_param.algorithm.name = 'sdp';
sys_param.algorithm.Hend = 0 ; % penalty set to 0
sys_param.algorithm.T = 12;    % the period is equal 1 year
climParam.numSampTS = 100;
runParam.steplen = 20;
sys_param.algorithm.numSampTS = climParam.numSampTS;
sys_param.algorithm.gamma = 1; % set future discount factor
tol = -1;    % accuracy level for termination
max_it = 10; % maximum iteration for termination

% Estimate cyclostationary pdf (assuming log-normal distribution)
T = sys_param.algorithm.T ;

% test climate states and storage capacities
%test_P = [1, 11, 22, 32]; % test precipitation states

%% LOGNORMAL DISTRIBUTION ASSUMPTION (new  21 100-year simulations Oct 8)
% Test that monthly inflow for each climate state follows a log normal
% distribution that is statistically significant (K-S test)

% load runoff data
load('runoff_by_state_02Nov2021.mat'); % Jenny's final updated de-trended data [49:1:119] mm/month

% Keani works with 66 to 97 mm/month; Jenny considers entire precip. range
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % mm/month 

% set algorithm parameters
sys_param.algorithm.name = 'sdp';
sys_param.algorithm.Hend = 0 ; % penalty set to 0
sys_param.algorithm.T = 12;    % the period is equal 1 year
climParam.numSampTS = 21; % number of simulations (21 GCMs)
runParam.steplen = 200; %100; % number of years
sys_param.algorithm.numSampTS = climParam.numSampTS;
sys_param.algorithm.gamma = 1; % set future discount factor
tol = -1;    % accuracy level for termination
max_it = 10; % maximum iteration for termination

% Estimate cyclostationary pdf (assuming log-normal distribution)
T = sys_param.algorithm.T ;

% test climate states and storage capacities
%test_P = [1, 11, 22, 32]; % test precipitation states

%% Run K-S test for each month of the year for each climate state

% h_table = cell(5, 32);
% p_table = cell(5, 32);

h_table = cell(5, 71);
p_table = cell(5, 71);

% calculate test statistics
for s_p=1:71 %:32
    
    P_state = s_p;
    
    for s_t=1:5
        
        T_state = s_t;
        
        qq = runoff{T_state,P_state,1}';
        sys_param.simulation.q = qq;
        Ny = length(sys_param.simulation.q)/T*climParam.numSampTS;
   
        Q = reshape( sys_param.simulation.q, T, Ny );
        q_stat = nan(T,2);
        h = nan(T,1);
        p = nan(T,1);
        
        
        for i = 1:12 % for each month
            qi = Q(i,:);
            q_stat(i,:) = lognfit(qi);
            mu = q_stat(i,1);
            sigma = q_stat(i,2);
            r = lognrnd(mu,sigma);
            [h(i,1),p(i,1)] = kstest2(r,qi);
        end
        h_table{s_t, s_p} = h; % h parameter of ln inflow
        p_table{s_t,s_p} = p; % p-value of ln inflow
        
    end
end

%% Plot K-S test results (p-value)

% K-S test p-value plots (multiple figures)
s_ts = 1:5;


for i=1:9
    
    figure('units','normalized','outerposition',[0 0 1 1])
    if i == 9
        s_ps = [1+8*(i-1):8+8*(i-1)-1];
    else
        s_ps = [1+8*(i-1):8+8*(i-1)];
    end
    
    for p=1:length(s_ps)
        for t=1:length(s_ts)
            s_t = s_ts(t);
            s_p = s_ps(p);
            subplot(length(s_ps),length(s_ts),(p-1)*length(s_ts)+t);
            bar(1:12,p_table{s_t,s_p});
            hold on
            plot(0:13,ones(14)*0.05,'r');
            ylim([0,1]);
            if mod((p-1)*length(s_ts)+t,length(s_ts)) == 1
                label_p = ylabel({'P State: '; strcat(string(s_P_abs(s_p)),' mm/month')},'fontweight','bold');
                label_p.Position(1) = -5; % change horizontal position of ylabel
                set(get(gca,'YLabel'),'Rotation',0)
            end
            if p == 1
                title(strcat('T State: ',string(s_T_abs(s_t)),' C'))
            end
            if p == length(s_ps)
                xlabel('month of year')
            end
        end
    end
    sgtitle({strcat('K-S Test p-values: Log Normal Inflow (', string(i), '/9)');'\alpha = 0.05'})
end


%% Plot K-S test statistic (statistic)
% if h is 1, then the inflow fails to pass log-normal hypothesis

s_ts = 1:5;


for i=1:9
    
    figure('units','normalized','outerposition',[0 0 1 1])
    if i == 9
        s_ps = [1+8*(i-1):8+8*(i-1)-1];
    else
        s_ps = [1+8*(i-1):8+8*(i-1)];
    end
    
    for p=1:length(s_ps)
        for t=1:length(s_ts)
            s_t = s_ts(t);
            s_p = s_ps(p);
            subplot(length(s_ps),length(s_ts),(p-1)*length(s_ts)+t);
            bar(1:12,h_table{s_t,s_p});
            ylim([0,1]);
            if mod((p-1)*length(s_ts)+t,length(s_ts)) == 1
                label_p = ylabel({'P State: '; strcat(string(s_P_abs(s_p)),' mm/month')},'fontweight','bold');
                label_p.Position(1) = -5; % change horizontal position of ylabel
                set(get(gca,'YLabel'),'Rotation',0)
            end
            if p == 1
                title(strcat('T State: ',string(s_T_abs(s_t)),' C'))
            end
            if p == length(s_ps)
                xlabel('month of year')
            end
        end
    end
sgtitle('K-S Test Statistic')
end