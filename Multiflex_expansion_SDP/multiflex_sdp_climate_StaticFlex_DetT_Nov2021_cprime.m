%% DOCUMENTATION:
% This is V6 of multiflex_sdp_climate_StaticFlex_DetT.m (date: 11/02/2021)

% DESCRIPTION:
% This script parallels the structure of the script sdp_climate.m. The
% current version of this script supports preloaded shortage costs to be 
% loaded within the script so that the dimensions of the shortage costs data is
% represents multiple flexible dam sizes(i.e., possible to set
% runParam.calcShortage = false).

% The updated SDP action space allows for dam expansion to optParam.numFlex number
% of possible flexible expansion capacities with expanded capacities increasing
% at an increment of optParam.flexIncr MCM  starting from the smallest
% capacity, optParam.smallCap. This script allows for a reactive and
% proactive dam expansion process to be considered.

% The capacity state space in the SDP now allows for: an optimal static option,
% an optimal planned dam option, an optimal initial flexible dam option with
% and optParam.numFlex different expanded flexible dam capacities at optParam.flexIncr
% increments of added capacity.

% OPTIMAL DAM SIZE FROM THE SDP: 
% if optParam.optFlex = 2, then the SDP forces the static dam option to
% be selected initially so that the value function in the SDP corresponds to the
% static dam.

% if optParam.optFlex = 1, then the SDP forces the flexible dam option to
% be selected initially so that the value function in the SDP corresponds to the
% flexible dams.

% if optParam.optFlex = 0, then the SDP does not force the flexible or static
% dam option to be selected initially (selects whatever is the best
% option). This is useful when selecting runParam.forwardSim = true.

% NOTE: 
% As calculation of the optimized reservoir operations via DDP 
% is computationally time intensive,it is recommended to run the script
% runParam.optReservoir = true only when runParam.calcShortage = false.)

% If using pre-saved shortage costs, shortage cost files for flexible dam
% will be created within the "calculate shortage cost section." Use
% runParam.calcShortage = false to use preloaded data contained in the
% folders 'post_process_nonopt_reservoir_results' and
% 'post_process_opt_reservoir_results.'

%% OPTIMAL DAM DESIGN SETUP 

% ================== SETUP FOR FINDING OPTIMAL DESIGN =====================
optParam = struct;
costParam = struct;

% specify whether the SDP should optimize for a flexible or static
% dam design. If (1), optimize design for a flexible dam. If (2),
% optimize the design for a static dam. If (3), optimize design for flexibly 
% planned dam. If (0), do not force dam design decision in time period N = 1.
optParam.optFlex = x(1); %0;

% ======================== OPTIMAL DAM DESIGNS ============================
% capacity values range 50:5:150 in the dam costmodel

% STATIC DAM
optParam.staticCap = x(2); % static dam size [MCM]

% FLEXIBLE DESIGN DAM
optParam.smallFlexCap = x(3); % unexpanded flexible design dam size [MCM]
optParam.numFlex = x(4);  % number of possible expansion capacities [#]
optParam.flexIncr = x(5); % increment of flexible expansion capacities [MCM]

% flexible design dam cost parameters
costParam.PercFlex = x(6); % Initial upfront capital cost increase (0.075)
costParam.PercFlexExp = x(7); % Expansion cost of flexible dam  (0.15)

% FLEXIBLE PLANNING DAM
optParam.smallPlanCap = x(8); % unexpanded flexible planning dam size [MCM]
optParam.numPlan = x(9); % MCM
optParam.planIncr = x(10);

% flexible planning dam cost parameters
costParam.PercPlan = x(11); % initial upfront capital cost increase (0);
costParam.PercPlanExp = x(12); % expansion cost of flexibly planned dam (0.5)


%% Climate change uncertainty stochastic dynamic program (SDP)

% This is the main script in the analysis: it integrates the Bayesian
% statitiscal model results, CLIRUN rainfall-runoff model, and water
% system/cost models into the forumulation of an SDP. The SDP develops
% optimal policies for 1) which of three infrastructure alternatives to
% choose in an initial planning period and 2) under what climate conditions
% to add capacity in a flexible planning process. Finally, it uses Monte
% Carlo simulation on the uncertain climate states to assess the peformance
% of the infrastructure policies developed by the SDP.


%% Setup 

% Set Project root folder and Add subfolders to path; runs either on desktop 
% or on a cluster using SLURM queueing system 
if ~isempty(getenv('SLURM_JOB_ID'))
    projpath = '/home/users/keaniw/Fletcher_2019_Learning_Climate';
else
    projpath = '/Users/kcuw9/Documents/Mwache_Dam';
end
addpath(genpath(projpath))

jobid = getenv('SLURM_JOB_ID');

% Get date for file name when saving results 
datetime=datestr(now);
datetime=strrep(datetime,':','_'); %Replace colon with underscore
datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore

%% Parameters

% Set up run parameters
% Two purposes: 1) different pieces can be run independently using
% saved results and 2) different planning scenarios (table 1) can be run

