% Initialization
% Type 1 SG Model Equations
% Type 2 AVR Model Equations
% Type 3 GOV Model Equations

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
At    = dyn.gov(i,11);
Kt    = dyn.gov(i,12);
k     = SG_bus(i); % Bus index of the SGi

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
delta = angle(V_phasor(k) + (Rs + 1i*Xq)*I);

% Currents and voltages in the dq frame
id    = real(I*exp(-1i*(delta-pi/2)));
iq    = imag(I*exp(-1i*(delta-pi/2)));
vd    = real(V_phasor(k)*exp(-1i*(delta-pi/2)));
vq    = imag(V_phasor(k)*exp(-1i*(delta-pi/2)));

% Eq'
eqp   = vq + Rs*iq + Xdp*id;

% Efd
efd   = eqp + (Xd - Xdp)*id;

% AVR variables and input Vref
vr     = KE*efd;
vr_sat = vr;
rf     = efd*KF/TF;
Vref   = abs(V_phasor(k)) + vr/KA;

% Omega and mech. torque
w     = 1;
Tm    = eqp*iq + (Xq-Xdp)*id*iq;

% Governor/turbine and input Pc
xg2     = Tm;
xg3     = xg2;
xg1     = xg2;
xg1_sat = xg1;
Pc      = Tm;

% Variable sorting
zz0(pointer_sv(i):pointer_sv(i)+sum(nsv_SGi)-1,1) = [delta; w; eqp; efd; rf; vr; xg1; xg2; xg3];
zz0(pointer_av(i):pointer_av(i)+sum(nav_SGi)-1,1) = [iq; id; Tm; vr_sat; xg1_sat];
u0((i-1)*nin+1:i*nin,1)                           = [Pc; Vref]; 

% Out of limits messages
if vr <= Vrmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('vr < Vrmin for SG%2.0f', i);
elseif vr >= Vrmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('vr > Vrmax for SG%2.0f', i);
end
if xg1 <= Pmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('xg1 < Pmin for SG%2.0f', i);
elseif xg1 >= Pmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('xg1 > Pmax for SG%2.0f', i);
end