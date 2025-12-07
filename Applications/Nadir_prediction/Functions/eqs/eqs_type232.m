% State and Algebraic Equations
% Type 2 SG Model Equations
% Type 3 AVR Model Equations
% Type 2 GOV Model Equations

% Loading state variables
delta = z(pointer_sv(i)+0);
w     = z(pointer_sv(i)+1);
eqp   = z(pointer_sv(i)+2);
edp   = z(pointer_sv(i)+3);
vm    = z(pointer_sv(i)+4);
vrll  = z(pointer_sv(i)+5);
efd   = z(pointer_sv(i)+6);
vf    = z(pointer_sv(i)+7);
y1    = z(pointer_sv(i)+8);
y3    = z(pointer_sv(i)+9);
Tm    = z(pointer_sv(i)+10);

% Loading SG algebraic variables
iq      = z(pointer_av(i)+0);
id      = z(pointer_av(i)+1);
y2      = z(pointer_av(i)+2);
efd_sat = z(pointer_av(i)+3);
y2_sat  = z(pointer_av(i)+4);

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
KE    = dyn.avr(i,5);
TE    = dyn.avr(i,6);
KF    = dyn.avr(i,7);
TF    = dyn.avr(i,8);
TB    = dyn.avr(i,9);
TR    = dyn.avr(i,10);
TC    = dyn.avr(i,11);
Vrmin = dyn.avr(i,14);
Vrmax = dyn.avr(i,15);
Kc    = dyn.avr(i,16);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
k     = SG_bus(i); % Bus index of the SGi
  
if (genout == i)
    % SG two-axis model eqs (delta, w, Eq', Ed')
    out(pointer_sv(i)+0) = 0;
    out(pointer_sv(i)+1) = 0;
    out(pointer_sv(i)+2) = 0;
    out(pointer_sv(i)+3) = 0;
        
    % Excitation System ST1 (EXST1) (Vm, Vrll, Efd, Vf)
    out(pointer_sv(i)+4) = 0;
    out(pointer_sv(i)+5) = 0;
    out(pointer_sv(i)+6) = 0;
    out(pointer_sv(i)+7) = 0;
    
    % IEEESGO governor/turbine model (y1, y3, Tm)
    out(pointer_sv(i)+8)  = 0;
    out(pointer_sv(i)+9)  = 0;
    out(pointer_sv(i)+10) = 0;
    
    % SG equivalent circuit (id, iq) and governor alg. variable (y2)
    out(pointer_av(i)+0) = iq;
    out(pointer_av(i)+1) = id;    
    out(pointer_av(i)+2) = y2;
    out(pointer_av(i)+3) = efd_sat;
    out(pointer_av(i)+4) = y2_sat;
else
    % SG two-axis model eqs (delta, w, Eq', Ed')
    out(pointer_sv(i)+0) = ws*(w - w_ref);
    out(pointer_sv(i)+1) = (1/(2*H))*(Tm - edp*id - eqp*iq - (Xqp-Xdp)*id*iq);
    out(pointer_sv(i)+2) = (1/Td0p)*(-eqp - (Xd - Xdp)*id + efd_sat);
    out(pointer_sv(i)+3) = (1/Tq0p)*(-edp + (Xq - Xqp)*iq);
    
    % Extra calculation for ST1 exciter limits
    vq     = imag(V_ph(k)*exp(-1i*(delta-pi/2)));
    ifd    = id*Xq + iq*Rs + vq;
    Vfmin  = abs(V_ph(k))*Vrmin  - Kc*ifd;
    Vfmax  = abs(V_ph(k))*Vrmax  - Kc*ifd;
    
    % Excitation System ST1 (EXST1) (Vm, Vrll, Efd, Vf)
    out(pointer_sv(i)+4) = (1/TR)*(abs(V_ph(k)) - vm);
    out(pointer_sv(i)+5) = (1/TC)*(((TC/TB)*(Vref - vm - vf - vrll) - vrll) - vrll);
    out(pointer_sv(i)+6) = (1/TA)*(KA*(((TC/TB)*(Vref - vm - vf - vrll) - vrll)) - efd);
    out(pointer_sv(i)+7) = (1/TF)*(((KF/TA)*(KA*(((TC/TB)*(Vref - vm - vf - vrll) - vrll)) - efd_sat)) - vf);
    
    % IEEESGO governor/turbine model (y1, y3, Tm)
    out(pointer_sv(i)+8)  = (1/T1)*(-y1 + K1*(w-1));
    out(pointer_sv(i)+9)  = (1/T3)*(-y3 + y1);
    out(pointer_sv(i)+10) = (1/T4)*(-Tm + Pc - y2_sat);
    
    % SG equivalent circuit (id, iq) and governor alg. variable (y2)
    out(pointer_av(i)+0) = edp - V(k)*sin(delta - theta(k)) - Rs*id + Xqp*iq;
    out(pointer_av(i)+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;    
    out(pointer_av(i)+2) = -y2 + (1 - T2/T3)*y3 + (T2/T3)*y1;
    if efd > Vfmin && efd < Vfmax
        out(pointer_av(i)+3) = -efd_sat + efd;
    elseif efd <= Vfmin
        out(pointer_av(i)+3) = -efd_sat + Vfmin;
    elseif efd >= Vfmax
        out(pointer_av(i)+3) = -efd_sat + Vfmax;
    end
    if y2 < Pc-Pmin && y2 > Pc-Pmax
        out(pointer_av(i)+4) = -y2_sat + y2;
    elseif y2 >= Pc-Pmin
        out(pointer_av(i)+4) = -y2_sat + Pc-Pmin;
    elseif y2 <= Pc-Pmax
        out(pointer_av(i)+4) = -y2_sat + Pc-Pmax;
    end
end