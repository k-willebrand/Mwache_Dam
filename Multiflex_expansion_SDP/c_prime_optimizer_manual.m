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
%mkdir('May07optimal_dam_design_comb')
%mkdir('Mar23optimal_dam_design_comb')

% initialize cost model parameters:
cps = [6.79E-08 6.93E-08 1.28E-07 1.43E-07 2.00E-07 2.20E-07 3.13E-07 4.07E-07 5.63E-07 7.82E-07 1.07E-06 1.19E-06 1.44E-06 1.63E-06 1.88E-06 2.19E-06];%[1.25E-06];
discounts = [0];
x_6 = 5; %costParam.PercFlex: initial upfront capital cost increase flex design
x_7 = 1; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
x_11 = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
x_12 = 50; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)

% preallocate SDP costs
val_static = zeros(11,2);
Vs_static = zeros(11,2);
Vd_static = zeros(11,2);
val_flex = zeros(10,2);
Vs_flex = zeros(10,2);
Vd_flex = zeros(10,2);
val_plan = zeros(10,2);
Vs_plan = zeros(10,2);
Vd_plan = zeros(10,2);

tab = zeros(length(cps),2);

for d = 1:length(discounts)
    disc = discounts(d);
    
for c = 1:length(cps)
    c_prime = cps(c);

