% DESCRIPTION:
% Plot the SDP adaptive and non-adaptive operations over a 100-year period
% to observe steady state performance and behavior (shortage costs, unmet
% demands, objective funciton values, and storage over time)

%% Plot a single 100-year simulation

storage_vals = [50, 150];

s_T_abs = [26.25];
s_P_abs = [66, 97]; % mm/month
s_P_indx = [18, 49];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months
runParam.adaptiveOps = true;

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

count = 3;
figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:2
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),2,s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),2,count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V8Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            for i=1:5
                plot(1+240*(i-1):240*i,storage_ts(1+240*(i-1):240*i,1))
                hold on
            end
            title('Effective Reservoir Storage vs. Month')
            xlabel('Month')
            ylabel('Eff. Reservoir Storage (MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            end
            
            ylim([0,storage_vals(s)])
            
            % find average value for January 1st
            jan_rows = [1:12:1201];
            jan_storage = storage_ts(jan_rows,:);
            jan_avg = mean(jan_storage,'all');
            jan_avg_ss = mean(jan_storage(5:end,1),'all'); % average for the given simulation
            
            p1 = plot(60:1200,jan_avg_ss*ones(1200-59,1),'Color','black','LineWidth',1,'DisplayName',strcat('January Steady-State Eff. Storage (',string(round(jan_avg_ss,1)),' MCM)'));
            legend(p1);
            
            count = count + 2;
        end
        count = count - 3;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'V8 SDP Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'Runoff _ test _ 18Aug.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end

%% Plot all 20 100-year simulations

storage_vals = [50, 150];

s_T_abs = [26.25];
s_P_abs = [66, 97]; % mm/month
s_P_indx = [18, 49];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months
runParam.adaptiveOps = true;

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data


count = 3;
figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:2
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),2,s_P)
        qq  = runoff{T_state,P_state,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),2,count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V6Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            plot(1:1201,storage_ts)
                
            title('Effective Reservoir Storage vs. Month')
            xlabel('Month')
            ylabel('Eff. Reservoir Storage (MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            end
            
            ylim([0,storage_vals(s)])
            
            % find average value for January 1st
            jan_rows = [1:12:1201];
            jan_storage = storage_ts(jan_rows,:);
            jan_avg = mean(jan_storage,'all');
            jan_avg_ss = mean(jan_storage(5:end,:),'all'); % average across all 20 100-year simulations
            
            hold on
            p1 = plot(60:1200,jan_avg_ss*ones(1200-59,1),'Color','black','LineWidth',1,'DisplayName',strcat('January Steady-State Eff. Storage (',string(round(jan_avg_ss,1)),' MCM)'));
            legend(p1);
            xlim([1,1201])
            
            count = count + 2;
        end
        count = count - 3;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'V8 SDP Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'Runoff _ test _ 18Aug.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'Runoff _ test _ 18Aug.mat'},'FontWeight','bold')
end

%% Releases for a single realizaiton

%% Plot a single 100-year simulation

storage_vals = [50, 150];

s_T_abs = [26.25];
s_P_abs = [66, 97]; % mm/month
s_P_indx = [18, 49];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months
runParam.adaptiveOps = true;

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