% ========================= GENERAL SCRIPT SETUP ==========================

runParam = struct;

% Number of time periods
runParam.N = 5; % Current SDP model requires N = 5 

% If true, run SDP to calculate optimal policies
runParam.runSDP = true; %x(9)

% Number of years to generate in T, P, streamflow time series
runParam.steplen = 20; 

% Set Emissions Scenario
emisScenario = {'RCP19' 'RCP26' 'RCP34' 'RCP45' 'RCP6' 'RCP7' 'RCP85'};
runParam.setPathway = emisScenario{7};

% If true, simulate runoff time series from T, P time series using CLIRUN. If false, load saved.
runParam.runRunoff = false; 

% If true, simulate T, P time series from mean T, P states using stochastic weather gen. If false, load saved.
runParam.runTPts = false; 

% If true, change indices of saved runoff time series to correspond to T, P states (needed for parfor implementation)
runParam.runoffPostProcess = false; 

% If true, use optimal policies from SDP to do Monte Carlo simulation to esimate performance
runParam.forwardSim = x(13);  %false;%

% If true, calculate Bellman transition matrix from BMA results. If false, load saved.
runParam.calcTmat = false; 

% If true, apply the adaptive reservoir operations policy via SDP in the water
% system model. If false, use the non-adaptive reservoir operations policy 
% via SDP
runParam.optReservoir = x(14);

% If true, calculate water shortage costs from runoff times series using water system model. If false, load saved.
runParam.calcShortage = false; 

% Urban water demand scenarios (low = 150,000; high = 300,000)[m3/d](Fletcher 2019)
runParam.domDemand = 186000; 

% If false, do not include deslination plant (planning scenarios A and B
% with current demand in table 1). If true, include desalination plant
% (planning scenario C with higher deamnd).
runParam.desalOn = false; 

% Size of desalination plant for small and large versions [MCM/y]
runParam.desalCapacity = [60 80];

% If using pre-saved runoff time series, name of .mat file to load
runParam.runoffLoadName = 'runoff_by_state_02Nov2021';

% If true, save results
runParam.saveOn = false;

% Set up climate parameters
climParam = struct;

%  Number of simulations to use in order to estimate absolute T and P
%  values based on relative difference from one time period to the next
climParam.numSamp_delta2abs = 100000;

% Number of T,P time series to generate using stochastic weather generator
climParam.numSampTS = 100;

% If true, test number of simulated climate values are outside the range of
% the state space in order to ensure state space validity
climParam.checkBins = false;

% Value of shortage penalty for domestic use [$/m3]
costParam.domShortage = 0.65; % Fletcher et al. (2019) utilized 5

% Value of shortage penalty for ag use [$/m3]
costParam.agShortage = 0.28; % Fletcher et al. (2019) utilized 0

% Use the parameter c' to scale the quadratic shortage cost formulation to
% reflect the average water unit cost reported by the FAO for Africa.
% for 3% discounting: c' = 6e-6
costParam.cPrime = c_prime; %7.65e-5;%Recent:4.85e-7; %V1: 1.6e-7; %1.85e-9; % [$/m^6];

% Discount rate
costParam.discountrate = x(15); %0.03;

%% SDP State and Action Definitions 

N = runParam.N;

% Define state space for mean 20-year precipitation and temperature
% output: 66 mm/month to 97 mm/month

% Percent change in precip from one time period to next
climParam.P_min = -.3;
climParam.P_max = .3;
climParam.P_delta = .02; 
s_P = climParam.P_min : climParam.P_delta : climParam.P_max;
climParam.P0 = s_P(15);
climParam.P0_abs = 77; %mm/month
M_P = length(s_P);

% Change in temperature from one time period to next
% output: 26.25, 26.75, 27.25, 27.95, 28.8 deg. C

climParam.T_delta = [0.5 0.5 0.7 0.85];
climParam.T0_abs = 26.25;
M_T = N;

% Absolute temperature values
T_abs_max = sum(climParam.T_delta);
s_T_abs(1) = climParam.T0_abs;
for i=1:N-1
    s_T_abs(i+1) = s_T_abs(i) + climParam.T_delta(i);
end
M_T_abs = length(s_T_abs);
T_Temp_abs = zeros(M_T_abs,M_T_abs,N);

% Absolute precip values
P_abs_max = max(s_P) * N;
s_P_abs = 66:1:97;
M_P_abs = length(s_P_abs);
P_bins = [s_P_abs-climParam.P_delta/2 s_P_abs(end)+climParam.P_delta/2];
T_Precip_abs = zeros(M_P_abs,M_P_abs,N);

% State space for capacity variables
s_C = 1:3+optParam.numFlex+optParam.numPlan; 
                            % 1 - static; 2 - flex, no exp; 3- flex planned, no exp
                            % 4:3+optParam.numFlex - flex, expanded to option X , 
                            % 4+optParam.numFlex:3+optParam.numFlex+optParam.numPlan
                            % - flex planned, expanded to option X
                            
