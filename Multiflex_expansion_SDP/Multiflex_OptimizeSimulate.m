%% Wrapper Function for Multiflex Optimization and Simulation
% July 2022
% For one set of transition matrices, do the following:
%   1. Find the optimal flexible dam size
%   2. Find the optiml static dam size
%   3. Run the forward simulation with the optimal flex/static sizes

%% Setup
clear all;
% Set Project root folder and Add subfolders to path; runs either on desktop 
% or on a cluster using SLURM queueing system 
if ~isempty(getenv('SLURM_JOB_ID'))
    projpath = '/home/users/jskerker/Mwache_Dam';
else
    projpath = '/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Mwache_Dam';
    
end
addpath(genpath(projpath))

jobid = getenv('SLURM_JOB_ID');

% Get date for file name when saving results 
datetime=date;%datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_')%Replace space with underscore
%%
%tic

% Step 0. Load learning scenario transition matrix data

learning_scen = {'High', 'Low'}; %, 'Med'
%learning_scen = {'ExtHigh', 'No'};
climate_scen = {'Wet', 'Mod', 'Dry'};
%sim_scen = {'High_Dry', 'High_Mod', 'High_Wet', 'Low_Dry', 'Low_Mod', 'Low_Wet'};
% 'Med_Dry', 'Med_Mod', 'Med_Wet'
storageAll = 50:10:150;
%factors = 1:-0.03:0.7;
%filesExt = {'Wet67Dry33_High_Learning_Test_02May2022.mat', 'Extreme_High_Learning_Mod_02May2022.mat', 'No_Learning_Test_13Jan2022.mat'};

m = 1;
%learning_scen = 'NoLowLearn';
%% 
for m=1:length(learning_scen)
     %cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Mwache_Dam/Synthetic_TransMatrices/TMs_21Oct2021');
     cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Mwache_Dam/Synthetic_TransMatrices/Bayes_July2022');
     %TM_filename = strcat('T_Temp_Precip_',string(learning_scen{m}),'.mat'); %mod_T_... 
     TM_filename = strcat('T_Temp_Precip_V2_',string(learning_scen{m}), '_July2022_Bayes','.mat'); %mod_T_... 
     TM = strcat('T_Temp_Precip_',string(learning_scen{m}));
     %TM_filename = filesExt{m}
     load(TM_filename);
     
     scenName = '3DR_RunoffNov_BayesTMs_V2_Plan50_NoConst_6e-6';
     %cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Mwache_Dam/Synthetic_TransMatrices/Test_CornerCases_15Nov2021');
     %load('T_Temp_Precip_ExtHigh', 'T_Precip');
     %load('Extreme_High_Learning_Mod_22Mar2022_test', 'T_Precip');
     %load('T_Temp_Precip_Neg_shift25', 'T_Precip');
     %load('T_Temp_Precip_RCP85B_KW.mat', 'T_Precip');
  %   disp(TM);

    % Step 1. Find the optimal flexible dam size
    bestVal_flex = inf;

    for j=50:10:140 % initial unexpanded dam sizes
        for h=1%:5 %2
            for g=1:5
                stateMsg = strcat('m=', num2str(m), 'j=', num2str(j), ', g=', ...
                    num2str(g), ', h=', num2str(h));
                disp(stateMsg);
                
                  if (j+h*10*g) > 150
                      disp('Flex design surpasses max capacity');
                  %elseif (j+h*10*g) < ceil(1.2*j/10)*10 % if false, then this combination is ok
                  %if or((j*1.25) > (j+h*10*g), (j*1.6) < (j+h*10*g)) % if false, then this combination is ok
                  %elseif (j*1.6) < (j+h*10*g)
                  %  disp('Flex size surpasses 160% initial capacity');
                    %disp('Flex design max expansion less than 30% of initial cap'); %50% of initial capacity');
                   %elseif (j+h*10*g) ~= 150 & (j+h*10*g) ~= ceil(1.5*j/10)*10
                     %  disp('Flex design max expansion not 150 MCM or less than 150% of initial cap');
