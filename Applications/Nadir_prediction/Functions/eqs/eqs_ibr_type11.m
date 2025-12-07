% State and Algebraic Equations
% Type 1 IBR Model Equations
% Type 1 IBR Control Model Equations

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

% State Variables
iiq = z(pointer_sv_ibr(i)+0);
iid = z(pointer_sv_ibr(i)+1);
Ex  = z(pointer_sv_ibr(i)+2);
Ey  = z(pointer_sv_ibr(i)+3);
s1  = z(pointer_sv_ibr(i)+4);
s2  = z(pointer_sv_ibr(i)+5);
s3  = z(pointer_sv_ibr(i)+6);
s4  = z(pointer_sv_ibr(i)+7);

% Algebraic Variables
iq    = z(pointer_av_ibr(i)+0);
id    = z(pointer_av_ibr(i)+1);
Ed    = z(pointer_av_ibr(i)+2);
Eq    = z(pointer_av_ibr(i)+3);
Qcmd  = z(pointer_av_ibr(i)+4);
IQcmd = z(pointer_av_ibr(i)+5);
Pcmd  = z(pointer_av_ibr(i)+6);
IPcmd = z(pointer_av_ibr(i)+7);

% Inputs
Pref = u0(m*nin+nin*(i-1)+1);
Qref = u0(m*nin+nin*(i-1)+2);

% Grid variables
phi = theta(k); 
Pg  = real(V_ph(k)*conj((id+1i*iq).*exp(1i*phi))); % Current is on the grid side
Qg  = imag(V_ph(k)*conj((id+1i*iq).*exp(1i*phi))); % Current is on the grid side
vd  = real(V_ph(k)*exp(-1i*(phi)));
vq  = imag(V_ph(k)*exp(-1i*(phi))); % this one should be zero
Vt  = abs(V_ph(k));

%% State Equations
% IBR model (REGC_B)
out(pointer_sv_ibr(i)+0) = -(1/TQ)*(IQcmd + iiq);
out(pointer_sv_ibr(i)+1) =  (1/TD)*(IPcmd - iid);
out(pointer_sv_ibr(i)+2) =  (1/Ted)*(Ed - Ex);
out(pointer_sv_ibr(i)+3) =  (1/Teq)*(Eq - Ey);

% IBR control model (PQ mode)
out(pointer_sv_ibr(i)+4) = (1/TGqv)*(Qref - s1);
out(pointer_sv_ibr(i)+5) = Kiq*(Qcmd - Qg);
out(pointer_sv_ibr(i)+6) = (1/TGpv)*(Pref - s3);
out(pointer_sv_ibr(i)+7) = Kip*(Pcmd - Pg);

%% Algebraic Equiations
% IBR model (REGC_B)
out(pointer_av_ibr(i)+0) = -Ex + vd + id*Rf  - iq*Xf;     
out(pointer_av_ibr(i)+1) = -Ey + vq + iq*Rf  + id*Xf;   
out(pointer_av_ibr(i)+2) = -Ed + vd + iid*Rf - iiq*Xf;
out(pointer_av_ibr(i)+3) = -Eq + vq + iiq*Rf + iid*Xf;     

% IBR control model (PQ mode)
if s1 > Qmin && s1 < Qmax
    out(pointer_av_ibr(i)+4) = -Qcmd  + s1; 
elseif s1 < Qmin
    out(pointer_av_ibr(i)+4) = -Qcmd  + Qmin; 
elseif s1 > Qmax
    out(pointer_av_ibr(i)+4) = -Qcmd  + Qmax; 
end
out(pointer_av_ibr(i)+5) = -IQcmd + s2 + Qcmd/Vt;     
if s3 > Pmin && s3 < Pmax
    out(pointer_av_ibr(i)+6) = -Pcmd  + s3; 
elseif s3 < Pmin
    out(pointer_av_ibr(i)+6) = -Pcmd  + Pmin; 
elseif s3 > Pmax
    out(pointer_av_ibr(i)+6) = -Pcmd  + Pmax; 
end
out(pointer_av_ibr(i)+7) = -IPcmd + s4 + Pcmd/Vt;