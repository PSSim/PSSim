% Inititialize g(x,y)
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations
% Type 0 GOV Model Equations

% Loading state variables
delta = x0(pointer_sv(i)+0);
w     = x0(pointer_sv(i)+1);

% Loading SG algebraic variables
iy    = y(pointer_av(i)-nsv+0);
ix    = y(pointer_av(i)-nsv+1);

% Loading inputs
Pm    = u0(nin*(i-1)+1);  %%% Check if updates
Ei    = u0(nin*(i-1)+2);

% Loading parameters
Xdp   = dyn.gen(i,6);
k     = SG_bus(i);

% Other variables
E  = Ei*exp(1i*delta);

if genout == i 
% SG equivalent circuit (id, iq) and governor alg. variable (y2)
out(pointer_av(i)-nsv+0) = iy;
out(pointer_av(i)-nsv+1) = ix;
else
% SG equivalent circuit (id, iq) and governor alg. variable (y2)
out(pointer_av(i)-nsv+0) = real(-E + (ix+1i*iy)*1i*Xdp + V_ph(k));
out(pointer_av(i)-nsv+1) = imag(-E + (ix+1i*iy)*1i*Xdp + V_ph(k));
end