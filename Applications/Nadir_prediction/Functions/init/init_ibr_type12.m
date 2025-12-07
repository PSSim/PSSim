% Initialization
% Type 1 IBR Model Equations
% Type 2 IBR Control Model Equations

% IBR Parameters
TQ  = dyn.ibr(i,3);
TD  = dyn.ibr(i,4);
Rf  = dyn.ibr(i,5);    
Xf  = dyn.ibr(i,6);
Teq = dyn.ibr(i,7);
Ted = dyn.ibr(i,8);
k   = IBR_bus(i); % Bus index of the IBRi

% Control Paramerers
Kiq  = dyn.control(i,3);
TGqv = dyn.control(i,4);
Kip  = dyn.control(i,5); 
TGpv = dyn.control(i,6);
Qmax = dyn.control(i,7);
Qmin = dyn.control(i,8);
Pmax = dyn.control(i,9);
Pmin = dyn.control(i,10);
Tr   = dyn.control(i,11);   
Rq   = dyn.control(i,12);
Ki   = dyn.control(i,13);
Kp   = dyn.control(i,14);
Tfrq = dyn.control(i,15);
Rp   = dyn.control(i,16);

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
Pg    = Pi-Pd; 
Qg    = Qi-Qd;

% Torque angle
phi = theta(k);

% Voltages in the dq frame
vd  = real(V_phasor(k)*exp(-1i*phi));
vq  = imag(V_phasor(k)*exp(-1i*phi));

% dq frame current 
iq    = imag(I*exp(-1i*phi));
id    = real(I*exp(-1i*phi));

% Real and imag parts of the internal voltage source
Ex  = vd + id*Rf - iq*Xf;
Ey  = vq + iq*Rf + id*Xf;

% dq frame voltage
Ed    = Ex;
Eq    = Ey;

% Internal model variables
iiq = iq;
iid = id;

% Current commands
IQcmd = -iiq;
IPcmd = iid;

% Internal variables IBR control
s5   = V(k);
Qcmd = Qg;
s1   = Qcmd;
Vref = s5 + Rq*Qg;
s6   = s1 - Kp*(Vref - s5 - Rq*Qg);
s2   = IQcmd - Qcmd/V(k);

Pcmd = Pg;
s3   = Pcmd;
s7   = 0;
Pref = s3 + s7/Rp;
s4   = IPcmd - Pcmd/V(k);

% Variable sorting
zz0(pointer_sv_ibr(i):pointer_sv_ibr(i)+sum(nsv_IBRi)-1,1) = [iiq; iid; Ex; Ey; s1; s2; s5; s6; s3; s4; s7];
zz0(pointer_av_ibr(i):pointer_av_ibr(i)+sum(nav_IBRi)-1,1) = [iq; id; Ed; Eq; Qcmd; IQcmd; Pcmd; IPcmd];
u0(m*nin+nin*(i-1)+1:m*nin+nin*(i-1)+2,1)                  = [Pref; Vref];  

% Out of limits messages
if s1 < Qmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('s1 < Qmin for IBR%2.0f', i);
elseif s1 > Qmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('s1 > Qmax for IBR%2.0f', i); 
end    
if s3 < Pmin
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('s3 < Pmin for IBR%2.0f', i);
elseif s3 > Pmax
    fprintf('INITIALIZATION OVER/BELOW LIMITS !!! \n')
    error('s3 > Pmax for IBR%2.0f', i); 
end