%% Wrapper Function for Multiflex KL Divergence Tests
% June 2021
% For one set of transition matrices, do the following:
%   1. Find the optimal flexible dam size
%   2. Find the optimal static dam size
%   3. Run the forward simulation with the optimal flex/static sizes

tic
clear all;
close all;
%scen = 5;

% 0. Load transition matrix scenario data

TM_scenarios = {'wet1', 'wet2', 'wet4', 'dry1', 'dry2', 'dry4', 'mod1', 'mod2', 'mod4'};
%learning_vals = [1 2 4];
learning = {'high', 'medium', 'low'};
%d = 0.03;
f = 0.1;

for d=0.03:0.03:0.06
for m=1:3

    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP/TMs_Test_30_Jun_2021_21_49_37');
    TM_filename = strcat('T_Temp_Precip_',string(learning{m}),'.mat');
    TM = strcat('T_Temp_Precip_',string(learning{m}));
    load(TM_filename);
    disp(TM);

    % 1. Find the optimal flexible dam size
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Operations/Fletcher_2019_Learning_Climate/SDP');
    bestVal_flex = inf;

    for j=50:10:90
        for h=1:2
            for g=1:(7-2*h)
                stateMsg = strcat('j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                x(1) = 1; % optParam.optFlex
                x(2) = j; % optParam.smallCap
                x(3) = g; % optParam.numFlex
                x(4) = h*10; % optParam.flexIncr
                x(5) = 50; % optParam.staticCap
                x(6) = false; % runParam.forwardSim
                x(7) = f; % costParam.PercFlexExp
                x(8) = d; % costParam.discountrate
                x(9) = true; % runParam.runSDP

                run('multiflex_sdp_climate_StaticFlex');
                val = V(1, 12, 1, 1);
                if val < bestVal_flex
                    bestVal_flex = val;
                    allV_flex = V;
                    bestAct_flex = x;
                    allX_flex = X;

                end
            end
        end
    end
%     old_path = '/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning';
%     cd(old_path);
%     mkdir(TM);
%     new_path = strcat(old_path, '/', TM);
%     cd(new_path);
%     file_name = strcat('BestFlex_', TM);
%     save(file_name);
    toc

    %%
    % 2. Find the optimal static dam size
    bestVal_static = inf;

    for j=50:10:100
            stateMsg = strcat('j=', num2str(j));
            disp(stateMsg)
            x(1) = 2; % optParam.optFlex
            x(2) = 50; % optParam.smallCap
            x(3) = 0; % optParam.numFlex
            x(4) = 0; % optParam.flexIncr
            x(5) = j; % optParam.staticCap
            x(6) = false; % runParam.forwardSim
            x(7) = f; % costParam.PercFlexExp
            x(8) = d; % costParam.discountrate
            x(9) = true; % runParam.runSDP

            run('multiflex_sdp_climate_StaticFlex');
            val = V(1, 12, 1, 1);
            if val < bestVal_static
                bestVal_static = val;
                allV_static = V;
                bestAct_static = x;
                allX_static = X;

            end
    end
    toc

    %%
    % 3. Run the SDP with the combined matrices and optimal dam sizes

    % get optimal values
    x(1) = 0; % optParam.optFlex
    x(2) = bestAct_flex(2); % optParam.smallCap
    x(3) = bestAct_flex(3); % optParam.numFlex
    x(4) = bestAct_flex(4); % optParam.flexIncr
    x(5) = bestAct_static(5); % optParam.staticCap
    x(6) = false; % runParam.forwardSim
    x(7) = f; % costParam.PercFlexExp
    x(8) = d; % costParam.discountrate
    x(9) = true; % runParam.runSDP

    run('multiflex_sdp_climate_StaticFlex');
    file_name = strcat('OptimalPolicies_', num2str(learning{m}), '_disc', num2str(d*100));
    save(file_name);
    
    %%
    % 4. Run the forward simulation with wet, dry, moderate matrices
    % for the optimal dam sizes and combined policies
    
    % 4a. Run for the wet scenario
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP/TMs_Test_30_Jun_2021_21_49_37'); % finish this line
    TM_filename = strcat('T_Temp_Precip_',string(TM_scenarios{m}),'.mat');
    TM = strcat('T_Temp_Precip_',string(TM_scenarios{m}));
    load(TM_filename);
    disp(TM);
    
    % update necessary parameters
    x(6) = true; % runParam.forwardSim
    x(9) = false; % runParam.runSDP
    
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Operations/Fletcher_2019_Learning_Climate/SDP');
    run('multiflex_sdp_climate_StaticFlex');
    file_name = strcat('Simulation_', TM_scenarios{m}, '_disc', num2str(d*100));
    save(file_name);
    
    
    % 4b. Run for the dry scenario
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP/TMs_Test_30_Jun_2021_21_49_37'); % finish this line
    TM_filename = strcat('T_Temp_Precip_',string(TM_scenarios{m+3}),'.mat');
    TM = strcat('T_Temp_Precip_',string(TM_scenarios{m+3}));
    load(TM_filename);
    disp(TM);
    
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Operations/Fletcher_2019_Learning_Climate/SDP');
    run('multiflex_sdp_climate_StaticFlex');
    file_name = strcat('Simulation_', TM_scenarios{m+3}, '_disc', num2str(d*100));
    save(file_name);
   
    
    % 4c. Run for the mod scenario
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/SDP/TMs_Test_30_Jun_2021_21_49_37'); % finish this line
    TM_filename = strcat('T_Temp_Precip_',string(TM_scenarios{m+6}),'.mat');
    TM = strcat('T_Temp_Precip_',string(TM_scenarios{m+6}));
    load(TM_filename);
    disp(TM);
    
    cd('/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Operations/Fletcher_2019_Learning_Climate/SDP');
    run('multiflex_sdp_climate_StaticFlex');
    file_name = strcat('Simulation_', TM_scenarios{m+6}, '_disc', num2str(d*100));
    save(file_name);

    toc
end
end