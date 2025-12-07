% Initialization
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations (No AVR)
% Type 2 GOV Model Equations

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xdp   = dyn.gen(i,6);
D     = dyn.gen(i,11);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
k     = SG_bus(i);

% Data from mpc
Pd    = -mpc.bus(k,3);
Qd    = -mpc.bus(k,4);
exp_P = dyn.bus(k,2);
exp_Q = dyn.bus(k,3);
base  = mpc.baseMVA;
Pd    = (Pd/base)*V(k)^exp_P;
Qd    = (Qd/base)*V(k)^exp_Q;
Pi    = real(S_phasor(k));
Qi    = imag(S_phasor(k));
I     = ((Pi-Pd)-1i*(Qi-Qd))*exp(1i*theta(k))/V(k);

% Torque angle
E     = V_phasor(k) + 1j*Xdp*I;
Ei    = abs(E);
delta = angle(E);

% Currents and voltages in the dq frame
ix    = real(I);
iy    = imag(I);

% Omega and mech. power
w     = 1;
Tm    = real(E*conj(I));

% Governor/turbine and input Pc
y1     = 0;
y2     = 0;
y2_sat = y2;
y3     = 0;
Pc     = Tm;

% Variable sorting
zz0(pointer_sv(i):pointer_sv(i)+sum(nsv_SGi)-1,1) = [delta; w; y1; y3; Tm];
zz0(pointer_av(i):pointer_av(i)+sum(nav_SGi)-1,1) = [iy; ix; y2; y2_sat];
u0((i-1)*nin+1:i*nin,1)                           = [Pc; Ei];   

% Out of limits messages
if y2 >= Pc-Pmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('y2 > Pc-Pmin for SG%2.0f', i);
elseif y2 <= Pc-Pmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('y2 < Pc-Pmax for SG%2.0f', i);
end