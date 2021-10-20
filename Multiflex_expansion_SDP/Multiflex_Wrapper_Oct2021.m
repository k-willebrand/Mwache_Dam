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
mkdir('Oct17optimal_dam_design')


% 1. Find the optimal flexible dam size
bestVal_flex = inf;

for z=1:2 % the adaptive and non-adaptive policies

    % 1. Find the optimal flexible dam size
    for j=50:10:140 % initial unexpanded dam sizes
        for h=1:2 % flex expansion increments
            for g=1:5 % number of flex expansion(7-2*h) 
                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                
                x(1) = 1; % optParam.optFlex: choose 1 for flexible design
                x(2) = j; % optParam.smallCap [MCM]
                x(3) = 50; % optParam.staticCap [MCM]
                x(4) = g; % optParam.numFlex [#]
                x(5) = h*10; % optParam.flexIncr
                x(6) = false; % runParam.forwardSim
                x(7) = z-1; % runParam.adaptiveOps: true or false
                x(8) = 0.03; % costParam.discountrate
                x(9) = 0.075; % costParam.PercFlex
                x(10) = 0.15; % costParam.PercFlexExp
                
                run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
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
    % old_path = '/Users/jenniferskerker/Documents/GradSchool/Research/Project1/Code/Models/Fletcher_2019_Learning_Climate/Bayesian_Quant_Learning';
    % cd(old_path);
    % mkdir(TM);
    % new_path = strcat(old_path, '/', TM);
    % cd(new_path);
    if z == 2
        file_name = strcat('Oct17optimal_dam_design/BestFlex_adaptive');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex');
    elseif z == 1 
        file_name = strcat('Oct17optimal_dam_design/BestFlex_nonadaptive');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex');
    end
    
    %
    % 2. Find the optimal static dam size
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
        x(8) = 0.03; % costParam.discountrate
        x(9) = 0.075; % costParam.PercFlex
        x(10) = 0.15; % costParam.PercFlexExp
        
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
        file_name = strcat('Oct17optimal_dam_design/BestStatic_adaptive');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static');
    elseif z == 1
        file_name = strcat('Oct17optimal_dam_design/BestStatic_nonadaptive');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static');
    end
    
    
    %
    % 3. Run the SDP and forward simulation with the optimal dam sizes
    
    % get optimal values
    x(1) = 0; % optParam.optFlex: choose 0 for forward simulations
    x(2) = bestAct_flex(2); % optParam.smallCap
    x(3) = bestAct_static(3); % optParam.staticCap
    x(4) = bestAct_flex(4); % optParam.numFlex
    x(5) = bestAct_flex(5); % optParam.flexIncr
    x(6) = true; % runParam.forwardSim
    x(7) = z-1; % runParam.adaptiveOps: true or false
    x(8) = 0.03; % costParam.discountrate
    x(9) = 0.075; % costParam.PercFlex
    x(10) = 0.15; % costParam.PercFlexExp
    
    bestAct = x;
    
    run('multiflex_sdp_climate_StaticFlex_DetT_Oct2021');
    if z == 2
        file_name = strcat('Oct17optimal_dam_design/BestFlexStatic_adaptive');
        save(file_name, 'bestAct', 'V', 'X')
    elseif z == 1
        file_name = strcat('Oct17optimal_dam_design/BestFlexStatic_nonadaptive');
        save(file_name, 'bestAct', 'V', 'X')
    end

    run('multiflex_paper_plots_StaticFlex.m')
    
end