%                        
                  else %if (j*1.3) >= (j+h*10*g)
                
                    x(1) = 1; % optParam.optFlex
                    x(2) = j; % optParam.smallCap
                    x(3) = g; % optParam.numFlex
                    x(4) = h*10; % optParam.flexIncr 
                    x(5) = 50; % optParam.staticCap
                    x(6) = false; % runParam.forwardSim
                    x(7) = true; % runParam.runSDP
                    x(8) = 0.03; % costParam.discountrate
                    x(9) = 0.0; % costParam.PercFlex % .075
                    x(10) = 0.5; % costParam.PercFlexExp % .15
                    % 3% params: .075, 0.15, 0% params: 0, 0.25 (or 0.5)

                    run('multiflex_sdp_climate_StaticFlex_DetT_StateSpace');
                    P0 = find(s_P_abs == 77)
                    val = V(1, P0, 1, 1);
                    if val < bestVal_flex
                        bestVal_flex = val;
                        allV_flex = V;
                        bestAct_flex = x;
                        allX_flex = X;
                        allV_flex_short = Vs;
                        allV_flex_dam = Vd;
                    end
                  %else
                    %disp('flex size also not feasible');
                end
            end
        end
    end
    %toc

    %%
    % 2. Find the optimal static dam size
    bestVal_static = inf;

    for j=50:10:150
            stateMsg = strcat('j=', num2str(j));
            disp(stateMsg)
            x(1) = 2; % optParam.optFlex: choose 2 for static design
            x(2) = 50; % optParam.smallCap
            x(3) = 0; % optParam.numFlex
            x(4) = 0; % optParam.flexIncr
            x(5) = j; % optParam.staticCap
            x(6) = false; % runParam.forwardSim
            x(7) = true; % runParam.runSDP
            x(8) = 0.03; % costParam.discountrate
            x(9) = 0.0; % costParam.PercFlex % .075
            x(10) = 0.5; % costParam.PercFlexExp % .15

            run('multiflex_sdp_climate_StaticFlex_DetT_StateSpace');
            val = V(1, P0, 1, 1);
            if val < bestVal_static
                bestVal_static = val;
                allV_static = V;
                bestAct_static = x;
                allX_static = X;
                allV_static_short = Vs;
                allV_static_dam = Vd;
            end
    end
    file_name = strcat('ExpCosts_', learning_scen{m}, '_', num2str(x(8)*100), ...
        'DR');
    save(file_name, 'allV_static_short', 'allV_static', 'allV_static_dam', ...
        'allV_flex_short', 'allV_flex', 'allV_flex_dam');
    %toc

    %%
    % 3. Run the SDP with the combined matrices and optimal dam sizes

    % get optimal values
    x(1) = 0; % optParam.optFlex
    x(2) = bestAct_flex(2); % optParam.smallCap
    x(3) = bestAct_flex(3); % optParam.numFlex
    x(4) = bestAct_flex(4); % optParam.flexIncr
    x(5) = bestAct_static(5); % optParam.staticCap
    x(6) = true; %false; % runParam.forwardSim
    x(7) = true; % runParam.runSDP
    x(8) = 0.03; % costParam.discountrate
    x(9) = 0.0; %0.075; % costParam.PercFlex
    x(10) = 0.5; % costParam.PercFlexExp

    run('multiflex_sdp_climate_StaticFlex_DetT_StateSpace');
    location = strcat(projpath, '/Multiflex_expansion_SDP/Results.nosync');
    cd(location)
    new_folder = strcat(learning_scen{m}, '_learning_scenario');
    %mkdir(strcat(location, '/', new_folder));
    cd(new_folder);
    file_name = strcat('OptimalPolicies_', num2str(learning_scen{m}), '_', scenName, '_', datetime); %, '_disc', num2str(d*100));
    save(file_name);
    
    %%
    % 4. Run the forward simulation with wet, dry, moderate matrices
    % for the optimal dam sizes and combined policies
    % October 2021: try simulating all 9 scenarios
    
%     % update necessary parameters
%     x(6) = true; % runParam.forwardSim
%     x(7) = false; % runParam.runSDP
%     
%     % Step 4a. Run each learning climate scenario
%     for scen=1:3 
%         TM_filename = strcat('T_Temp_Precip_',string(sim_scen{scen+(m-1)*3}),'.mat');
%         TM = strcat('T_Temp_Precip_',string(sim_scen{scen}));
%         %load('T_Temp_Precip_ExtHighWet.mat', 'T_Precip');
%         load(TM_filename);
%         disp(sim_scen{scen+(m-1)*3});
% 
%         run('multiflex_sdp_climate_StaticFlex_DetT_StateSpace');
%         file_name = strcat('Simulation_', learning_scen{m}, '_Policy_', sim_scen{scen+(m-1)*3}) %, '_disc', num2str(d*100));
%         save(file_name);
%     end
    
    %toc
%end
%toc
end