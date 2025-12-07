% State and Algebraic Equations
% Type 1 SG Model Equations
% Type 2 AVR Model Equations
% Type 1 GOV Model Equations

% Loading state variables
delta = z(pointer_sv(i)+0);
w     = z(pointer_sv(i)+1);
eqp   = z(pointer_sv(i)+2);
efd   = z(pointer_sv(i)+3);
rf    = z(pointer_sv(i)+4);
vr    = z(pointer_sv(i)+5);
y1    = z(pointer_sv(i)+6);
y2    = z(pointer_sv(i)+7);

% Loading SG algebraic variables
iq      = z(pointer_av(i)+0);
id      = z(pointer_av(i)+1);
Tm      = z(pointer_av(i)+2);
vr_sat  = z(pointer_av(i)+3);
y1_sat  = z(pointer_av(i)+4);

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
KA    = dyn.avr(i,3);
TA    = dyn.avr(i,4);
KE    = dyn.avr(i,5);
TE    = dyn.avr(i,6);
KF    = dyn.avr(i,7);
TF    = dyn.avr(i,8);
Vrmin = dyn.avr(i,14);
Vrmax = dyn.avr(i,15);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Dt    = dyn.gov(i,8);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
k     = SG_bus(i); % Bus index of the SGi
  
if (genout == i)
    % SG one-axis model eqs (delta, w, Eq')
    out(pointer_sv(i)+0) = 0;
    out(pointer_sv(i)+1) = 0;
    out(pointer_sv(i)+2) = 0;
    
    % IEEE-Type I exciter (Efd, Rf, Vr)
    out(pointer_sv(i)+3) = 0;
    out(pointer_sv(i)+4) = 0;
    out(pointer_sv(i)+5) = 0;
    
    % TGOV1 governor/turbine model (y1, y2)
    out(pointer_sv(i)+6) = 0; 
    out(pointer_sv(i)+7) = 0;
    
    % SG equivalent circuit (id, iq) and governor alg. variable (Tm)
    out(pointer_av(i)+0) = iq;
    out(pointer_av(i)+1) = id;    
    out(pointer_av(i)+2) = Tm;
    out(pointer_av(i)+3) = vr_sat;
    out(pointer_av(i)+4) = y1_sat;
else
    % SG one-axis model eqs (delta, w, Eq')
    out(pointer_sv(i)+0) = ws*(w - w_ref);
    out(pointer_sv(i)+1) = (1/(2*H))*(Tm - eqp*iq - (Xq-Xdp)*id*iq);
    out(pointer_sv(i)+2) = (1/Td0p)*(-eqp - (Xd - Xdp)*id + efd);
    
    % IEEE-Type I exciter (Efd, Rf, Vr)
    out(pointer_sv(i)+3) = (1/TE)*(-KE*efd + vr_sat);
    out(pointer_sv(i)+4) = (1/TF)*(-rf + efd*KF/TF);
    out(pointer_sv(i)+5) = (1/TA)*(-vr + KA*rf - efd*KA*KF/TF + KA*(Vref - abs(V_ph(k))));
    
    % TGOV1 governor/turbine model (y1, y2)
    out(pointer_sv(i)+6) = (1/T1)*(K1*(Pc - (w-1)) - y1); 
    out(pointer_sv(i)+7) = (1/T3)*(y1_sat*(1-T2/T3)-y2);
    
    % SG equivalent circuit (id, iq) and governor alg. variable (y2)
    out(pointer_av(i)+0) =     - V(k)*sin(delta - theta(k)) - Rs*id + Xq*iq;
    out(pointer_av(i)+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;    
    out(pointer_av(i)+2) = - Tm + y2 + (T2/T3)*y1_sat - Dt*(w - 1); 
    if vr > Vrmin && vr < Vrmax
        out(pointer_av(i)+3) = -vr_sat + vr;
    elseif vr <= Vrmin
        out(pointer_av(i)+3) = -vr_sat + Vrmin;
    elseif vr >= Vrmax
        out(pointer_av(i)+3) = -vr_sat + Vrmax;
    end
    if y1 > Pmin && y1 < Pmax
        out(pointer_av(i)+4) = -y1_sat + y1;
    elseif y1 <= Pmin
        out(pointer_av(i)+4) = -y1_sat + Pmin;
    elseif y1 >= Pmax
        out(pointer_av(i)+4) = -y1_sat + Pmax;
    end
end