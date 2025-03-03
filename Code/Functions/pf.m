function out = pf(y)
global n l mpc dyn Ybus V0

out     = zeros(2*n,1);
V       = y(1:n,1);
theta   = y(n+1:2*n,1);
V_ph    = V.*exp(1i*theta);
SG_bus  = mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end

% Current injection formulation
I_ph  = zeros(n,1);
for i = 1:n
    % Data from mpc
    Pd    = -mpc.bus(i,3);
    Qd    = -mpc.bus(i,4);
    exp_P = dyn.bus(i,2);
    exp_Q = dyn.bus(i,3);
    base  = mpc.baseMVA;
    type  = mpc.bus(i,2);
    
    if (type == 3 || type == 2) % Slack and PV buses
        k         = find(SG_bus == i);
        if l~= 0
            kk        = find(IBR_bus == i);
            if isempty(k)
                Pg    = mpc.ibr(kk,2);
                Qg    = mpc.ibr(kk,3);
            elseif isempty(kk)
                Pg    = mpc.gen(k,2);
                Qg    = mpc.gen(k,3);
            end        
        else
             Pg    = mpc.gen(k,2);
             Qg    = mpc.gen(k,3);
        end
        Pi        = Pg + Pd*V(i)^exp_P;
        Qi        = Qg + Qd*V(i)^exp_Q;
        I_ph(i,1) = ((Pi-1i*Qi)/base)*exp(1i*theta(i))/V(i);
    elseif type == 1 % PQ buses
        Pi        = Pd*V(i)^exp_P;
        Qi        = Qd*V(i)^exp_Q;
        if l ~= 0
            for j = 1:l 
                if (mpc.ibr(j) == i) % IBRs in PQ mode
                    Pg        = mpc.ibr(j,2);
                    Qg        = mpc.ibr(j,3);
                    Pi        = Pg + Pd*V(i)^exp_P;
                    Qi        = Qg + Qd*V(i)^exp_Q;
                    I_ph(i,1) = ((Pi-1i*Qi)/base)*exp(1i*theta(i))/V(i);
                else
                    I_ph(i,1) = ((Pi-1i*Qi)/base)*exp(1i*theta(i))/V(i);
                end
            end
        else
            I_ph(i,1) = ((Pi-1i*Qi)/base)*exp(1i*theta(i))/V(i);
        end
    end
end
out(1:n)     = imag(-I_ph+Ybus*V_ph);
out(n+1:2*n) = real(-I_ph+Ybus*V_ph);

for i = 1:n
    type = mpc.bus(i,2);
    if type == 3 % Slack
        out(i)   = V0(i)-V(i); % Q balance
        out(n+i) = theta(i);   % P balance
    elseif type == 2 % PV
        out(i)   = V0(i)-V(i); % Q balance
    end
end