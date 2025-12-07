% Inititialize g(x,y)
% Type 1 SG Model Equations
% Type 1 AVR Model Equations
% Type 2 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);
eqp   = x0(pointer_sv(i)+2);
efd   = x0(pointer_sv(i)+3);
vr    = x0(pointer_sv(i)+4);
y1    = x0(pointer_sv(i)+5);
y3    = x0(pointer_sv(i)+6);
Tm    = x0(pointer_sv(i)+7);

% Loading SG algebraic variables
iq      = y(pointer_av(i)-nsv+0);
id      = y(pointer_av(i)-nsv+1);
y2      = y(pointer_av(i)-nsv+2);
efd_sat = y(pointer_av(i)-nsv+3);
y2_sat  = y(pointer_av(i)-nsv+4);

% Loading inputs
Pc    = u0(nin*(i-1)+1); %%%% nin can change acording to other models

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xd    = dyn.gen(i,5);
Xdp   = dyn.gen(i,6);
Xq    = dyn.gen(i,7);
Xqp   = dyn.gen(i,8);
Vmin  = dyn.avr(i,12);
Vmax  = dyn.avr(i,13);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
k     = SG_bus(i);

% SG equivalent circuit (id, iq) and governor alg. variable (y2)
if (genout == i)
    out(pointer_av(i)-nsv+0) = iq;
    out(pointer_av(i)-nsv+1) = id;
    out(pointer_av(i)-nsv+2) = y2;
    out(pointer_av(i)-nsv+3) = efd_sat;
    out(pointer_av(i)-nsv+4) = y2_sat;

else
    out(pointer_av(i)-nsv+0) =     - V(k)*sin(delta - theta(k)) - Rs*id + Xq*iq;
    out(pointer_av(i)-nsv+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;
    out(pointer_av(i)-nsv+2) = -y2 + (1 - T2/T3)*y3 + (T2/T3)*y1;

    if efd > Vmin && efd < Vmax
        out(pointer_av(i)-nsv+3) = -efd_sat + efd;
    elseif efd <= Vmin
        out(pointer_av(i)-nsv+3) = -efd_sat + Vmin;
    elseif efd >= Vmax
        out(pointer_av(i)-nsv+3) = -efd_sat + Vmax;
    end
    if y2 < Pc-Pmin && y2 > Pc-Pmax
        out(pointer_av(i)-nsv+4) = -y2_sat + y2;
    elseif y2 >= Pc-Pmin
        out(pointer_av(i)-nsv+4) = -y2_sat + Pc-Pmin;
    elseif y2 <= Pc-Pmax
        out(pointer_av(i)-nsv+4) = -y2_sat + Pc-Pmax;
    end
end