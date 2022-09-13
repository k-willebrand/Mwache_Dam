% initialize cost model parameters:
disc = [0];
storages = 60:10:140; % optimal sizes
resOps = 1; % 1 if static ops, 2 in flexible ops
Design = 2; % 1 if static design, 2 if flexible design, 3 if flexible plan

% table to save min c' values
min_cprimes = zeros(length(storages),1);

for ss = 1:length(storages)
    
    findStor = storages(ss);
    
    x_6 = 5; %costParam.PercFlex: initial upfront capital cost increase flex design
    x_7 = 1; %costParam.PercFlexExp: expansion cost of flexible dam  flex design (0)
    x_11 = 0; %costParam.PercPlan: initial upfront capital cost increase (0);
    x_12 = 50; %costParam.PercPlanExp: expansion cost of flexibly planned dam (0.5)
    %cplim = [6.72E-8, 2.61E-6];
    cplim = [6.6E-8, 2.8E-6];
    
    
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

    
    for z = resOps % the adaptive and non-adaptive policies
        
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
        
        optStor = 0; % initialize variables for while loop
        mincp_new = cplim(1) - 1E-8;
        maxcp_new = cplim(2)+1E-8;
        c_prime_new = mean([mincp,maxcp]);
        
        mincp = mincp_new;
        maxcp = maxcp_new;
        c_prime = c_prime_new;
        cond = 1; % condition: c_prime - 0.01E? --> findStor -1
         
        while ((optStor ~= findStor)||((optStor == findStor) && (floor(log10(maxcp-mincp)) >= floor(log10(c_prime))-2)))
            
            stateMsg = strcat('optStor=',num2str(optStor), '(',num2str(findStor),'), c_prime =', num2str(c_prime));
            disp(stateMsg)
            
            % update estimates
            mincp = mincp_new;
            maxcp = maxcp_new;
            c_prime = c_prime_new;
            
            if Design == 1 % static design
                % 1. Find the optimal static dam size
                bestVal_static = inf;
                count = 1;
                
                for j=50:10:150 %30:10:80
                    
                    stateMsg = strcat('z=',num2str(z),', j=', num2str(j));
                    disp(stateMsg)
                    
                    x(1) = 2; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                    x(2) = j; % optParam.staticCap: static dam size [MCM]
                    x(3) = 50; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                    x(4) = 1;  %optParam.numFlex: number of possible expansion capacities [#]
                    x(5) = 10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
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
                    val = V(1, 12, 1, 1)/1E6;
                    val_static(count,z) = V(1, 12, 1, 1)/1E6;
                    Vs_static(count,z) = Vs(1, 12, 1, 1)/1E6;
                    Vd_static(count,z) = Vd(1, 12, 1, 1)/1E6;
                    count = count + 1;
                    if val < bestVal_static
                        bestVal_static = val;
                        allV_static = V;
                        bestAct_static = x;
                        allX_static = X;
                        allVs_static = Vs;
                        allVd_static = Vd;
                        
                    end
                end
                
                optStor = bestAct_static(2); % found optimal design
                
            elseif Design == 2 % flex design
                
                % 2. Find the optimal flexible design dam size
                bestVal_flex = inf;
                count = 1;
                
                for j=50:10:150 %30:10:120 %200 %140 % initial unexpanded dam sizes
                    for h=1 % flex expansion increments
                        for g=1:7 % number of flex expansion(7-2*h)
                            
                            stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                                num2str(h));
                            disp(stateMsg)
                            
                            %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                            %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                            if (j+h*10*g) > ceil(1.5*j/10)*10
                                disp('Flex design size not feasible');
                            elseif (j+h*10*g) > 150 %120 % place max on possible dam size
                                disp('Flex design size not feasible');
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
                
                optStor = bestAct_flex(3); % found optimal design
                
            else % flexible planning

                % 3. Find the optimal flexible planning dam size
                bestVal_plan = inf;
                count = 1;
                
                for j=50:10:150 %200 %140
                    
                    for h=1 % flex expansion increments
                        for g=1:7 % number of flex expansion(7-2*h)
                            
                            stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                                num2str(h));
                            disp(stateMsg)
                            
                            %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                            %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                            if (j+h*10*g) > ceil(1.5*j/10)*10
                                disp('Flex plan size not feasible');
                            elseif (j+h*10*g) > 150 %150 % place max on possible dam size
                                disp('Flex plan size not feasible');
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
                
                optStor = bestAct_plan(8); % found optimal design
                
            end
            
            if optStor < findStor
                mincp_new = c_prime;
            elseif optStor > findStor
                maxcp_new = c_prime;
            end
            
            % update c_prime guess
            c_prime_curr = c_prime;
            
            %% test boundary condition if we think we found the answer needed:
            if (optStor == findStor)|| (floor(log10(maxcp-mincp)) < floor(log10(c_prime))-2)
                
                % test slightly smaller c'
                c_prime = c_prime - 10^(floor(log10(c_prime))-2);
                
                if Design == 1 % static design
                    % 1. Find the optimal static dam size
                    bestVal_static = inf;
                    count = 1;
                    
                    for j=50:10:150 %30:10:80
                        
                        stateMsg = strcat('z=',num2str(z),', j=', num2str(j));
                        disp(stateMsg)
                        
                        x(1) = 2; %optParam.optFlex: (1)flexible design (2) static (3) flexible plan (0) policy;
                        x(2) = j; % optParam.staticCap: static dam size [MCM]
                        x(3) = 50; %optParam.smallFlexCap: unexpanded flexible design dam size [MCM]
                        x(4) = 1;  %optParam.numFlex: number of possible expansion capacities [#]
                        x(5) = 10; %optParam.flexIncr: increment of flexible expansion capacities [MCM]
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
                        val = V(1, 12, 1, 1)/1E6;
                        val_static(count,z) = V(1, 12, 1, 1)/1E6;
                        Vs_static(count,z) = Vs(1, 12, 1, 1)/1E6;
                        Vd_static(count,z) = Vd(1, 12, 1, 1)/1E6;
                        count = count + 1;
                        if val < bestVal_static
                            bestVal_static = val;
                            allV_static = V;
                            bestAct_static = x;
                            allX_static = X;
                            allVs_static = Vs;
                            allVd_static = Vd;
                            
                        end
                    end
                    
                    optStorTest = bestAct_static(2); % found optimal design
                    
                elseif Design == 2 % flex design
                    
                    % 2. Find the optimal flexible design dam size
                    bestVal_flex = inf;
                    count = 1;
                    
                    for j=50:10:150 %30:10:120 %200 %140 % initial unexpanded dam sizes
                        for h=1 % flex expansion increments
                            for g=1:7 % number of flex expansion(7-2*h)
                                
                                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                                    num2str(h));
                                disp(stateMsg)
                                
                                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                                %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                                if (j+h*10*g) > ceil(1.5*j/10)*10
                                    disp('Flex design size not feasible');
                                elseif (j+h*10*g) > 150 %120 % place max on possible dam size
                                    disp('Flex design size not feasible');
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
                    
                    optStorTest = bestAct_flex(3); % found optimal design
                    
                else % flexible planning
                    
                    % 3. Find the optimal flexible planning dam size
                    bestVal_plan = inf;
                    count = 1;
                    
                    for j=50:10:150 %200 %140
                        
                        for h=1 % flex expansion increments
                            for g=1:7 % number of flex expansion(7-2*h)
                                
                                stateMsg = strcat('z=',num2str(z),', j=', num2str(j), ', g=', num2str(g), ', h=', ...
                                    num2str(h));
                                disp(stateMsg)
                                
                                %if (j*1.6) < (j+h*10*g) % if false, then this combination is ok
                                %if (j+h*10*g) > ceil(1.5*j/10)*10 % if false, then this combination is ok
                                if (j+h*10*g) > ceil(1.5*j/10)*10
                                    disp('Flex plan size not feasible');
                                elseif (j+h*10*g) > 150 %150 % place max on possible dam size
                                    disp('Flex plan size not feasible');
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
                    
                    optStorTest = bestAct_plan(8); % found optimal design
                    
                end
                
                % validate condition and set c' back
                cond = (optStorTest ~= findStor -10);
                if cond == 0
                     disp(strcat('Cond reached: ',string(cond)))
                     break
                end
                if optStorTest == findStor
                    maxcp_new = c_prime;
                    mincp_new = c_prime_curr - 10^(floor(log10(c_prime_curr)));
                end
            end
            c_prime = c_prime_curr; 
            c_prime_new = mean([mincp_new,maxcp_new]);
        end
        min_cprimes(ss) = c_prime_new;
    end
end

round_min_cprimes = floor(min_cprimes.*100./(10.^(floor(log10(min_cprimes))))).*10.^(floor(log10(min_cprimes)))/100;
save(strcat('Nov02cprimes_des',string(Design),'_ops',string(resOps),'_disc',string(disc)), 'min_cprimes' , 'round_min_cprimes')
