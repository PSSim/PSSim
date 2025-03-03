% Inititialize g(x,y)
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

% State Variables
iiq = x0(pointer_sv_ibr(i)+0);
iid = x0(pointer_sv_ibr(i)+1);
Ex  = x0(pointer_sv_ibr(i)+2);
Ey  = x0(pointer_sv_ibr(i)+3);
s1  = x0(pointer_sv_ibr(i)+4);
s2  = x0(pointer_sv_ibr(i)+5);
s5  = x0(pointer_sv_ibr(i)+6);
s6  = x0(pointer_sv_ibr(i)+7);
s3  = x0(pointer_sv_ibr(i)+8);
s4  = x0(pointer_sv_ibr(i)+9);
s7  = x0(pointer_sv_ibr(i)+10);

% Algebraic Variables
iq    = y(pointer_av_ibr(i)-nsv+0);
id    = y(pointer_av_ibr(i)-nsv+1);
Ed    = y(pointer_av_ibr(i)-nsv+2);
Eq    = y(pointer_av_ibr(i)-nsv+3);
Qcmd  = y(pointer_av_ibr(i)-nsv+4);
IQcmd = y(pointer_av_ibr(i)-nsv+5);
Pcmd  = y(pointer_av_ibr(i)-nsv+6);
IPcmd = y(pointer_av_ibr(i)-nsv+7);

% Inputs
Pref = u0(m*nin+nin*(i-1)+1);
Vref = u0(m*nin+nin*(i-1)+2);

% Grid variables
phi   = theta(k); 
Pg    = real(V_ph(k)*conj((id+1i*iq).*exp(1i*phi))); % Current is on the grid side
Qg    = imag(V_ph(k)*conj((id+1i*iq).*exp(1i*phi))); % Current is on the grid side
vd    = real(V_ph(k)*exp(-1i*(phi)));
vq    = imag(V_ph(k)*exp(-1i*(phi))); 
Vt    = abs(V_ph(k));
w_est = y(sum(nav_SG)+sum(nav_IBR)+k); 

%% Algebraic Equiations
% IBR model (REGC_B)
out(pointer_av_ibr(i)-nsv+0) = -Ex + vd + id*Rf  - iq*Xf;     
out(pointer_av_ibr(i)-nsv+1) = -Ey + vq + iq*Rf  + id*Xf;   
out(pointer_av_ibr(i)-nsv+2) = -Ed + vd + iid*Rf - iiq*Xf;
out(pointer_av_ibr(i)-nsv+3) = -Eq + vq + iiq*Rf + iid*Xf;     

% IBR control model (PQ mode)
if s1 > Qmin && s1 < Qmax
    out(pointer_av_ibr(i)-nsv+4) = -Qcmd  + s1; 
elseif s1 < Qmin
    out(pointer_av_ibr(i)-nsv+4) = -Qcmd  + Qmin; 
elseif s1 > Qmax
    out(pointer_av_ibr(i)-nsv+4) = -Qcmd  + Qmax; 
end
out(pointer_av_ibr(i)-nsv+5) = -IQcmd + s2 + Qcmd/Vt;     
if s3 > Pmin && s3 < Pmax
    out(pointer_av_ibr(i)-nsv+6) = -Pcmd  + s3; 
elseif s3 < Pmin
    out(pointer_av_ibr(i)-nsv+6) = -Pcmd  + Pmin; 
elseif s3 > Pmax
    out(pointer_av_ibr(i)-nsv+6) = -Pcmd  + Pmax; 
end
out(pointer_av_ibr(i)-nsv+7) = -IPcmd + s4 + Pcmd/Vt;