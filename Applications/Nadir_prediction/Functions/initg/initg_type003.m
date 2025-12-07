% Inititialize g(x,y)
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations (No AVR)
% Type 3 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);
xg1   = x0(pointer_sv(i)+2);
xg2   = x0(pointer_sv(i)+3);
xg3   = x0(pointer_sv(i)+4);

% Loading SG algebraic variables
iy      = y(pointer_av(i)-nsv+0);
ix      = y(pointer_av(i)-nsv+1);
Tm      = y(pointer_av(i)-nsv+2);
xg1_sat = y(pointer_av(i)-nsv+3);

% Loading inputs
Pc    = u0(nin*(i-1)+1); 
Ei    = u0(nin*(i-1)+2);

% Loading parameters
Xdp   = dyn.gen(i,6);
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
k     = SG_bus(i);

% Other variables
E  = Ei*exp(1i*delta);

if genout == i 
    % SG equivalent circuit (id, iq) and governor alg. variable (Tm, y1_sat)
    out(pointer_av(i)-nsv+0) = iy;
    out(pointer_av(i)-nsv+1) = ix;
    out(pointer_av(i)-nsv+2) = Tm; 
    out(pointer_av(i)-nsv+3) = xg1_sat;
else
    % SG equivalent circuit (id, iq) and governor alg. variable (y2)
    out(pointer_av(i)-nsv+0) = real(-E + (ix+1i*iy)*1i*Xdp + V_ph(k));
    out(pointer_av(i)-nsv+1) = imag(-E + (ix+1i*iy)*1i*Xdp + V_ph(k));
    out(pointer_av(i)-nsv+2) = -Tm + xg2 - Dt*(w-1);
    if xg1 > Pmin && xg1 < Pmax
        out(pointer_av(i)-nsv+3) = -xg1_sat + xg1; 
    elseif xg1 <= Pmin
        out(pointer_av(i)-nsv+3) = -xg1_sat + Pmin;
    elseif xg1 >= Pmax
        out(pointer_av(i)-nsv+3) = -xg1_sat + Pmax;
    end
end