M_C = length(s_C);

storage = zeros(1, M_C); 
storage(1) = optParam.staticCap; % added line
storage(2) = optParam.smallFlexCap; % edited line from (1) to (2)
storage(3) = optParam.smallPlanCap; 
% expansion from small capacity (2) to (3). Maximum dam capacity considered
% is 150 MCM by the World Bank for the Mwache Dam project.
storage(4:3+optParam.numFlex) = min(storage(2) + (1:optParam.numFlex)*optParam.flexIncr, 150);
storage(4+optParam.numFlex:end) = min(storage(3) + (1:optParam.numPlan)*optParam.planIncr, 150);

% Actions: Choose dam option in time period 1; expand dam in future time
% periods

a_exp = 0:3+optParam.numFlex+optParam.numPlan; 
% 0 - do nothing; 1 - build static;  2 - build flex; 3 - build flex plan;
% 4:3+optParam.numFlex - expand flex to option X; 4+optParam.numFlex:end - expand flex plan to option X; 
 
% Define infrastructure costs            
infra_cost = zeros(1,length(a_exp));
if ~runParam.desalOn
    
    % Planning scenarios A and B with current demand: only model dam
    
    % dam costs
    infra_cost(2) = storage2damcost(storage(1),0); % cost of static dam
    for i = 1:optParam.numFlex % cost of flexible design dam
        [infra_cost(3), infra_cost(i+4)] = storage2damcost(storage(2), ...
            storage(i+3),costParam.PercFlex, costParam.PercFlexExp); % cost of flexible design exp to option X
    end
    for i = 1:optParam.numPlan % cost of flexible plan dam
        [infra_cost(4), infra_cost(i+4+optParam.numFlex)] = storage2damcost(storage(3), ...
            storage(i+3+optParam.numFlex),costParam.PercPlan, costParam.PercPlanExp); % cost of flexible planning exp to option X
    end
        
    %for each expanded threshold, calculate (from small expansion to larger
    %expansion):
    flexexp = zeros(1,M_C-3);
    for i=1:optParam.numFlex % flexible design dam
        flexexp(i) = infra_cost(3) + infra_cost(4+i); %flexexp(i) = infra_cost(4) + infra_cost(4+i); % total expanded cost for each option
    end
    for i=1:optParam.numPlan % flexible plan dam
        flexexp(optParam.numFlex+i) = infra_cost(4) + infra_cost(4+optParam.numFlex+i); %flexexp(i) = infra_cost(4) + infra_cost(4+i); % total expanded cost for each option
    end
else
    
    % Planning scenario C: dam exists, make decision about new desalination plant
    % 6/16: Not updated
    % desal capital costs
    [infra_cost(2),~,opex_cost] = capacity2desalcost(runParam.desalCapacity(1),0); % small
    infra_cost(3) = capacity2desalcost(runParam.desalCapacity(2),0); % large
    [infra_cost(4), infra_cost(5)] = capacity2desalcost(runParam.desalCapacity(1), runParam.desalCapacity(2));  
    
    % desal capital costs two individual plants
    infra_cost(4) = infra_cost(2);
    infra_cost(5) = capacity2desalcost(runParam.desalCapacity(2) - runParam.desalCapacity(1),0);
end


  
%% Calculate climate transition matrix 

% Calculate the Bellman transition vector for the climate states using the
% Bayesian statistical model

if runParam.calcTmat
    load('BMA_results_RCP85_2020-11-14.mat')
    [T_Temp, T_Precip, ~, ~, ~, ~] = bma2TransMat( NUT, NUP, s_T, s_P, N, climParam);
    T_name = strcat('T_Temp_Precip_', runParam.setPathway) % save a different transition matrix file for different emissions pathways
    save(T_name, 'T_Temp', 'T_Precip')
else
    load('T_Temp_Precip_RCP85B', 'T_Precip') % updated from Jenny
    T_Temp = deterministicTempMatrix(N);
end

% Prune state space -- no need to calculate policies for T and P states
% that are never reached when simulating future climates based on Bayesian
% model
for t = 1:N
    index_s_p_time{t} = find(~isnan(T_Precip(1,:,t)));
    index_s_t_time{t} = find(~isnan(T_Temp(1,:,t)));
end


%% T, P, Runoff monthly time series for each long-term T, P state

% Use k-nn stochastic weather generator (Rajagopalan et al. 1999) to
% generate time series of monthly T and P based on 20-year means from state
% space

if runParam.runTPts

    T_ts = cell(M_T_abs,N);
    P_ts = cell(M_P_abs,N);

    [Tanom, Panom] = mean2TPtimeseriesMJL_2(1, runParam.steplen, climParam.numSampTS); 
    for t = 1:N

        for i = 1:M_T_abs  
            T_ts{i,t} = Tanom + s_T_abs(i)*ones(size(Tanom));
        end

        for i = 1:M_P_abs  
            Ptmp = Panom + s_P_abs(i)*ones(size(Tanom));
            Ptmp(Ptmp<0) = 0;
            P_ts{i,t} = Ptmp;
        end

    end

    savename_runoff = strcat('runoff_by_state_', jobid,'_', datetime);
    save(savename_runoff, 'T_ts', 'P_ts')

