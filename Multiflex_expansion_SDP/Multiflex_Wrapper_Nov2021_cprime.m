%% Wrapper Function for Optimal Flexible Combinations
% November 2021
% For one set of transition matrices, do the following:
%   1. Find the optimal flexible design dam size
%   2. Find the optimal static dam size
%   4. Find the optimal flexible planned dam
%   3. Run the forward simulation with the optimal flex/static sizes

% This wrapper function script has been designed for Keani's analysis

clear all;
%close all;


if ~isempty(getenv('SLURM_JOB_ID'))
    projpath = '/home/users/keaniw/Fletcher_2019_Learning_Climate';
else
    projpath = '/Users/kcuw9/Documents/Mwache_Dam';
end
addpath(genpath(projpath))

jobid = getenv('SLURM_JOB_ID');
mkdir('Jan28optimal_dam_design_comb')

cps = [1.25e-6];

for c = 1:length(cps)
    c_prime = cps(c);

for z=1:2 % the adaptive and non-adaptive policies
    
% 1. Find the optimal flexible design dam size
    bestVal_flex = inf;
    
    for j=30:10:140 %200 %140 % initial unexpanded dam sizes
        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h)
                
                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                
                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                    disp('Flex design size not feasible');
                elseif (j+h*10*g) > 150 % place max on possible dam size
                    disp('Flex design size not feasible');
                else
                    x(1) = 1; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                    x(2) = 50; % optParam.staticCap: static dam size [MCM]
                    x(3) = j; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                    x(4) = g;  %optParam.numFlex: number of possible expansion capacities [#]
                    x(5) = h*10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
                    x(6) = 0.1; %costParam.PercFlex: initial upfront capital cost increase flex design
                    x(7) = 0.01; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
                    x(8) = 50; %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
                    x(9) = 1; %optParam.numPlan: number of possible expansion capacities [#]
                    x(10) = 10; %optParam.planIncr:
                    x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
                    x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
                    x(13) = false; %runParam.forwardSim: (1) forward sim (0) no forward sim
                    x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
                    x(15) = 0; %0.03; %costParam.discountrate
                    
                    run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
                    val = V(1, 12, 1, 1); % 1st temperature state, 77 mm/mo
                    if val < bestVal_flex
                        bestVal_flex = val;
                        allV_flex = V;
                        bestAct_flex = x;
                        allX_flex = X;
                        allVs_flex = Vs;
                        allVd_flex = Vd;
                        
                    end
                end
            end
        end
    end
    
    if z == 2
        file_name = strcat('Jan28optimal_dam_design_comb/BestFlex_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex','allVs_flex','allVd_flex');
    elseif z == 1
        file_name = strcat('Jan28optimal_dam_design_comb/BestFlex_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex','allVs_flex','allVd_flex');
    end
    
% 2. Find the optimal static dam size
    bestVal_static = inf;
    
    for j=30:10:150 %210 %150
        
        stateMsg = strcat('z=',num2str(z),', j=', num2str(j));
        disp(stateMsg)
        
        x(1) = 2; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
        x(2) = j; % optParam.staticCap: static dam size [MCM]
        x(3) = 50; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
        x(4) = 1;  %optParam.numFlex: number of possible expansion capacities [#]
        x(5) = 10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
        x(6) = 0.1; %costParam.PercFlex: initial upfront capital cost increase flex design
        x(7) = 0.01; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
        x(8) = 50; %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
        x(9) = 1; %optParam.numPlan: number of possible expansion capacities [#]
        x(10) = 10; %optParam.planIncr:
        x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
        x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
        x(13) = false; %runParam.forwardSim: (1) forward sim (0) no forward sim
        x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
        x(15) = 0; %0.03; %costParam.discountrate
        
        run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
        val = V(1, 12, 1, 1);
        if val < bestVal_static
            bestVal_static = val;
            allV_static = V;
            bestAct_static = x;
            allX_static = X;
            allVs_static = Vs;
            allVd_static = Vd;
            
        end
    end
    
    if z == 2
        file_name = strcat('Jan28optimal_dam_design_comb/BestStatic_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static','allVs_static','allVd_static');
    elseif z == 1
        file_name = strcat('Jan28optimal_dam_design_comb/BestStatic_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_static','bestVal_static','allV_static','allX_static','allVs_static','allVd_static');
    end
    
% 3. Find the optimal flexible planning dam size
    bestVal_plan = inf;
    
    for j=30:10:140 %200 %140

        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h)

                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                disp(stateMsg)
                
                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                    disp('Flex plan size not feasible');
                elseif (j+h*10*g) > 150 % place max on possible dam size
                    disp('Flex plan size not feasible');
                else
                    x(1) = 3; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                    x(2) = 50; % optParam.staticCap: static dam size [MCM]
                    x(3) = 50; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                    x(4) = 1;  %optParam.numFlex: number of possible expansion capacities [#]
                    x(5) = 10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
                    x(6) = 0.1; %costParam.PercFlex: initial upfront capital cost increase flex design
                    x(7) = 0.01; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
                    x(8) = j; %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
                    x(9) = g; %optParam.numPlan: number of possible expansion capacities [#]
                    x(10) = h*10; %optParam.planIncr:
                    x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
                    x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
                    x(13) = false; %runParam.forwardSim: (1) forward sim (0) no forward sim
                    x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
                    x(15) = 0; %0.03; %costParam.discountrate
                    
                    run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
                    val = V(1, 12, 1, 1);
                    if val < bestVal_plan
                        bestVal_plan = val;
                        allV_plan = V;
                        bestAct_plan = x;
                        allX_plan = X;
                        allVs_plan = Vs;
                        allVd_plan = Vd;
                        
                    end
                end
            end
        end
    end

    if z == 2
        file_name = strcat('Jan28optimal_dam_design_comb/BestPlan_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan','allVs_plan','allVd_plan');
    elseif z == 1
        file_name = strcat('Jan28optimal_dam_design_comb/BestPlan_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan','allVs_plan','allVd_plan');
    end
        
% 4. Run the SDP and forward simulation with the optimal dam sizes
    
    % get optimal values
    x(1) = 0; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
    x(2) = bestAct_static(2); % optParam.staticCap: static dam size [MCM]
    x(3) = bestAct_flex(3); %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
    x(4) = bestAct_flex(4);  %optParam.numFlex: number of possible expansion capacities [#]
    x(5) = bestAct_flex(5); %optParam.flexIncr: increment of flexible expansion capacities [MCM]
    x(6) = 0.1; %costParam.PercFlex: initial upfront capital cost increase flex design
    x(7) = 0.01; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
    x(8) = bestAct_plan(8); %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
    x(9) = bestAct_plan(9); %optParam.numPlan: number of possible expansion capacities [#]
    x(10) = bestAct_plan(10); %optParam.planIncr:
    x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
    x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
    x(13) = true; %runParam.forwardSim: (1) forward sim (0) no forward sim
    x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
    x(15) = 0; %0.03; %costParam.discountrate

    bestAct = x;
    
    run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
    if z == 2
        file_name = strcat('Jan28optimal_dam_design_comb/BestFlexStaticPlan_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct', 'V', 'X','action', 'totalCostTime','damCostTime','C_state','P_state','Vs','Vd')
    elseif z == 1
        file_name = strcat('Jan28optimal_dam_design_comb/BestFlexStaticPlan_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex10_percExp1_disc0');
        save(file_name, 'bestAct', 'V', 'X', 'action', 'totalCostTime','damCostTime','C_state','P_state','Vs','Vd')
    end
    
end
end