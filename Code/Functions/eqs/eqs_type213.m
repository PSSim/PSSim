% State and Algebraic Equations
% Type 2 SG Model Equations
% Type 1 AVR Model Equations
% Type 3 GOV Model Equations

% Loading state variables
delta = z(pointer_sv(i)+0);
w     = z(pointer_sv(i)+1);
eqp   = z(pointer_sv(i)+2);
edp   = z(pointer_sv(i)+3);
efd   = z(pointer_sv(i)+4);
vr    = z(pointer_sv(i)+5);
xg1   = z(pointer_sv(i)+6);
xg2   = z(pointer_sv(i)+7);
xg3   = z(pointer_sv(i)+8);

% Loading SG algebraic variables
iq      = z(pointer_av(i)+0);
id      = z(pointer_av(i)+1);
Tm      = z(pointer_av(i)+2);
efd_sat = z(pointer_av(i)+3);
xg1_sat = z(pointer_av(i)+4);

% Loading inputs
Pc    = u0(nin*(i-1)+1); %%%% nin can change acording to other models
Vref  = u0(nin*(i-1)+2);

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xd    = dyn.gen(i,5);
Xdp   = dyn.gen(i,6);
Xq    = dyn.gen(i,7);
Xqp   = dyn.gen(i,8);
Td0p  = dyn.gen(i,9);
Tq0p  = dyn.gen(i,10);
KA    = dyn.avr(i,3);
TA    = dyn.avr(i,4);
TE    = dyn.avr(i,6);
TB    = dyn.avr(i,9);
Vmin  = dyn.avr(i,12);
Vmax  = dyn.avr(i,13);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Dt    = dyn.gov(i,8);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
At    = dyn.gov(i,11);
Kt    = dyn.gov(i,12);
k     = SG_bus(i); % Bus index of the SGi
  
if (genout == i)
    % SG two-axis model eqs (delta, w, Eq', Ed')
    out(pointer_sv(i)+0) = 0;
    out(pointer_sv(i)+1) = 0;
    out(pointer_sv(i)+2) = 0;
    out(pointer_sv(i)+3) = 0;
    
    % Simplified Excitation System (SEXS_PTI) (Efd, Vr)
    out(pointer_sv(i)+4) = 0;
    out(pointer_sv(i)+5) = 0;
    
    % GAST governor/turbine model (xg1, xg2, xg3) 
    out(pointer_sv(i)+6) = 0;
    out(pointer_sv(i)+7) = 0;
    out(pointer_sv(i)+8) = 0;
    
    % SG equivalent circuit (id, iq) and governor alg. variable (Tm)
    out(pointer_av(i)+0) = iq;
    out(pointer_av(i)+1) = id;    
    out(pointer_av(i)+2) = Tm;
    out(pointer_av(i)+3) = efd_sat;
    out(pointer_av(i)+4) = xg1_sat;
else
    % SG two-axis model eqs (delta, w, Eq', Ed')
    out(pointer_sv(i)+0) = ws*(w - w_ref);
    out(pointer_sv(i)+1) = (1/(2*H))*(Tm - edp*id - eqp*iq - (Xqp-Xdp)*id*iq);
    out(pointer_sv(i)+2) = (1/Td0p)*(-eqp - (Xd - Xdp)*id + efd_sat);
    out(pointer_sv(i)+3) = (1/Tq0p)*(-edp + (Xq - Xqp)*iq);
    
    % Simplified Excitation System (SEXS_PTI) (Efd, Vr)
    out(pointer_sv(i)+4) = (1/TE)*(KA*(vr + (TA/TB)*(Vref-abs(V_ph(k)))) - efd);
    out(pointer_sv(i)+5) = (1/TB)*((1-TA/TB)*(Vref-abs(V_ph(k))) - vr);
    
    % GAST governor/turbine model (xg1, xg2, xg3)
    aux1  = Pc-K1*(w-1); aux2 = At + Kt*(At-xg3); 
    out(pointer_sv(i)+6) = (1/T1)*(min(aux1,aux2)-xg1);
    out(pointer_sv(i)+7) = (1/T2)*(xg1_sat-xg2);
    out(pointer_sv(i)+8) = (1/T3)*(xg2-xg3);
    
    % SG equivalent circuit (id, iq) and governor alg. variable (Tm)
    out(pointer_av(i)+0) =     - V(k)*sin(delta - theta(k)) - Rs*id + Xq*iq;
    out(pointer_av(i)+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;    
    out(pointer_av(i)+2) = -Tm + xg2 - Dt*(w-1);
    if efd > Vmin && efd < Vmax
        out(pointer_av(i)+3) = -efd_sat + efd;
    elseif efd <= Vmin
        out(pointer_av(i)+3) = -efd_sat + Vmin;
    elseif efd >= Vmax
        out(pointer_av(i)+3) = -efd_sat + Vmax;
    end
    if xg1 > Pmin && xg1 < Pmax
        out(pointer_av(i)+4) = -xg1_sat + xg1; 
    elseif xg1 <= Pmin
        out(pointer_av(i)+4) = -xg1_sat + Pmin;
    elseif xg1 >= Pmax
        out(pointer_av(i)+4) = -xg1_sat + Pmax;
    end
end