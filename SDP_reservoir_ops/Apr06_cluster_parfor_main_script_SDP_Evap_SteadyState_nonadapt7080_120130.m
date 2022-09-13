%% SDP RESERVOIR OPERATIONS - CALCULATE SHORTAGE COSTS
% THIS IS THE MAIN SCRIPT UTILIZED TO RUN THE ADAPTIVE AND NON-ADAPTIVE
% RESERVOIR OPERATIONS ON THE CLUSTER (Oct. 20, 2021)

% This version of the script is parallized and can be run on the HPC cluster.

% SDP implemenation to design the optimal operating policy for different
% storage capacities for the Mwache Dam in Mombasa, Kenya.
% (adapted from M3O toolbox)

% DESCRIPTION:
% Calculate shortage costs and unmet demands using an SDP adaptive or
% non-adaptive operating policy. To run this script, update the storage
% values (can be an array), date, and filepath. Set the values for runParam,
% costParam, climParam, and sys_param fields accordingly.

% NOTE: For climate-adaptive operations, set runParam.adaptiveOps = true
% else set runParam.adaptiveOps = false. Set runParam.adaptiveOps in
% outside and within the parallized loop.

%% Set file path

clear all;
%clc

%cd('C:/Users/kcuw9/Documents/Fletcher_2019_Learning_Climate/SDP_reservoir_ops')

if ~isempty(getenv('SLURM_JOB_ID'))
    projpath = '/home/users/keaniw/Fletcher_2019_Learning_Climate';
    jobid = getenv('SLURM_JOB_ID');
else
    projpath = 'C:/Users/kcuw9/Documents/Mwache_Dam';
    jobid = 'na';
end

addpath(genpath(projpath))
mkdir('Apr06sdp_reservoir_ops_SteadyState')

addpath('data')
addpath('SDP_code')
addpath('SDP_reservoir_ops')

%% Set run parameters for shortage cost calculations

% Define reservoir capacities (can be an array of capacities)
storage_vals = [70 80 120 130]; % set reservoir capacities (MCM)

date = '040622'; % set date for save name

% Keani works with 66 to 97 mm/month; Jenny considers 49 to 119 mm/month
s_T_abs = [26.25, 26.75, 27.25, 27.95, 28.8]; % deg. C
s_P_abs = 49:1:119; % expanded state space [mm/month]
%s_P_abs = 66:1:97; % unexpanded state space [mm/month]

%load('runoff_by_state_02Nov2021.mat'); % Jenny's final updated de-trended data [49:1:119] mm/month
load('Runoff_NoExtremes_98perc_6Apr2022');

% number of temperature and precipation states to calculate shortage costs
num_T_states = size(runoff,1); % temperature states
s_P_subset = [58,62,66,70,74,78]; % subset of precipitation states to test
%num_P_states = size(runoff,2); % precipitation states
num_P_states = length(s_P_subset); % precipitation states

if ~isempty(getenv('SLURM_JOB_ID'))
    %poolobj = parpool('local', str2num(getenv('SLURM_NTASKS')));
    poolobj = parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')));
    fprintf('Number of workers: %g\n', poolobj.NumWorkers)
end