end


% Use CLIRUN hydrological model to simulate runoff monthly time series for
% each T,P time series

if runParam.runRunoff 

    % Generate runoff timeseries - different set for each T,P combination
    runoff = cell(M_T_abs, M_P_abs, N);


    % Set up parallel for running on cluster with SLURM queueing system
    pc = parcluster('local');
    if ~isempty(getenv('SLURM_JOB_ID'))
        parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')));
    end

    for t = 1

        % loop over available temp states
        index_s_t_thisPeriod = index_s_t_time{t}; 
        parfor i = 1:length(index_s_t_thisPeriod)
            index_s_t = index_s_t_thisPeriod(i);

            runoff_temp = cell(M_P_abs,1);

            % loop over available precip states
            index_s_p_thisPeriod = index_s_p_time{t}; 
            for index_s_p = index_s_p_thisPeriod

                % Call CLIRUN streamflow simulator
                runoff_temp{index_s_p} = ...
                    TP2runoff(T_ts{index_s_t,t}, P_ts{index_s_p,t}, runParam.steplen);

            end

            runoff(i, :, t) = runoff_temp;

        end
    end


    savename_runoff = strcat('runoff_by_state_', jobid,'_', datetime);
    save(savename_runoff, 'runoff', 'T_ts', 'P_ts')


    if runParam.runoffPostProcess
        % The nature of the parfor loop above saves the runoff timeseries in
        % first available index; this section moves to correct cell
        % corresponsing to P, T state space
        runoff_post = cell(M_T_abs, M_P_abs, N);
        for t = 1:N

            index_s_p_thisPeriod = index_s_p_time{t}; 
            for index_s_p = index_s_p_thisPeriod

                index_s_t_thisPeriod = index_s_t_time{t}; 
                for i= 1:length(index_s_t_thisPeriod)

                    runoff_post{index_s_t_thisPeriod(i),index_s_p,t} = runoff{i,index_s_p,t};

                end
            end
        end

        runoff = runoff_post;

        savename_runoff = strcat('runoff_by_state_', jobid,'_', datetime);
        save(savename_runoff, 'runoff', 'T_ts', 'P_ts')

    end

else

% If not calculating runoff now, load previously calculated runoff 
load(runParam.runoffLoadName);

end

%% Use reservoir operation model to calculate yield and shortage costs