count = 3;
figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:2
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),2,s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),2,count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V6Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V6Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            for i=1:5
                plot(1+240*(i-1):240*i,release_ts(1+240*(i-1):240*i,1))
                hold on
            end
            title('Effective Reservoir Storage vs. Month')
            xlabel('Month')
            ylabel('Eff. Reservoir Storage (MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            end
            
            count = count + 2;
        end
        count = count - 3;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'V8 SDP Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'Runoff _ test _ 18Aug.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end

%% %% Plot a single 100-year simulation (4 different climate states)

storage_vals = [80, 120];

s_T_abs = [26.25];
s_P_abs = [49, 66, 97, 119]; % mm/month
s_P_indx = [1, 18, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months
runParam.adaptiveOps = true;

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:4
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V8Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            for i=1:5
                plot(1+240*(i-1):240*i,storage_ts(1+240*(i-1):240*i,1))
                hold on
            end
            title('Effective Reservoir Storage vs. Month')
            xlabel('Month')
            ylabel('Eff. Storage (MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            end
            
            ylim([0,storage_vals(s)])
            
            % find average value for January 1st
            jan_rows = [1:12:1201];
            jan_storage = storage_ts(jan_rows,:);
            jan_avg = mean(jan_storage,'all');
            jan_avg_ss = mean(jan_storage(5:end,1),'all'); % average for the given simulation
            
            p1 = plot(60:1200,jan_avg_ss*ones(1200-59,1),'Color','black','LineWidth',1,'DisplayName',strcat('Jan. Steady-State Eff. Storage (',string(round(jan_avg_ss,1)),' MCM)'));
            legend(p1,'Location','best');
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'Runoff _ test _ 18Aug.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated Sample 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end

%% %% Plot storage for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = false;
storage_vals = [50, 80, 100, 120, 150];

s_T_abs = [26.25];
s_P_abs = [49, 66, 97, 119]; % mm/month
s_P_indx = [1, 18, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_31Aug2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:4
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,2))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('MZAug312021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_082521.mat');
                load(filename)
            else
                filename = strcat('MZAug312021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_082521.mat');
                load(filename) 
            end
            
            plot(1:1201,storage_ts)
            
            % find average value for January 1st
            jan_rows = [1:12:1201];
            jan_storage = storage_ts(jan_rows,:);
            jan_avg = mean(jan_storage,'all');
            jan_avg_ss = mean(jan_storage(5:end,:),'all'); % average across all 20 100-year simulations
            
            hold on
            p1 = plot(60:1200,jan_avg_ss*ones(1200-59,1),'Color','black','LineWidth',1,'DisplayName',strcat('Jan. Steady-State Eff. Storage (',string(round(jan_avg_ss,1)),' MCM)'));
            legend(p1);
            xlim([1,1201])
            
            title('Effective Reservoir Storage vs. Month')
            xlabel('Month')
            ylabel('Eff. Storage (MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Effective Reservoir Storage vs. Time'})
            end
            
            ylim([0,storage_vals(s)])
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 31Aug2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 31Aug2021.mat'},'FontWeight','bold')
end

%% Plot objective function value for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = false;
storage_vals = [50, 100, 150];

s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; %[26.25];
s_P_abs = [49, 66, 77, 97, 119]; % mm/month
s_P_indx = [1, 18, 29, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
%load('runoff_by_state_20Sept2021.mat'); % pick P_ts from Jenny's updated data
load('Test_runoff_by_state_20Sept2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 5
    T_state = s_T;
    
    for s_P = 1:length(s_P_abs)
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,800])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('TestSept202021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_092221.mat');
                load(filename)
            else
                filename = strcat('TestSept202021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_092221.mat');
                load(filename) 
            end
            
            if s == 1
                ylim_max = max(objective_ts,[],'all');
                if ylim_max == 0
                    ylim_max = 1;
                end
            end
            
            plot(1:1200,objective_ts)
            
            xlim([1,1201])
            %ylim([0,ylim_max])
            
            % find average 20 objective function value after first 20 years
            SS_cumsum_obj = sum(objective_ts(T*20+1:end,:)); % total objective function value in SS years
            num_SS_years = (length(objective_ts(:,1))-20*T)/(20*T); % number of years in SS
            obj_avg_ss = mean(SS_cumsum_obj/num_SS_years); % average across all 20 100-year simulations
            
            hold on
            %p1 = plot(20*T:1200,obj_avg_ss*ones(1200-(20*T-1),1),'Color','black','LineWidth',1,'DisplayName',strcat('Avg. 20-year Obj. Func. (',string(round(obj_avg_ss,1)),')'));
            %legend(p1);
            dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
            legend(dummyh, strcat('Avg. 20-year Obj. Func. (',num2str(obj_avg_ss,4),')'),'FontSize',6)
            xlim([1,1201])
            
            title('Objective Function vs. Month')
            xlabel('Month')
            ylabel('Obj. Func.')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Obj. Func. vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Obj. Func. vs. Time'})
            end
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Objective Function Value vs. Time';'Updated 20 100-Year Simulation Time Series';'Test runoff by state 20Sept2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Objective Function Value vs. Time';'Updated 20 100-Year Simulation Time Series';'Test runoff by state 20Sept2021.mat'},'FontWeight','bold')
end


%% Plot alternative shortage cost value for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = false;
storage_vals = [50, 100, 150];

% Parameters:
costParam.agShortage = 0.25; % USD$/m3
costParam.domShortage = 2 * costParam.agShortage; % USD$/m3

s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; %[26.25];
s_P_abs = [49, 66, 77, 97, 119]; % mm/month
s_P_indx = [1, 18, 29, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
%load('runoff_by_state_20Sept2021.mat'); % pick P_ts from Jenny's updated data
load('runoff_by_state_20Sept2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:length(s_P_abs)
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,800])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('Sept202021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_092221.mat');
                load(filename)
            else
                filename = strcat('Sept202021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_092221.mat');
                load(filename) 
            end
            
            % find average 20 unmet ag volume after first 20 years
            SS_cumsum_ag = sum(unmet_ag_ts(T*20+1:end,:)); % total objective function value in SS years
            num_SS_years = (length(unmet_ag_ts(:,1))-20*T)/(20*T); % number of years in SS
            ag_avg_ss = mean(SS_cumsum_ag/num_SS_years); % average across all 20 100-year simulations

            % find average 20 unmet dom volume after first 20 years
            SS_cumsum_dom = sum(unmet_dom_ts(T*20+1:end,:)); % total objective function value in SS years
            num_SS_years = (length(unmet_dom_ts(:,1))-20*T)/(20*T); % number of years in SS
            dom_avg_ss = mean(SS_cumsum_ag/num_SS_years); % average across all 20 100-year simulations

            shortage_avg_ss = costParam.agShortage * ag_avg_ss + costParam.domShortage * dom_avg_ss;
            
            
            if s == 1
                ylim_max = max(unmet_ts,[],'all');
                if ylim_max == 0
                    ylim_max = 1;
                end
            end
            
            plot(1:1200,unmet_ts)
            
            xlim([1,1201])
            %ylim([0,ylim_max])
            
            hold on
            %p1 = plot(20*T:1200,obj_avg_ss*ones(1200-(20*T-1),1),'Color','black','LineWidth',1,'DisplayName',strcat('Avg. 20-year Obj. Func. (',string(round(obj_avg_ss,1)),')'));
            %legend(p1);
            dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
            legend(dummyh, strcat('Avg. 20-year Short. Cost ($',num2str(shortage_avg_ss,4),')'),'FontSize',6)
            xlim([1,1201])
            
            title('Unmet Demands vs. Month')
            xlabel('Month')
            ylabel('Unmet Dmd (m3)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Unmet Dmd vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Unmet Dmd vs. Time'})
            end
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Unmet Demand and Shortage Cost vs. Time';'Ag Shortage = $0.25/m^3 & Dom Shortage $0.50/m^3';'Updated 20 100-Year Simulation Time Series';'runoff by state 20Sept2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Unmet Demand and Shortage Cost vs. Time';'Ag Shortage = $0.25/m^3 & Dom Shortage $0.50/m^3';'Updated 20 100-Year Simulation Time Series';'runoff by state 20Sept2021.mat'},'FontWeight','bold')
end