% Define total reservoir capacity and dead storage (MCM)
for ss=1:length(storage_vals)
    
    storage = storage_vals(ss); % reservoir capacity (MCM)
    dead_storage = 20; % MCM
    
    parfor s_P = 1:num_P_states %18:49 %1:num_P_states
        
        %P_state = s_P;
        P_state = find(s_P_abs == s_P_subset(s_P));
        
        %% calculate average shortage costs from the optimal policy for each climate state
        
        for s_T = 1:num_T_states
            
            T_state = s_T;
            disp(strcat('s: ', string(storage),' s_T:   ',string(s_T),' s_P:   ',string(s_P)));
            
            % Define adaptive or non-adaptive operations
            runParam = struct;
            sys_param = struct;
            grids = struct;
            policy = struct;
            climParam = struct;
            costParam = struct;
            
            % If true, then use climate adaptive inflow distributions in the SDP.
            % If false, use non-adaptive inflow distribution in the SDP.
            runParam.adaptiveOps = false; % must match runParam.adaptiveOps above
            
            %% Set relevant sdp_climate.m main script parameters
            
            % Number of time periods
            runParam.N = 5; % Current SDP model requires N = 5
            
            % Number of years to generate in T, P, streamflow time series
            runParam.steplen = 200; %100;
            
            % Urban water demand scenarios (low = 150,000; high = 300,000)[m3/d](Fletcher 2019)
            runParam.domDemand = 186000; % 2020 design demand
            
            % If false, do not include deslination plant (planning scenarios A and B
            % with current demand in table 1). If true, include desalination plant
            % (planning scenario C with higher deamnd).
            runParam.desalOn = false;
            
            % If true, save results
            runParam.saveOn = true; % set to true when parellized
            
            % Number of T,P time series to generate using stochastic weather generator
            climParam.numSampTS = 21;
            
            % demand variables
            dmd_dom = cmpd2mcmpy(runParam.domDemand); % MCM/Y
            if runParam.desalOn
                dmd_dom = cmpd2mcmpy(300000); % high domestic demand scenario for desalination (MCM/Y)
            end
            dmd_ag = 12*[2.5 1.5 0.8 2.0 1.9 2.9 3.6 0.6 0.5 0.3 0.2 3.1]; % MCM/Y (Fletcher)
            %dmd_ag = [32.65 35.40 30.31 10.47 3.44 9.09 13.78 19.70 23.42 21.22 21.22 24.11]; % MCM/Y (MWI Average rescaled)
            
            demand = dmd_dom + dmd_ag; % MCM/Y
            
            % structure with system paramenters
            sys_param.simulation.delta = 1/12; % monthly time step (1/12 of a year)
            env_flow = 0; % MCM/Y
            sys_param.MEF = repmat(env_flow,12,1); % maximum environmental flow (MCM/Y)
            
            %% set SDP optimization
            
            % load synthetic inflow data
            if runParam.adaptiveOps % adaptive: use current climate state data
                qq  = runoff{T_state,P_state,1}' ; % inflow
            else % non-adaptive: use initial climate state data
                %qq  = runoff{1,12,1}' ; % inflow
                qq  = runoff{1,29,1}' ; % inflow
            end
            
            sys_param.simulation.q = qq ; % MCM/Y
            
            % discretization of variables' domain (Hoa Binh case: ns=68, nu=17, nq=101)
            grids.discr_s = [0:1:(storage-dead_storage)]'; % MCM (effective storage)
            grids.discr_u = [[0:3:max(demand,[],'all')+env_flow+10],[125:100:3000],[3500:1000:9560]]' ; % MCM/Y
            grids.discr_q = [[0:3:max(prctile(runoff{1,71,1},80))],[450:50:1000],[1100:1000:max(runoff{1,71,1},[],'all')+1000]]' ; % MCM/Y
            sys_param.algorithm = grids;
            sys_param.integration_substep = 300; % number of mass balance monthly substeps
            
            % set algorithm parameters
            sys_param.algorithm.name = 'sdp';
            sys_param.algorithm.Hend = 0 ; % penalty set to 0
            sys_param.algorithm.T = 12;    % the period is equal 1 year
            sys_param.algorithm.gamma = 1; % set future discount factor
            tol = -1;    % accuracy level for termination
            max_it = 10; % maximum iteration for termination
            
            % Estimate cyclostationary pdf (assuming log-normal distribution)
            T = sys_param.algorithm.T ;
            Ny = length(sys_param.simulation.q)/T*climParam.numSampTS;
            
            Q = reshape( sys_param.simulation.q, T, Ny ); % uses defined inflow (i.e., adaptive or non-adaptive)
            sys_param.algorithm.q_stat = nan(T,2) ;
            
            for i = 1:T
                qi = Q(i,:) ;
                sys_param.algorithm.q_stat(i,:) = lognfit(qi); % inflow distribution parameters for policy development
            end
            
            % create a table of expected monthly evaporation for each discrete storage state
            ee = NaN(length(grids.discr_s),T); % table containing expected evaporation rate by month and discrete storage state
            for e=1:length(grids.discr_s)
                if runParam.adaptiveOps % adaptive: use current climate state data
                    evap = evaporation_sdp(grids.discr_s(e)+dead_storage, T_ts{T_state,1},P_ts{P_state,1},climParam, runParam)';  % cyclostationary
                    ee(e,:) = mean(reshape( evap, T, Ny ),2)';
                else % non-adaptive: use initial climate state data
                    %evap = evaporation_sdp(grids.discr_s(e)+dead_storage, T_ts{1,1},P_ts{12,1},climParam, runParam)';  % cyclostationary
                    evap = evaporation_sdp(grids.discr_s(e)+dead_storage, T_ts{1,1},P_ts{29,1},climParam, runParam)';  % cyclostationary
                    ee(e,:) = mean(reshape( evap, T, Ny ),2)';
                end
            end
            
            sys_param.simulation.ev = ee ; % MCM/Y
            
            [vv, VV] = construct_rel_matrices(grids,sys_param); % compute minimum/maximum release for each climate state
            %save ./minRel_table.mat vv
            %save ./maxRel_table.mat VV
            %load ./minRel_table.mat
            %load ./maxRel_table.mat
            
            sys_param.algorithm.min_rel = vv;
            sys_param.algorithm.max_rel = VV;
            
            %% run SDP optimization
            
            Hopt =  opt_sdp(tol, max_it, sys_param, runParam, costParam) ;
            policy.H = Hopt ;
            %save -ascii ./BellmanSDP.txt Hopt
            
            %% load Bellman function
            
            %load ./BellmanSDP.txt
            %policy.H = BellmanSDP ;
            %% run simulation of SDP-policies
            
            % simulate policy using the actual climate state data
            qq  = runoff{T_state,P_state,1}' ; % 21 100-year simulations (inflow for initial climate state is (1,12,1))
            for e=1:length(grids.discr_s)
                evap = evaporation_sdp(grids.discr_s(e)+dead_storage, T_ts{T_state,1},P_ts{P_state,1},climParam, runParam)';  % cyclostationary
                ee(e,:) = mean(reshape( evap, T, Ny ),2)';
            end
            sys_param.simulation.q = qq ; % MCM/Y
            sys_param.simulation.ev = ee ; % MCM/Y
            
            % update steplen and numSampTS for 21 100-year simulations
            runParam.steplen = 200; %100; % 100 years
            climParam.numSampTS = 21; % simulations (21 GCMs)
            
            q_sim = sys_param.simulation.q;
            s_init = 30; % set constant initial effective reservoir storage (MCM)
            J = NaN(runParam.steplen*T,climParam.numSampTS);
            s = NaN(runParam.steplen*T+1,climParam.numSampTS);
            r = NaN(runParam.steplen*T+1,climParam.numSampTS);
            ev = NaN(runParam.steplen*T+1,climParam.numSampTS); % evaporation
            dmd_unmet = NaN(runParam.steplen*T,climParam.numSampTS);
            dmd_unmet_ag = NaN(runParam.steplen*T,climParam.numSampTS);
            dmd_unmet_dom = NaN(runParam.steplen*T,climParam.numSampTS);
            
            disp('simulation running..')
            for i=1:climParam.numSampTS
                [J(:,i), s(:,i), r(:,i), ev(:,i), dmd_unmet(:,i), dmd_unmet_ag(:,i), dmd_unmet_dom(:,i)] = simulateGibe( q_sim(:,i), s_init, policy, sys_param, runParam, costParam);
            end
            
            objective_ts = J;
            storage_ts = s;
            release_ts = r;
            evaporation_ts = ev;
            unmet_ts = dmd_unmet;
            unmet_ag_ts = dmd_unmet_ag;
            unmet_dom_ts = dmd_unmet_dom;
            
            % find average 20-year steady state shortage cost after first 20 years
            SS_cumsum_obj = sum(objective_ts(T*20+1:end,:)); % total objective function value in SS years
            num_SS_years = (length(objective_ts(:,1))-20*T)/(20*T); % number of years in SS
            shortageCost = mean(SS_cumsum_obj/num_SS_years); % average 20-year steady state shortage cost across 21 100-year simulations
            
            if runParam.saveOn
                if runParam.adaptiveOps
                    filename = strcat('Apr06sdp_reservoir_ops_SteadyState/Apr062021adaptive_domagCost231_SSTest','_st',num2str(s_T),'_sp',num2str(s_P),'_s',string(storage),'_',date,'.mat');
                else
                    filename = strcat('Apr06sdp_reservoir_ops_SteadyState/Apr062021nonadaptive_domagCost231_SSTest','_st',num2str(s_T),'_sp',num2str(s_P),'_s',string(storage),'_',date,'.mat');
                end
                parsave(filename, shortageCost, objective_ts,  storage_ts, unmet_ag_ts, unmet_dom_ts);
            end
        end
    end
end