if runParam.calcShortage

    unmet_ag = nan(M_T_abs, M_P_abs, length(storage), N);   % Unmet demand for agriculture use
    unmet_dom = nan(M_T_abs, M_P_abs, length(storage), N);  % Unmet demand for domestic use
    unmet_ag_squared = nan(M_T_abs, M_P_abs, length(storage), N); % Squared unmet agriculuture demands
    unmet_dom_squared = nan(M_T_abs, M_P_abs, length(storage), N); % Squared unmet domestic demands
    yield = nan(M_T_abs, M_P_abs, length(storage), N);  % Yield from reservoir
    desal = cell(M_T_abs, M_P_abs, length(storage));    % Production of desalinated water

    for t = 1 % Consider N = 1 assuming that the hydrological model and reservoir operations do not vary significantly between planning periods (N)
        
        index_s_p_thisPeriod = index_s_p_time{t}; 
        
        for index_s_p = 1:length(s_P_abs)

            index_s_t_thisPeriod = index_s_t_time{t}; 
            for index_s_t= 1:length(s_T_abs)

                for s = 1:length(storage) % for each capacity scenario, find shortage costs from operations
                    % Two options depending on planning scenario from Table
                    % 1: In scenarios A and B, with low demand, only the
                    % dam is modeled, and different levels of capacity in
                    % the state space corresponds to different reservoir
                    % volumes (desalOn = false). In scenario C, a
                    % desalination plant is modeled to support higher
                    % demand > MAR. In this case (desalOn = true), the
                    % state space corresponds to different desalination
                    % capacity volumes, assuming the large volume of
                    % reservoir storage.
                    
                    if ~runParam.desalOn
                        % vary storage, no desal
                        [yield_mdl, K, dmd, unmet_dom_mdl, unmet_ag_mdl, desalsupply, desalfill]  = ...
                            runoff2yield(runoff{index_s_t,index_s_p,t}, T_ts{index_s_t,t}, P_ts{index_s_p,t}, storage(s), 0, runParam, climParam, costParam);
                    else
                        % large storage, vary desal
                        [yield_mdl, K, dmd, unmet_dom_mdl, unmet_ag_mdl, desalsupply, desalfill]  = ...
                            runoff2yield(runoff{index_s_t,index_s_p,t}, T_ts{index_s_t,t}, P_ts{index_s_p,t}, storage(2), runParam.desalCapacity(s), runParam, climParam, costParam);
                    end
                    
                    % OMITTED: 'Calculate ummet demand, allowing for 10% of domestic demand
                    % to be unpenalized per 90% reliability goal(unmet_dom_90)'

                    unmet_ag(index_s_t, index_s_p, s, t) = mean(sum(unmet_ag_mdl,2));
                    unmet_dom(index_s_t, index_s_p, s, t) = mean(sum(unmet_dom_mdl,2));
                    unmet_ag_squared(index_s_t, index_s_p, s, t) = mean(sum(unmet_ag_mdl.^2,2)); 
                    unmet_dom_squared(index_s_t, index_s_p, s, t) = mean(sum(unmet_dom_mdl.^2,2)); 
                    yield(index_s_t, index_s_p, s, t) = mean(sum(yield_mdl,2));
                    if runParam.desalOn
                        desal{index_s_t, index_s_p, s} = desalsupply + desalfill;
                    end
                    
                end
                
                stateMsg = strcat('s_p =', num2str(index_s_p), '/ ', num2str(length(s_P_abs)), ', s_t=', num2str(index_s_t), '/  ',  num2str(length(s_T_abs)));
                disp(stateMsg)

            end
        end
    end
    
    % Calculate shortage costs incurred for unmet demand, using
    % differentiated costs for agriculture and domestic shortages and
    % quadratic formulation
    shortageCost =  (unmet_ag_squared * costParam.agShortage + unmet_dom_squared * costParam.domShortage) * 1E6; 
    
    % In planning scenario C with the desalination place, also calculate
    % discounted cost of oeprating the desalination plant
    if runParam.desalOn

        desal_opex = nan(M_T_abs, M_P_abs, length(storage), N);
        for t = 1:N
            discountfactor =  repmat((1+costParam.discountrate) .^ ((t-1)*runParam.steplen+1:1/12:t*runParam.steplen+11/12), 100, 1);
            desal_opex(:,:,:,t) = cell2mat(cellfun(@(x) mean(sum(opex_cost * x ./ discountfactor, 2)), desal, 'UniformOutput', false));
        end
        else
            desal_opex = [];
    end
    
    if runParam.saveOn
        savename_shortageCost = strcat('shortage_costs', jobid,'_', datetime);
        save(savename_shortageCost, 'shortageCost', 'yield', 'unmet_ag', 'unmet_dom', 'unmet_ag_squared', 'unmet_dom_squared','desal_opex')
    end
else % use the pre-calculated shortage cost files to fast-track calculations
    
    % Preallocate final shortage cost matrix
    shortageCost = NaN(M_T_abs, M_P_abs, length(storage), N);
    if runParam.optReservoir % shortage costs from adaptive reservoir operations via SDP
        for i=1:length(storage)
            s_state = string(storage(i));
            s_state_filename = strcat('sdp_adaptive_shortage_cost_s',s_state,'.mat');
            shortageCostDir = load(s_state_filename,'shortageCost');
            shortageCost_s_state = shortageCostDir.shortageCost(:,18:49);
            shortageCost(:,:,i,1) = shortageCost_s_state;
        end
    else % shortage costs from non-adaptive reservoir operations via SDP
        for i=1:length(storage)
            s_state = string(storage(i));
            s_state_filename = strcat('sdp_nonadaptive_shortage_cost_s',s_state,'.mat');
            shortageCostDir = load(s_state_filename,'shortageCost');
            shortageCost_s_state = shortageCostDir.shortageCost(:,18:49);
            shortageCost(:,:,i,1) = shortageCost_s_state;
        end
    end
end

%% Solve SDP optimal policies using backwards recursion

if runParam.runSDP

% multiply by c' parameter for economic cost model
shortageCost = shortageCost.*costParam.cPrime;

% Initialize best value and best action matrices
% Temperature states x precipitaiton states x capacity states, time
V = NaN(M_T_abs, M_P_abs, M_C, N+1);
Vs = NaN(M_T_abs, M_P_abs, M_C, N+1);
Vd = NaN(M_T_abs, M_P_abs, M_C, N+1);
X = NaN(M_T_abs, M_P_abs, M_C, N);
Vs_nondisc = NaN(M_T_abs, M_P_abs, M_C, N+1);
Vd_nondisc = NaN(M_T_abs, M_P_abs, M_C, N+1);

% Terminal period
V(:,:,:,N+1) = zeros(M_T_abs, M_P_abs, M_C, 1);
Vs(:,:,:,N+1) = zeros(M_T_abs, M_P_abs, M_C, 1);
Vd(:,:,:,N+1) = zeros(M_T_abs, M_P_abs, M_C, 1);
Vs_nondisc(:,:,:,N+1) = zeros(M_T_abs, M_P_abs, M_C, 1);
Vd_nondisc(:,:,:,N+1) = zeros(M_T_abs, M_P_abs, M_C, 1);

