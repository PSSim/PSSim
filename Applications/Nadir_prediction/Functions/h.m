function out = h(t,z)
global n m l mpc dyn Ybus ws nsv nsv_SG nav_SG nsv_IBR nav_IBR nav nin u0 genout
global pointer_sv pointer_av pointer_sv_ibr pointer_av_ibr nsv_PMU nav_PMU

out     = zeros(nsv+nav,1); %%%%%%%
SG_bus  = mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end

% Grid phasors
V           = z(nsv+nav-2*n+1:nsv+nav-n);
theta       = z(nsv+nav-n+1:end);

theta_est   = z(nsv-n+1:nsv);
V_ph        = V.*exp(1i*theta);

% Reference machine
for i = 1:n
    type = mpc.bus(i,2);
    if (type == 3)
        j     = find(SG_bus == i);
        w_ref = z(pointer_sv(j)+1);
    end
end       
    
%% SG/AVR/GOV models
for i = 1:m
    % Extract Models Type
    SG_type = [dyn.gen(i,2); dyn.avr(i,2); dyn.gov(i,2)];
    [nsv_SGi, nav_SGi] = var_num(SG_type);
    
    % Convert SG_type to a unique identifier
    SG_key = sprintf('%d%d%d', SG_type(1), SG_type(2), SG_type(3));
    
    % Load SG model using switch-case
    switch SG_key
        case '000'
            eqs_type0;
        case '001'
            eqs_type001;
        case '002'
            eqs_type002;
        case '003'
            eqs_type003;
        case '111'
            eqs_type111;
        case '112'
            eqs_type112;
        case '113'
            eqs_type113;
        case '121'
            eqs_type121;
        case '122'
            eqs_type122;
        case '123'
            eqs_type123;
        case '131'
            eqs_type131;
        case '132'
            eqs_type132;
        case '133'
            eqs_type133;
        case '211'
            eqs_type211;
        case '212'
            eqs_type212;
        case '213'
            eqs_type213;
        case '221'
            eqs_type221;
        case '222'
            eqs_type222;
        case '223'
            eqs_type223;
        case '231'
            eqs_type231;
        case '232'
            eqs_type232;
        case '233'
            eqs_type233;
        otherwise
            error('Invalid SG_type combination');
    end
end

%% IBR Model    
% Equations for IBRs
for i = 1:l
    % Extract IBR model type
    IBR_type = [dyn.ibr(i,2);dyn.control(i,2)];
    [nsv_IBRi,nav_IBRi] = var_num_ibr(IBR_type);
    
    % Load IBR model
    if      IBR_type(1) == 1 && IBR_type(2) == 1 %
        eqs_ibr_type11;
    elseif  IBR_type(1) == 1 && IBR_type(2) == 2 % %
        eqs_ibr_type12; 
    end
end

%% Grid Model
% Current injection formulation for the grid (Vi, thetai)
I_ph  = zeros(n,1);
for i = 1:n
    % PMU algebraic variable
    w_est = z(nsv+sum(nav_SG)+sum(nav_IBR)+i); 

    % Loading load data
    Tpmu  = dyn.pmu(i,2);
    Pd    = -mpc.bus(i,3);
    Qd    = -mpc.bus(i,4);
    exp_P = dyn.bus(i,2);
    exp_Q = dyn.bus(i,3);
    base  = mpc.baseMVA;
    type  = mpc.bus(i,2);
    Pd    = (Pd/base)*V(i)^exp_P;
    Qd    = (Qd/base)*V(i)^exp_Q;

    %% PMU equations (one differential and one algebraic)
    out(sum(nsv_SG)+sum(nsv_IBR)+i)     = (1/Tpmu)*(-theta_est(i) + theta(i));
    out(nsv+sum(nav_SG)+sum(nav_IBR)+i) = -w_est + (1/(Tpmu*ws))*(-theta_est(i) + theta(i)) + w_ref;
    
    %% Current injections (nodal network equations)
    % Slack and PV buses
    if (type == 3 || type == 2) 
        k         = find(SG_bus == i);
        if l~= 0   % Check IBR existance
            kk = find(IBR_bus == i, 1);
            if isempty(k)  %
                k   = find(mpc.ibr(:,1) == i);
                iq  = z(pointer_av_ibr(k)+0);
                id  = z(pointer_av_ibr(k)+1);
                phi = theta(i);
                I_ph(i,1) = (id+1i*iq)*exp(1i*(phi)) + (Pd-1i*Qd)*exp(1i*theta(i))/V(i);
            elseif isempty(kk)
                iq        = z(pointer_av(k)+0);
                id        = z(pointer_av(k)+1);
                delta     = z(pointer_sv(k)+0); 
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
            iq        = z(pointer_av(k)+0);
            id        = z(pointer_av(k)+1);
            delta     = z(pointer_sv(k)+0); 
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
                iq  = z(pointer_av_ibr(k)+0);
                id  = z(pointer_av_ibr(k)+1);
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
out(nsv+nav-2*n+1:nsv+nav-n,1) = imag(-I_ph+Ybus*V_ph);
out(nsv+nav-n+1:end,1)         = real(-I_ph+Ybus*V_ph);

%% Short-circuit condition 
for i = 1:n
    % Detecting faulted bus (Vi = thetai = 0)
    if Ybus(i,i)==(1+1j)
        out(nsv+nav-2*n+i) = V(i);     
        out(nsv+nav-n+i)   = theta(i);
    end
end
end