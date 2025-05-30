% Initialization
% Type 1 SG Model Equations
% Type 1 AVR Model Equations
% Type 1 GOV Model Equations

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
TE    = dyn.avr(i,6);
TB    = dyn.avr(i,9);
Vmin  = dyn.avr(i,12);
Vmax  = dyn.avr(i,13);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Dt    = dyn.gov(i,8);
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
delta = angle(V_phasor(k) + (Rs + 1i*Xq)*I);

% Currents and voltages in the dq frame
id    = real(I*exp(-1i*(delta-pi/2)));
iq    = imag(I*exp(-1i*(delta-pi/2)));
vd    = real(V_phasor(k)*exp(-1i*(delta-pi/2)));
vq    = imag(V_phasor(k)*exp(-1i*(delta-pi/2)));

% Eq'
eqp   = vq + Rs*iq + Xdp*id;

% Efd
efd     = eqp + (Xd - Xdp)*id;
efd_sat = efd;

% AVR variables and input Vref
vr    = (1-TA/TB)*efd/KA;
Vref  = efd/KA + abs(V_phasor(k));

% Omega and mech. torque
w     = 1;
Tm    = eqp*iq + (Xq-Xdp)*id*iq;

% Governor/turbine and input Pc
y1     = Tm;
y1_sat = y1;
y2     = Tm*(1 - T2/T3);
Pc     = Tm/K1;
   
% Variable sorting
zz0(pointer_sv(i):pointer_sv(i)+sum(nsv_SGi)-1,1) = [delta; w; eqp; efd; vr; y1; y2];
zz0(pointer_av(i):pointer_av(i)+sum(nav_SGi)-1,1) = [iq; id; Tm; efd_sat; y1_sat];
u0((i-1)*nin+1:i*nin,1)                           = [Pc; Vref];   

% Out of limits messages
if efd <= Vmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('efd < Vmin for SG%2.0f', i);
elseif efd >= Vmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('efd > Vmax for SG%2.0f', i);
end
if y1 <= Pmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('y1 > Pmin for SG%2.0f', i);
elseif y1 >= Pmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('y1 > Pmax for SG%2.0f', i);
end