% Loop over all time periods
for t = linspace(N,1,N)
    
    % Calculate nextV    
    nextV = V(:,:,:,t+1);
    nextVs = Vs(:,:,:,t+1);
    nextVd = Vd(:,:,:,t+1);
    nextVs_nondisc = Vs_nondisc(:,:,:,t+1);
    nextVd_nondisc = Vd_nondisc(:,:,:,t+1);
    
    % Loop over all states
    
    % Loop over temperature state
    index_s_t_thisPeriod = index_s_t_time{t}; 
    for index_s_t = index_s_t_thisPeriod
        st = s_T_abs(index_s_t);
        
        % Loop over precipitation state
        index_s_p_thisPeriod = index_s_p_time{t}; 
        for index_s_p = index_s_p_thisPeriod
            sp = s_P_abs(index_s_p);
       
            % Loop over capacity expansion state
            for index_s_c = 1:M_C
                sc = s_C(index_s_c);

                bestV = Inf;  % Best value
                bestX = 0;  % Best action

                % Update available actions based on time and whether expansion available
                
                % In first period decide what dam to build
                if t == 1
                    if optParam.optFlex == 1 % flexible dam design
                        a_exp_thisPeriod = 2; % force building of flexible dam design at N = 1
                    elseif optParam.optFlex == 2 % static dam
                        a_exp_thisPeriod = 1; % force building of static dam at N = 1
                    elseif optParam.optFlex == 3 % flexibly planned dam
                        a_exp_thisPeriod = 3; % force building flexibly planned dam at N = 1
                    elseif optParam.optFlex == 0 % flexible design, planning, or static (whatever is best option)
                        a_exp_thisPeriod = 1:3; % build a static, flex design, or flex plan dam
                    end
                else
                    % In later periods decide whether to expand or not if available
                    switch sc
                        case s_C(1) % static 
                            a_exp_thisPeriod = [0];
                        case s_C(2) % Flex design, not expanded
                            a_exp_thisPeriod = [0 a_exp(5:4+optParam.numFlex)]; % not expand or expand to options X
                        case s_C(3) % Flex planning, not expanded
                            a_exp_thisPeriod = [0 a_exp(5+optParam.numFlex:end)]; % not expand or expand to option X
                        otherwise % Flex design or planning, any expanded option (can only expand once)
                            a_exp_thisPeriod = [0];
                    end
                end
                num_a_exp = length(a_exp_thisPeriod);

                % Loop over expansion action
                for index_a = 1:num_a_exp
                    a = a_exp_thisPeriod(index_a);
                    
                    stateMsg = strcat('t=', num2str(t), ', st=', num2str(st), ', sp=', num2str(sp), ', sc=', num2str(sc), ', a=', num2str(a));
                    disp(stateMsg)

                    % Calculate costs 
                    
                    % Select which capacity is currently available
                    if sc == 1 
                        short_ind = 1;  % static capacity  
                    elseif sc == 2 
                        short_ind = 2; % flex design capacity
                    elseif sc == 3
                        short_ind = 3; % flex planning capacity
                    else
                        short_ind = sc; % intermediate capacity X
                    end

                    % In first time period, assume have dam built
                    if t == 1
                        if a == 2
                            short_ind = 2; % unexpanded flex design capacity
                        elseif a == 1 
                            short_ind = 1; % static capacity
                        elseif a == 3
                            short_ind = 3; % unexpanded flex planning capacity
                        end
                    end
                    
                    % Assume new expansion capacity comes online this period
                    if (a ~= 0) && (a ~=1) && (a ~=2) && (a ~=3)
                        short_ind = a; % expanded capacity index
                    end
                    
                    sCost = shortageCost(index_s_t, index_s_p, short_ind, 1);
                    if t == 1 
                        sCost = 0;  % This is upfront building period
                    end
                  
                    ind_dam = find(a == a_exp);
                    dCost = infra_cost(ind_dam);
                    cost = (sCost + dCost) / (1+costParam.discountrate)^((t-1)*runParam.steplen+1);
                    if runParam.desalOn
                        opex = desal_opex(index_s_t, index_s_p, short_ind, t);
                    else
                        opex = 0;
                    end
                    cost = cost + opex;
                    
                     % keep track of discounted dam costs and shortage costs
                    dCostD = (dCost) / (1+costParam.discountrate)^((t-1)*runParam.steplen+1);
                    sCostD = (sCost) / (1+costParam.discountrate)^((t-1)*runParam.steplen+1);
                     
                                      
                   
                    % Calculate transition matrix
                    
                    % Capacity transmat vector
                    T_cap = zeros(1,M_C);
                    if t == 1
                        % In first time period, get whatever dam you picked
                        T_cap(a) = 1;
                    else
                        % Otherwise, either stay in current or move to expanded
                        switch a
                            case 0
                                T_cap(sc) = 1;
                            case num2cell(4:a_exp(end)) % different expansion cases
                                T_cap(a) = 1;
                        end                         
                    end

                    % Temperature transmat vector
                    T_Temp_row = T_Temp(:,index_s_t, t)';
                    if sum(isnan(T_Temp_row)) > 0
                        error('Nan in T_Temp_row')
                    end
                    
                    % Precipitation transmat vector
                    T_Precip_row = T_Precip(:,index_s_p, t)';
                    if sum(isnan(T_Precip_row)) > 0
                        error('Nan in T_Precip_row')
                    end
                    
                    % Calculate full transition matrix
                    % Assumes state variables are uncorrelated
                    % T gives probability of next state given current state and actions

                    TRows = cell(3,1);
                    TRows{1} = T_Temp_row;
                    TRows{2} = T_Precip_row;
                    TRows{3} = T_cap;
                    [ T ] = transrow2mat( TRows );

                     % Calculate expected future cost or percentile cost
                    indexNonZeroT = find(T > 0);
                    expV = sum(T(indexNonZeroT) .*nextV(indexNonZeroT));
                    expVs = sum(T(indexNonZeroT) .*nextVs(indexNonZeroT));
                    expVd = sum(T(indexNonZeroT) .*nextVd(indexNonZeroT));
                    expVs_nondisc = sum(T(indexNonZeroT) .*nextVs_nondisc(indexNonZeroT));
                    expVd_nondisc = sum(T(indexNonZeroT) .*nextVd_nondisc(indexNonZeroT));
                    for i = 2:4
                        expV = sum(expV);
                        expVs = sum(expVs);
                        expVd = sum(expVd);
                        expVs_nondisc = sum(expVs_nondisc);
                        expVd_nondisc = sum(expVd_nondisc);                        
                    end
                    
                   % Check if best decision
                    checkV = cost + expV;
                    if checkV < bestV
                        bestV = checkV;
                        bestX = a;
                        bestVs = sCostD + expVs; % save expected shortage and dam costs separately
                        bestVd = dCostD + expVd;
                        bestVs_nondisc = sCost + expVs_nondisc; % save expected shortage and dam costs separately
                        bestVd_nondisc = dCost + expVd_nondisc;
                    end
                                        
                end
            
            % Check that bestV is not Inf
            if bestV == Inf
                error('BestV is Inf, did not pick an action')
            end

            % Save best value and action for current state
            V(index_s_t, index_s_p,index_s_c, t) = bestV;
            X(index_s_t, index_s_p,index_s_c, t) = bestX;
            Vs(index_s_t, index_s_p,index_s_c, t) = bestVs; % shortage value function
            Vd(index_s_t, index_s_p,index_s_c, t) = bestVd; % infrastructure/dam value function
            Vs_nondisc(index_s_t, index_s_p,index_s_c, t) = bestVs_nondisc; % shortage value function
            Vd_nondisc(index_s_t, index_s_p,index_s_c, t) = bestVd_nondisc; % infrastructure/dam value function
            end
        end
    end
