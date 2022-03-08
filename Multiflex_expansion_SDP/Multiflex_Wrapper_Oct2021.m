%% Wrapper Function for Multiflex KL Divergence Tests
% June 2021
% For one set of transition matrices, do the following:
%   1. Find the optimal flexible dam size
%   2. Find the optimal static dam size
%   3. Run the forward simulation with the optimal flex/static sizes

% This wrapper function script has been designed for Keani's analysis

clear all;
%close all;

cd('C:/Users/kcuw9/Documents/Mwache_Dam/Multiflex_expansion_SDP');
addpath('C:\Users\kcuw9\Documents\Mwache_Dam')
mkdir('Nov02optimal_dam_design')

% Note: updated script now also includes flexible planning in addition to
% static dam design and flexible dam design. Forward simulations are run
% twice: (1) flexible design vs. static (2) flexible planning vs. static.

% The random seed in forward simulations has been specified so that forward
% simulation runs can be directly compared.


% find the optimal dam designs:

for z=1:2 % the adaptive and non-adaptive policies

    % 1. Find the optimal flexible dam size
    bestVal_flex = inf;
    
    for j=50:10:140 % initial unexpanded dam sizes
        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h) 
                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                
                if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                    disp('Flex size not feasible');
                else
                    x(1) = 1; % optParam.optFlex: choose 1 for flexible design
                    x(2) = j; % optParam.smallCap [MCM]
                    x(3) = 50; % optParam.staticCap [MCM]
                    x(4) = g; % optParam.numFlex [#]
                    x(5) = h*10; % optParam.flexIncr
                    x(6) = false; % runParam.forwardSim
                    x(7) = z-1; % runParam.adaptiveOps: true or false
                    x(8) = 0; % costParam.discountrate
                    x(9) = 0.075; %0; % costParam.PercFlex
                    x(10) = 0.15; %0.5; % costParam.PercFlexExp

                    run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
                    val = V(1, 12, 1, 1); % 1st temperature state, 77 mm/mo
                    if val < bestVal_flex
                        bestVal_flex = val;
                        allV_flex = V;
                        bestAct_flex = x;
                        allX_flex = X;
                    end
                end
            end
        end
    end

    if z == 2
        file_name = strcat('Nov02optimal_dam_design/BestFlex_adaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex');
    elseif z == 1 
        file_name = strcat('Nov02optimal_dam_design/BestFlex_nonadaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex');
    end
    
    % 2. Find the optimal dam design for flexible planning
    bestVal_plan = inf;
    
    for j=50:10:140 % initial unexpanded dam sizes
        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h)
                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                    disp('Planned size not feasible');
                else
                    x(1) = 1; % optParam.optFlex: choose 1 for flexible design
                    x(2) = j; % optParam.smallCap [MCM]
                    x(3) = 50; % optParam.staticCap [MCM]
                    x(4) = g; % optParam.numFlex [#]
                    x(5) = h*10; % optParam.flexIncr
                    x(6) = false; % runParam.forwardSim
                    x(7) = z-1; % runParam.adaptiveOps: true or false
                    x(8) = 0; % costParam.discountrate
                    x(9) = 0; %0; % costParam.PercFlex
                    x(10) = 0.5; %0.5; % costParam.PercFlexExp

                    run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
                    val = V(1, 12, 1, 1); % 1st temperature state, 77 mm/mo
                    if val < bestVal_plan
                        bestVal_plan = val;
                        allV_plan = V;
                        bestAct_plan = x;
                        allX_plan = X;
                    end
                end
            end
        end
    end


    if z == 2
        file_name = strcat('Nov02optimal_dam_design/BestPlan_adaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan');
    elseif z == 1 
        file_name = strcat('Nov02optimal_dam_design/BestPlan_nonadaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan');
    end    
        
    %
    % 3. Find the optimal static dam size
    bestVal_static = inf;
    
    for j=50:10:150
        stateMsg = strcat('z=',num2str(z),', j=', num2str(j));
        disp(stateMsg)
        x(1) = 2; % optParam.optFlex: choose 2 for static design
        x(2) = 50; % optParam.smallCap
        x(3) = j; % optParam.staticCap       
        x(4) = 0; % optParam.numFlex
        x(5) = 0; % optParam.flexIncr
        x(6) = false; % runParam.forwardSim
        x(7) = z-1; % runParam.adaptiveOps: true or false
        x(8) = 0; % costParam.discountrate
        x(9) = 0.075; %0; % costParam.PercFlex
        x(10) = 0.15; %0.5; % % costParam.PercFlexExp
        
        run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
        val = V(1, 12, 1, 1);
        if val < bestVal_static
            bestVal_static = val;
            allV_static = V;
            bestAct_static = x;
            allX_static = X;
            
        end
    end
    
    if z == 2
        file_name = strcat('Nov02optimal_dam_design/BestStatic_adaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static');
    elseif z == 1
        file_name = strcat('Nov02optimal_dam_design/BestStatic_nonadaptive_cp6e6_g7_disc0');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static');
    end
    
    
    %
    % 4. Run the SDP and forward simulation with the optimal dam sizes
    
    % run twice: (1) with flexible design (2) with flexible planning
    
    for r=1:2 % (1) flexible design (2) flexible planning
    
    % get optimal values
    x(1) = 0; % optParam.optFlex: choose 0 for forward simulations
    x(3) = bestAct_static(3); % optParam.staticCap
    if r == 1
        x(2) = bestAct_flex(2); % optParam.smallCap
        x(4) = bestAct_flex(4); % optParam.numFlex
        x(5) = bestAct_flex(5); % optParam.flexIncr
        x(9) = 0.075; %0; % costParam.PercFlex
        x(10) = 0.15; %0.5; % costParam.PercFlexExp
    else
        x(2) = bestAct_plan(2); % optParam.smallCap
        x(4) = bestAct_plan(4); % optParam.numFlex
        x(5) = bestAct_plan(5); % optParam.flexIncr
        x(9) = 0; %0; % costParam.PercFlex
        x(10) = 0.5; %0.5; % costParam.PercFlexExp
    end
    x(6) = true; % runParam.forwardSim
    x(7) = z-1; % runParam.adaptiveOps: true or false
    x(8) = 0; % costParam.discountrate

    
    bestAct = x;
    
    run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
    
    if r == 1
        if z == 2
            file_name = strcat('Nov02optimal_dam_design/BestFlexStatic_adaptive_cp6e6_g7_disc0');
            save(file_name, 'bestAct', 'V', 'X','action', 'totalCostTime','damCostTime','C_state','P_state')
        elseif z == 1
            file_name = strcat('Nov02optimal_dam_design/BestFlexStatic_nonadaptive_cp6e6_g7_disc0');
            save(file_name, 'bestAct', 'V', 'X', 'action', 'totalCostTime','damCostTime','C_state','P_state')
        end
    else
        if z == 2
            file_name = strcat('Nov02optimal_dam_design/BestPlanStatic_adaptive_cp6e6_g7_disc0');
            save(file_name, 'bestAct', 'V', 'X','action', 'totalCostTime','damCostTime','C_state','P_state')
        elseif z == 1
            file_name = strcat('Nov02optimal_dam_design/BestPlanStatic_nonadaptive_cp6e6_g7_disc0');
            save(file_name, 'bestAct', 'V', 'X', 'action', 'totalCostTime','damCostTime','C_state','P_state')
        end
    end
    
    %run('multiflex_paper_plots_StaticFlex.m')
    
    end
end