%% Plot cumulative objective function value for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = true;
storage_vals = [50, 80, 100, 120, 150];

s_T_abs = [26.25];
s_P_abs = [49, 66, 97, 119]; % mm/month
s_P_indx = [1, 18, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:4
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V8Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            plot(1:1200,cumsum(objective_ts))
            
            xlim([1,1201])
            
            title('Cumulative Objective Function Value vs. Month')
            xlabel('Month')
            ylabel('Cum. Obj. Func.')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            end
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end

%% Plot releases for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = false;
storage_vals = [50, 80, 100, 120, 150];

s_T_abs = [26.25];
s_P_abs = [49, 66, 97, 119]; % mm/month
s_P_indx = [1, 18, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:4
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V8Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            cum_release = cumsum(release_ts(2:end,:))/12;
            plot(1:1200,cum_release) % units: MCM
            
            avg_yield = mean(cum_release(end,:));
            
            xlim([1,1201])
            
            title('Release Volume vs. Month')
            xlabel({'Month';strcat('Average Total Yield: ',string(avg_yield),'MCM')})
            ylabel('Release(MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            end
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end

%% Plot evaporation time series for all 20 100-year simulations (4 different climate states)

runParam.adaptiveOps = true;
storage_vals = [50, 80, 100, 120, 150];

s_T_abs = [26.25];
s_P_abs = [49, 66, 97, 119]; % mm/month
s_P_indx = [1, 18, 49, 71];

% define runoff structure
climParam.numSampTS = 100; % simulations
runParam.steplen = 20; % years
T = 12; % months

%load('runoff_by_state_June16_knnboot_1t.mat'); % synthetic inflow data (MCM/Y)
%load('runoff_by_state_05Aug2021.mat'); % from Jenny's updated data
load('runoff_by_state_19Aug2021.mat'); % pick P_ts from Jenny's updated data

figure
for s_T = 1
    T_state = s_T;
    
    for s_P = 1:4
        P_state_indx = s_P_indx(s_P);
        
        subplot(1+length(storage_vals),length(s_P_indx),s_P)
        qq  = runoff{T_state,P_state_indx,1}' ; % inflow for initial climate state is (1,12,1)
        qq = reshape(qq,runParam.steplen*T*5,climParam.numSampTS/5); % reshape original data to make 20 100-year simulations!
        for i=1:5
            plot(1+240*(i-1):240*i,qq(1+240*(i-1):240*i,1))
            hold on
        end
        title({strcat('P State ',string(s_P_abs(s_P)),' mm/month & T State ', string(s_T_abs(s_T)),' C');'Runoff vs. Time'})
        xlabel('Month')
        ylim([0,500])
        ylabel('Runoff (MCM/Y)')
        
    end
    
    count = length(s_P_indx)+1;
    for s_P = 1:length(s_P_indx)
        P_state_indx = s_P_indx(s_P);
        
        for s = 1:length(storage_vals)
            
            subplot(1+length(storage_vals),length(s_P_indx),count)
            
            if runParam.adaptiveOps == true
                filename = strcat('V8Aug2021adaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename)
            else
                filename = strcat('V8Aug2021nonadaptive_domagCost21_SSTest_st',string(s_T),'_sp',string(P_state_indx),'_s',string(storage_vals(s)),'_080621.mat');
                load(filename) 
            end
            
            plot(1:1201,evaporation_ts/12) % units: MCM
            
            % average evaporation across all months for years 5 through 100
            evap_avg_ss = mean(evaporation_ts(60:end,:)/12,'all'); % average across all 20 100-year simulations
            
            hold on
            p1 = plot(60:1200,evap_avg_ss*ones(1200-59,1),'Color','black','LineWidth',1,'DisplayName',strcat('Avg. Monthly Evap. Vol. (',string(round(evap_avg_ss,3)),' MCM)'));
            legend(p1,'Location','best');
            
            xlim([1,1201])
            ylim([-0.5,1.5])
            
            title('Evaporation Volume vs. Month')
            xlabel('Month')
            ylabel('Evap.(MCM)')
            if runParam.adaptiveOps == true
                title({strcat('SDP Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            else
                title({strcat('SDP Non-Adaptive ',string(storage_vals(s)),' MCM Dam');'Cum. Obj. Func. Value vs. Time'})
            end
            
            count = count + length(s_P_indx);
        end
        count = count - length(storage_vals)*length(s_P_indx)+1;
    end
end

if runParam.adaptiveOps == true
    sgtitle({'SDP Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
else
    sgtitle({'SDP Non-Adaptive Dams';'Updated 20 100-Year Simulation Time Series';'runoff by state 19Aug2021.mat'},'FontWeight','bold')
end