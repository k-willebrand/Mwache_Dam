%% KL Divergence Post Processing: This could be an alternative to just running 
% the Bayesian Quant Learning file, and to instead take X number of
% instances from the simulation and to calculate the KL divergence values
% for them
% July 2021

%% Parameters

clear all; close all;

scenarios = {'Dry, High Learning', 'Mod, High Learning', 'Wet, High Learning',...
    'Dry, Medium Learning', 'Mod, Medium Learning', 'Wet, Medium Learning',...
    'Dry, Low Learning', 'Mod, Low Learning', 'Wet, Low Learning'};

files = {'T_Temp_Precip_dry1', 'T_Temp_Precip_mod1', 'T_Temp_Precip_wet1', ...
    'T_Temp_Precip_dry2', 'T_Temp_Precip_mod2', 'T_Temp_Precip_wet2', ...
    'T_Temp_Precip_dry4', 'T_Temp_Precip_mod4', 'T_Temp_Precip_wet4'};

for i=1:9
    files_opt{i} = strcat('BestFlexStatic_', files{i});
end

% Updating over time with runoff
addpath('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Mombasa_climate/SDP')
load('runoff_by_state_Mar16_knnboot_1t')

numSamp = 25000;
decades = { '1990', '2010', '2030', '2050', '2070', '2090'};

%% For loop to run and calculate KL divergence
numRuns = 100;
rndSamps = randi(10000, [numRuns 1]);
tic
for m=2:2
    load(files_opt{m});
    
    % load shortages using the optimized reservoir operations
    unmet_dom = storageSize2domShortage(storage(2), 1, N, M_T_abs, M_P_abs);
        
    % for loop to calculate KLD for numRuns
    for n=1:numRuns
        state_ind_P = zeros(1,N+1); % state_ind_P = zeros(1,N)
        state_ind_T = zeros(1,N+1); % state_ind_T = zeros(1,N)
        state_ind_P(1) =  find(climParam.P0_abs==s_P_abs);
        state_ind_T(1) = find(climParam.T0_abs==s_T_abs);
        state_ind_P(2:end) = P_state(rndSamps(n),:)-(s_P_abs(1)-1);
        randGen = true;

        MAR = cellfun(@(x) mean(mean(x)), runoff);
        p = randi(numSamp,N-1);
        T_over_time = cell(1,N);
        P_over_time = cell(1,N);
        MAR_over_time = cell(1,N);
            
            for t = 1:N
                % Sample forward distribution given current state
                T_current = s_T_abs(state_ind_T(t));
                P_current = s_P_abs(state_ind_P(t));
                [T_over_time{t}] = T2forwardSimTemp(T_Temp, s_T_abs, N, t, T_current, numSamp, false);
                [P_over_time{t}] = T2forwardSimTemp(T_Precip, s_P_abs, N, t, P_current, numSamp, false);
                
                % Lookup MAR and yield for forward distribution
                T_ind = arrayfun(@(x) find(x == s_T_abs), T_over_time{t});
                P_ind = arrayfun(@(x) find(x == s_P_abs), P_over_time{t});
                [~,t_steps] = size(T_ind);
                MAR_over_time{t} = zeros(size(T_ind));
                yield_over_time{t} = zeros(size(T_ind));
                for i = 1:numSamp
                    for j = 1:t_steps
                        MAR_over_time{t}(i,j) = MAR(T_ind(i,j), P_ind(i,j), 1);
                        yield_over_time{t}(i,j) = unmet_dom(T_ind(i,j), P_ind(i,j),1, 1) ; % flex unexpanded size (MCM)
                    end
                end
                
                % Sample next time period
                if randGen
                    state_ind_T(t+1) = find(T_over_time{t}(p(t),2)==s_T_abs);
                end
            end
            
            % Calculate KL Divergence
            % Specify calculation method and input parameters
            param.CalcMethod = 2; % 1 = Simple, 2 = Bin Counting, 3 = BC + Zero + BoxCox
            param.NumBins = 50;
            param.Const = 1*10^-4; % Account for zeros by adding a small value
            param.Transform = 0; % 0 = no transform, 1 = boxcox, 2 = log
            
            % Calc precip using bin discretization
            KLDiv_Precip_Simple(n,:,m) = CalcKLDivergence(P_over_time, 3, 0, param.Const, param.NumBins);
            
            % Log Transform, Optimal Bins
            KLDiv_Precip_Log(n,:,m) = CalcKLDivergence(P_over_time, 2, 2, param.Const, param.NumBins);
            KLDiv_MAR_Log_Opt(n,:,m) = CalcKLDivergence(MAR_over_time, 2, 2, param.Const, param.NumBins);
            KLDiv_Yield_Log_Opt(n,:,m) = CalcKLDivergence(yield_over_time, 2, 2, param.Const, param.NumBins);
            
            for c=1:size(state_ind_P, 2)
                    state_ind_MAR(n,c,m) = MAR(state_ind_T(c), state_ind_P(c), 1);
                    state_ind_Yield(n,c,m) = unmet_dom(state_ind_T(c), state_ind_P(c), 1, 1);
            end
            
            stateMsg = strcat('n= ', num2str(n));
            disp(stateMsg);
        end
        
        stateMsg = strcat('scenario = ', files{m});
        disp(stateMsg);
        toc;
    
    
end