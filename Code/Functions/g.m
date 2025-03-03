function out = g(y)
global n m l mpc Ybus nsv nav nav_SG dyn x0 genout nin u0
global pointer_sv pointer_av pointer_sv_ibr pointer_av_ibr nsv_SG nsv_IBR nav_IBR nav_PMU ws

out     = zeros(nav,1);
SG_bus  = mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end

% PMU state variables
theta_est = x0(nsv-n+1:nsv);

% Grid algebraic variables
V     = y(nav-2*n+1:nav-n,1);
theta = y(nav-n+1:end,1);
V_ph  = V.*exp(1i*theta);

% Reference machine
for i = 1:n
    type = mpc.bus(i,2);
    if (type == 3)
        j     = find(SG_bus == i);
        w_ref = x0(pointer_sv(j)+1);
    end
end   

%% SG models
for i = 1:m
    % Extract Models Type
    SG_type = [dyn.gen(i,2);dyn.avr(i,2);dyn.gov(i,2)];
    [nsv_SGi,nav_SGi] = var_num(SG_type);

    % Convert SG_type to a unique identifier
    SG_key = sprintf('%d%d%d', SG_type(1), SG_type(2), SG_type(3));
    
    % Load SG model using switch-case
    switch SG_key
        case '000'
            initg_type0;
        case '001'
            initg_type001;
        case '002'
            initg_type002;
        case '003'
            initg_type003;
        case '111'
            initg_type111;
        case '112'
            initg_type112;
        case '113'
            initg_type113;
        case '121'
            initg_type121;
        case '122'
            initg_type122;
        case '123'
            initg_type123;
        case '131'
            initg_type131;
        case '132'
            initg_type132;
        case '133'
            initg_type133;
        case '211'
            initg_type211;
        case '212'
            initg_type212;
        case '213'
            initg_type213;
        case '221'
            initg_type221;
        case '222'
            initg_type222;
        case '223'
            initg_type223;
        case '231'
            initg_type231;
        case '232'
            initg_type232;
        case '233'
            initg_type233;
        otherwise
            error('Invalid SG_type combination');
    end
end
%% IBR models
% Equations for IBRs
for i = 1:l
    % Extract IBR model type
    IBR_type = [dyn.ibr(i,2);dyn.control(i,2)];
    [nsv_IBRi,nav_IBRi] = var_num_ibr(IBR_type);
    % Load IBR model
    if      IBR_type(1) == 1 && IBR_type(2) == 1 %
        initg_ibr_type11;
    elseif  IBR_type(1) == 1 && IBR_type(2) == 2 % %
        initg_ibr_type12; % Pending
    end
end

%% Grid Model
% Current injection formulation
I_ph = zeros(n,1);

for i = 1:n
    % PMU algebraic variable
    w_est = y(nav-3*n+i);

    % Data from mpc
    Tpmu   = dyn.pmu(i,2);
    Pd    = -mpc.bus(i,3);
    Qd    = -mpc.bus(i,4);
    exp_P = dyn.bus(i,2);
    exp_Q = dyn.bus(i,3);
    base  = mpc.baseMVA;
    type  = mpc.bus(i,2);
    Pd    = (Pd/base)*V(i)^exp_P;
    Qd    = (Qd/base)*V(i)^exp_Q;

    % PMU algebraic equation
    out(nav-3*n+i) = -w_est + (1/(Tpmu*ws))*(-theta_est(i) + theta(i)) + w_ref;
    
    if (type == 3 || type == 2) % Slack and PV buses
        k     = find(SG_bus == i);
        if l~= 0 
            kk        = find(IBR_bus == i);
            if isempty(k)
                k   = find(mpc.ibr(:,1) == i);
                iq  = y(pointer_av_ibr(k)-nsv+0);
                id  = y(pointer_av_ibr(k)-nsv+1);
                phi = theta(i);
                I_ph(i,1) = (id+1i*iq)*exp(1i*(phi)) + (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            elseif isempty(kk)
                iq    = y(pointer_av(k)-nsv+0);
                id    = y(pointer_av(k)-nsv+1);
                delta = x0(pointer_sv(k)+0); 
                if (genout == k)
                    id = 0;
                    iq = 0;
                end
                % Use of non-referenced (without exp(1i*(delta-pi/2)) classical model
                % Extract Models Type
                SG_type = [dyn.gen(k,2);dyn.avr(k,2);dyn.gov(k,2)];
                % Load SG model
                if SG_type(1) == 0 %
                    I_ph(i,1) = (id+1i*iq)+ (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
                else
                    I_ph(i,1) = (id+1i*iq)*exp(1i*(delta-pi/2)) + (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
                end 
            end
        else
            iq    = y(pointer_av(k)-nsv+0);
            id    = y(pointer_av(k)-nsv+1);
            delta = x0(pointer_sv(k)+0); 
            if (genout == k)
                id = 0;
                iq = 0;
            end
            % Use of non-referenced (without exp(1i*(delta-pi/2)) classical model
            % Extract Models Type
            SG_type = [dyn.gen(k,2);dyn.avr(k,2);dyn.gov(k,2)];
            % Load SG model
            if SG_type(1) == 0 %
                I_ph(i,1) = (id+1i*iq)+ (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            else
                I_ph(i,1) = (id+1i*iq)*exp(1i*(delta-pi/2)) + (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            end
        end
    % PQ buses        
    elseif type == 1 
        if l ~= 0
            if any(mpc.ibr(:,1) == i)
                k   = find(mpc.ibr(:,1) == i);
                iq  = y(pointer_av_ibr(k)-nsv+0);
                id  = y(pointer_av_ibr(k)-nsv+1);
                phi = theta(i);
                I_ph(i,1) = (id+1i*iq)*exp(1i*(phi)) + (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            else
                I_ph(i,1) = (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            end
        else
            I_ph(i,1) = (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
        end
    end
end
out(nav-2*n+1:nav-n,1) = imag(-I_ph+Ybus*V_ph);
out(nav-n+1:end,1)     = real(-I_ph+Ybus*V_ph);

%% Faulted bus (Vi = thetai = 0) %%% Check for this event
for i = 1:n
    if Ybus(i,i) == 1+1i 
        out(sum(nav_SG)+sum(nav_IBR)+nav_PMU*n+i,1)   = V(i);
        out(sum(nav_SG)+sum(nav_IBR)+nav_PMU*n+n+i,1) = theta(i);
    end
end
end 