end

if runParam.saveOn
    
    savename_results = strcat('results', jobid,'_', datetime);
    save(savename_results)
    
end


end

%% Forward simulation

% Use optimal expansion policy derived from SDP to simulate performance of
% flexible alternative and compare to small and large alternatives

% 4 runs: static, flex design, flex planning, best policy

if runParam.forwardSim
        
R = 10000; % Number of forward Monte Carlo simulations
N = runParam.N; % Number of time periods
S = 4; % Number of run options (static, flex design, flex plan, policy)

% set constant random numbers for climate state transitions such that
% forward simulations can be compared. Use default random generator type
% 'twister' and random seed 0. See use of variable p in forward
% simulations.
rng(0,'twister') % set seed
p_vals = rand(R,N);

T_state = zeros(R,N);
P_state = zeros(R,N);
C_state = zeros(R,N,S);
action = zeros(R,N,S);
damCostTime = zeros(R,N,S);
shortageCostTime = zeros(R,N,S);
opexCostTime = zeros(R,N,S);
totalCostTime = zeros(R,N,S); 

load('BMA_results_RCP85_2020-11-14.mat', 'MUP') % previously: 'BMA_results_deltap05T_p2P07-Feb-2018 20:18:49.mat'
indT0 = find(s_T_abs == climParam.T0_abs);
indP0 = find(s_P_abs == climParam.P0_abs);
P0samp = MUP(:,1,indP0);
P0samp = exp(P0samp)* climParam.P0_abs;
rng(3,'twister') % set seed
indsamp = randi(1000,R,1);
P0samp = P0samp(indsamp);
T0samp = round2x(s_T_abs(1), s_T_abs);
P0samp = round2x(P0samp, s_P_abs);

T_state(:,1) = T0samp;
P_state(:,1) = P0samp;
C_state(:,1,1) = 2; % Always flex design
C_state(:,1,2) = 1; % Always static
C_state(:,1,3) = 3; % Always flex planned
C_state(:,1,4) = 1; % Choose based on policy (?)

