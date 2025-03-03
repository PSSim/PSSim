% Inititialize g(x,y)
% Type 2 SG  Model Equations
% Type 3 AVR Model Equations
% Type 2 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);
eqp   = x0(pointer_sv(i)+2);
edp   = x0(pointer_sv(i)+3);
vm    = x0(pointer_sv(i)+4);
vrll  = x0(pointer_sv(i)+5);
efd   = x0(pointer_sv(i)+6);
vf    = x0(pointer_sv(i)+7);
y1    = x0(pointer_sv(i)+8);
y3    = x0(pointer_sv(i)+9);
Tm    = x0(pointer_sv(i)+10);

% Loading SG algebraic variables
iq      = y(pointer_av(i)-nsv+0);
id      = y(pointer_av(i)-nsv+1);
y2      = y(pointer_av(i)-nsv+2);
efd_sat = y(pointer_av(i)-nsv+3);
y2_sat  = y(pointer_av(i)-nsv+4);

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
k     = SG_bus(i);

% Extra calculation for ST1 exciter limits
vq     = imag(V_ph(k)*exp(-1i*(delta-pi/2)));
ifd    = id*Xq + iq*Rs + vq;
Vfmin  = abs(V_ph(k))*Vrmin  - Kc*ifd;
Vfmax  = abs(V_ph(k))*Vrmax  - Kc*ifd;

% SG equivalent circuit (id, iq) and governor alg. variable (y2)
if (genout == i)
    out(pointer_av(i)-nsv+0) = iq;
    out(pointer_av(i)-nsv+1) = id;
    out(pointer_av(i)-nsv+2) = y2;
    out(pointer_av(i)-nsv+3) = efd_sat;
    out(pointer_av(i)-nsv+4) = y2_sat;
else
    out(pointer_av(i)-nsv+0) = edp - V(k)*sin(delta - theta(k)) - Rs*id + Xqp*iq;
    out(pointer_av(i)-nsv+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;
    out(pointer_av(i)-nsv+2) = -y2 + (1 - T2/T3)*y3 + (T2/T3)*y1;
    if efd > Vfmin && efd < Vfmax
        out(pointer_av(i)-nsv+3) = -efd_sat + efd;
    elseif efd <= Vfmin
        out(pointer_av(i)-nsv+3) = -efd_sat + Vfmin;
    elseif efd >= Vfmax
        out(pointer_av(i)-nsv+3) = -efd_sat + Vfmax;
    end
    if y2 < Pc-Pmin && y2 > Pc-Pmax
        out(pointer_av(i)-nsv+4) = -y2_sat + y2;
    elseif y2 >= Pc-Pmin
        out(pointer_av(i)-nsv+4) = -y2_sat + Pc-Pmin;
    elseif y2 <= Pc-Pmax
        out(pointer_av(i)-nsv+4) = -y2_sat + Pc-Pmax;
    end
end