for z=1%:2 % the adaptive and non-adaptive policies
    
    
% 2. Find the optimal flexible design dam size
    bestVal_flex = inf;
    count = 1;
    stateMsg = strcat('Flex: cp=',string(c_prime),'z=',num2str(z));
    disp(stateMsg)
    
    for j=50:10:150 %30:10:120 %200 %140 % initial unexpanded dam sizes
        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h)
                
                stateMsg = strcat('cp=',string(c_prime),'z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                %disp(stateMsg)
                
                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                if (j+h*10*g) > ceil(1.5*j/10)*10
                     %disp('Flex design size not feasible');
                elseif (j+h*10*g) > 150 %120 % place max on possible dam size
                    %disp('Flex design size not feasible');
                %elseif (j+h*10*g) ~= ceil(1.5*j/10)*10
                %    disp('Flex design size not feasible');
                elseif ((j+h*10*g) == ceil(1.5*j/10)*10) || ((j+h*10*g) == 150) % max initial dam 80 MCM
                    x(1) = 1; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                    x(2) = 50; % optParam.staticCap: static dam size [MCM]
                    x(3) = j; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                    x(4) = g;  %optParam.numFlex: number of possible expansion capacities [#]
                    x(5) = h*10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
                    x(6) = x_6/100; %costParam.PercFlex: initial upfront capital cost increase flex design
                    x(7) = x_7/100; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
                    x(8) = 50; %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
                    x(9) = 1; %optParam.numPlan: number of possible expansion capacities [#]
                    x(10) = 10; %optParam.planIncr:
                    x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
                    x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
                    x(13) = false; %runParam.forwardSim: (1) forward sim (0) no forward sim
                    x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
                    x(15) = disc/100; %0.03; %costParam.discountrate
                    
                    run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
                    val = V(1, 12, 1, 1)/1E6; % 1st temperature state, 77 mm/mo
                    val_flex(count,z) = V(1, 12, 1, 1)/1E6;
                    Vs_flex(count,z) = Vs(1, 12, 1, 1)/1E6;
                    Vd_flex(count,z) = Vd(1, 12, 1, 1)/1E6;
                    count = count + 1;
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
    
    bestAct_flex(3)
    tab(c,1) = bestAct_flex(3);
    if z == 2
        file_name = strcat('May07optimal_dam_design_comb/BestFlex_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex',regexprep(strrep(string(x_6), '.', ''), {'-0'}, {''}),'_percExp',regexprep(strrep(string(x_7), '.', ''), {'-0'}, {''}),'_disc',string(disc),'_50PercExpCapOr150');
        %save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex','allVs_flex','allVd_flex');
    elseif z == 1
        file_name = strcat('May07optimal_dam_design_comb/BestFlex_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex',regexprep(strrep(string(x_6), '.', ''), {'-0'}, {''}),'_percExp',regexprep(strrep(string(x_7), '.', ''), {'-0'}, {''}),'_disc',string(disc),'_50PercExpCapOr150');
        %save(file_name, 'bestAct_flex','bestVal_flex','allV_flex','allX_flex','allVs_flex','allVd_flex');
    end
    
    
% 3. Find the optimal flexible planning dam size
    bestVal_plan = inf;
    count = 1;
    stateMsg = strcat('Plan: cp=',string(c_prime),'z=',num2str(z));
    disp(stateMsg)
    
    for j=50:10:150 %200 %140

        for h=1 % flex expansion increments
            for g=1:7 % number of flex expansion(7-2*h)

                stateMsg = strcat('cp=',string(c_prime),'z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                    num2str(h));
                %disp(stateMsg)
                
                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                if (j+h*10*g) > ceil(1.5*j/10)*10
                     %disp('Flex plan size not feasible');
                elseif (j+h*10*g) > 150 %150 % place max on possible dam size
                    %disp('Flex plan size not feasible');
                %elseif (j+h*10*g) ~= ceil(1.5*j/10)*10
                %    disp('Flex plan size not feasible');
                elseif ((j+h*10*g) == ceil(1.5*j/10)*10) || ((j+h*10*g) == 150) % if =50% initial capacity or 150 MCM
                    x(1) = 3; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                    x(2) = 50; % optParam.staticCap: static dam size [MCM]
                    x(3) = 50; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                    x(4) = 1;  %optParam.numFlex: number of possible expansion capacities [#]
                    x(5) = 10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
                    x(6) = x_6/100; %costParam.PercFlex: initial upfront capital cost increase flex design
                    x(7) = x_7/100; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
                    x(8) = j; %optParam.smallPlanCap: unexpanded flexible plan dam size [MCM]
                    x(9) = g; %optParam.numPlan: number of possible expansion capacities [#]
                    x(10) = h*10; %optParam.planIncr:
                    x(11) = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
                    x(12) = 0.5; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
                    x(13) = false; %runParam.forwardSim: (1) forward sim (0) no forward sim
                    x(14) = z-1; %runParam.adaptiveOps: (1) adaptive operations (0) non-adaptive operations
                    x(15) = disc/100; %0.03; %costParam.discountrate
                    
                    run('multiflex_sdp_climate_StaticFlex_DetT_Nov2021_cprime');
                    val = V(1, 12, 1, 1)/1E6;
                    val_plan(count,z) = V(1, 12, 1, 1)/1E6;
                    Vs_plan(count,z) = Vs(1, 12, 1, 1)/1E6;
                    Vd_plan(count,z) = Vd(1, 12, 1, 1)/1E6;
                    count = count + 1;
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
    
    bestAct_plan(8)
    tab(c,2) = bestAct_plan(8);
    if z == 2
        file_name = strcat('May07optimal_dam_design_comb/BestPlan_adaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex',regexprep(strrep(string(x_6), '.', ''), {'-0'}, {''}),'_percExp',regexprep(strrep(string(x_7), '.', ''), {'-0'}, {''}),'_disc',string(disc),'_50PercExpCapOr150');
        %save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan','allVs_plan','allVd_plan');
    elseif z == 1
        file_name = strcat('May07optimal_dam_design_comb/BestPlan_nonadaptive_cp', regexprep(strrep(string(c_prime), '.', ''), {'-0'}, {''}),'_g7_percFlex',regexprep(strrep(string(x_6), '.', ''), {'-0'}, {''}),'_percExp',regexprep(strrep(string(x_7), '.', ''), {'-0'}, {''}),'_disc',string(disc),'_50PercExpCapOr150');
        %save(file_name, 'bestAct_plan','bestVal_plan','allV_plan','allX_plan','allVs_plan','allVd_plan');
    end
        

    
end
end
end