for i = 1:R
    for t = 1:N
        
        % Choose best action given current state
            index_t = find(T_state(i,t) == s_T_abs);
            index_p = find(P_state(i,t) == s_P_abs);
            
        
        % Temperature transmat vector
            T_Temp_row = T_Temp(:,index_t, t)';
            if sum(isnan(T_Temp_row)) > 0
                error('Nan in T_Temp_row')
            end

            % Precipitation transmat vector
            T_Precip_row = T_Precip(:,index_p, t)';
            if sum(isnan(T_Precip_row)) > 0
                error('Nan in T_Precip_row')
            end
        
        for k = 1:4
            
            index_c = find(C_state(i,t,k) == s_C); % (?)
            % In flex case follow exp policy, otherwise restrict to large or
            % small and then no exp
            if t==1
                switch k
                    case 1
                        action(i,t,k) = 2; % flex design 
                    case 2
                        action(i,t,k) = 1; % static
                    case 3
                        action(i,t,k) = 3; % flex planning
                    case 4
                        action(i,t,k) =  X(index_t, index_p, index_c, t); % pick best option
                end
            else 
                switch k
                    case 1
                        action(i,t,k) = X(index_t, index_p, index_c, t); % flex design
                    case 2
                        action(i,t,k) = 0; % static
                    case 3 
                        action(i,t,k) =  X(index_t, index_p, index_c, t); %flex planning
                    case 4
                        action(i,t,k) =  X(index_t, index_p, index_c, t); % pick best option
                end
            end
            
            % Save costs of that action

            % Get current capacity and action
            sc = C_state(i,t,k); %for the first time period, either 1,2, or 3
            a = action(i,t,k);

            % Select which capacity is currently available
            if sc == 1 
                short_ind = 1;  % static capacity  
            elseif sc == 2 
                short_ind = 2; % flex design capacity
            elseif sc == 3
                short_ind = 3; % flex planning capacity
            else
                short_ind = sc; % intermediate expanded capacity           
            end

            % In first time period, assume have dam built
            if t == 1
                if a == 2
                    short_ind = 2; % flex design capacity 
                elseif a == 1 
                    short_ind = 1;    % static capacity
                else
                    short_ind = 3; % flex planning capacity 
                end
            end
            
            % Assume new expansion capacity comes online this period
            if (a ~= 0) && (a ~=1) && (a ~=2) && (a~=3)
                short_ind = a; % expanded capacity index
            end

            % Get shortage and dam costs
            shortageCostTime(i,t,k) = shortageCost(index_t, index_p, short_ind, 1)  / (1+costParam.discountrate)^((t-1)*runParam.steplen+1);
            if t == 1 
                shortageCostTime(i,t,k) = 0;  % This is upfront building period
            end
            ind_dam = find(a == a_exp);
            damCostTime(i,t,k) = infra_cost(ind_dam)  / (1+costParam.discountrate)^((t-1)*runParam.steplen+1);
            if runParam.desalOn
                opexCostTime(i,t,k) = desal_opex(index_t, index_p, short_ind, t);
            end
            totalCostTime(i,t,k) = (shortageCostTime(i,t,k) + damCostTime(i,t,k));
            totalCostTime(i,t,k) = totalCostTime(i,t,k) + opexCostTime(i,t,k);
            
            % Simulate transition to next state
            % Capacity transmat vector
            T_cap = zeros(1,M_C);
            if t == 1
                % In first time period, get whatever dam you picked
                T_cap(a) = 1;
            else
                % Otherwise, either stay in current or move to expanded
                switch a %(?)
                    case 0
                        T_cap(sc) = 1;
                    case num2cell(4:a_exp(end)) % different expansion cases
                        T_cap(a) = 1;
                end
            end

            
            % Combine trans vectors into matrix
            TRows = cell(3,1);
            TRows{1} = T_Temp_row;
            TRows{2} = T_Precip_row;
            TRows{3} = T_cap;
            [ T_current ] = transrow2mat( TRows );

            % Simulate next state
            if t < N
                T_current_1D = reshape(T_current,[1 numel(T_current)]);
                T_current_1D_cumsum = cumsum(T_current_1D);
                %p = rand();
                p = p_vals(i,t); % so that forward simulations are consistent
                index = find(p < T_current_1D_cumsum,1);
                [ind_s1, ind_s2, ind_s3] = ind2sub(size(T_current),index);
                    % Test sample
                    margin = 1e-10;
                    if (T_current(ind_s1, ind_s2, ind_s3) < margin)
                        error('Invalid sample from T_current')
                    end
                
                if k == 1
                    T_state(i,t+1,k) = s_T_abs(ind_s1);
                    P_state(i,t+1,k) = s_P_abs(ind_s2);
                end
                C_state(i,t+1,k) = s_C(ind_s3);

            end



        end

    end
end


if runParam.saveOn
    
    savename_results = strcat('results', jobid,'_', datetime);
    save(savename_results)
    
end


end
