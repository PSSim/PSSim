% Inititialize g(x,y)
% Type 1 SG  Model Equations
% Type 3 AVR Model Equations
% Type 3 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);
eqp   = x0(pointer_sv(i)+2);
vm    = x0(pointer_sv(i)+3);
vrll  = x0(pointer_sv(i)+4);
efd   = x0(pointer_sv(i)+5);
vf    = x0(pointer_sv(i)+6);
xg1   = x0(pointer_sv(i)+7);
xg2   = x0(pointer_sv(i)+8);
xg3   = x0(pointer_sv(i)+9);

% Loading SG algebraic variables
iq      = y(pointer_av(i)-nsv+0);
id      = y(pointer_av(i)-nsv+1);
Tm      = y(pointer_av(i)-nsv+2);
efd_sat = y(pointer_av(i)-nsv+3);
xg1_sat = y(pointer_av(i)-nsv+4);

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
Dt    = dyn.gov(i,8);
Pmin  = dyn.gov(i,9);
Pmax   = dyn.gov(i,10);
At    = dyn.gov(i,11);
Kt    = dyn.gov(i,12);
k     = SG_bus(i);

% Extra calculation for ST1 exciter limits
vq     = imag(V_ph(k)*exp(-1i*(delta-pi/2)));
ifd    = id*Xq + iq*Rs + vq;
Vfmin  = abs(V_ph(k))*Vrmin  - Kc*ifd;
Vfmax  = abs(V_ph(k))*Vrmax  - Kc*ifd;

% SG equivalent circuit (id, iq) and governor alg. variable (Tm)
if (genout == i)
    out(pointer_av(i)-nsv+0) = iq;
    out(pointer_av(i)-nsv+1) = id;
    out(pointer_av(i)-nsv+2) = Tm;
    out(pointer_av(i)-nsv+3) = efd_sat;
    out(pointer_av(i)-nsv+4) = xg1_sat; 
else
    out(pointer_av(i)-nsv+0) =     - V(k)*sin(delta - theta(k)) - Rs*id + Xq*iq;
    out(pointer_av(i)-nsv+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;
    out(pointer_av(i)-nsv+2) = -Tm + xg2 - Dt*(w-1);
    if efd > Vfmin && efd < Vfmax
    out(pointer_av(i)-nsv+3) = -efd_sat + efd;
    elseif efd <= Vfmin
        out(pointer_av(i)-nsv+3) = -efd_sat + Vfmin;
    elseif efd >= Vfmax
        out(pointer_av(i)-nsv+3) = -efd_sat + Vfmax;
    end
    if xg1 > Pmin && xg1 < Pmax
        out(pointer_av(i)-nsv+4) = -xg1_sat + xg1; 
    elseif xg1 <= Pmin
        out(pointer_av(i)-nsv+4) = -xg1_sat + Pmin;
    elseif xg1 >= Pmax
        out(pointer_av(i)-nsv+4) = -xg1_sat + Pmax;
    end
end