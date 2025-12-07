% Inititialize g(x,y)
% Type 2 SG  Model Equations
% Type 2 AVR Model Equations
% Type 1 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);
eqp   = x0(pointer_sv(i)+2);
edp   = x0(pointer_sv(i)+3);
efd   = x0(pointer_sv(i)+4);
rf    = x0(pointer_sv(i)+5);
vr    = x0(pointer_sv(i)+6);
y1    = x0(pointer_sv(i)+7);
y2    = x0(pointer_sv(i)+8);

% Loading SG algebraic variables
iq     = y(pointer_av(i)-nsv+0);
id     = y(pointer_av(i)-nsv+1);
Tm     = y(pointer_av(i)-nsv+2);
vr_sat = y(pointer_av(i)-nsv+3);
y1_sat = y(pointer_av(i)-nsv+4);

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xd    = dyn.gen(i,5);
Xdp   = dyn.gen(i,6);
Xq    = dyn.gen(i,7);
Xqp   = dyn.gen(i,8);
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
k     = SG_bus(i);

% SG equivalent circuit (id, iq) and governor alg. variable (Tm)
if (genout == i)
    out(pointer_av(i)-nsv+0) = iq;
    out(pointer_av(i)-nsv+1) = id;
    out(pointer_av(i)-nsv+2) = Tm;
    out(pointer_av(i)-nsv+3) = vr_sat;
    out(pointer_av(i)-nsv+4) = y1_sat;
else
    out(pointer_av(i)-nsv+0) = edp - V(k)*sin(delta - theta(k)) - Rs*id + Xqp*iq;
    out(pointer_av(i)-nsv+1) = eqp - V(k)*cos(delta - theta(k)) - Rs*iq - Xdp*id;
    out(pointer_av(i)-nsv+2) = -Tm + y2 + (T2/T3)*y1_sat - Dt*(w - 1); % What if 1 = w_ref?
    if vr > Vrmin && vr < Vrmax
        out(pointer_av(i)-nsv+3) = -vr_sat + vr;
    elseif vr <= Vrmin
        out(pointer_av(i)-nsv+3) = -vr_sat + Vrmin;
    elseif vr >= Vrmax
        out(pointer_av(i)-nsv+3) = -vr_sat + Vrmax;
    end
    if y1 > Pmin && y1 < Pmax
        out(pointer_av(i)-nsv+4) = -y1_sat + y1;
    elseif y1 <= Pmin
        out(pointer_av(i)-nsv+4) = -y1_sat + Pmin;
    elseif y1 >= Pmax
        out(pointer_av(i)-nsv+4) = -y1_sat + Pmax;
    end
end