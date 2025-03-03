% Plots
% Type 1 IBR Model Equations
% Type 1 IBR Control Model Equations

% IBR Parameters
TQ  = dyn.ibr(ii,3);
TD  = dyn.ibr(ii,4);
Rf  = dyn.ibr(ii,5);    
Xf  = dyn.ibr(ii,6);
Teq = dyn.ibr(ii,7);
Ted = dyn.ibr(ii,8);
k   = IBR_bus(ii); % Bus index of the IBRi

% Control Paramerers
Kiq  = dyn.control(ii,3);
TGqv = dyn.control(ii,4);
Kip  = dyn.control(ii,5); 
TGpv = dyn.control(ii,6);
Qmax = dyn.control(ii,7);
Qmin = dyn.control(ii,8);
Pmax = dyn.control(ii,9);
Pmin = dyn.control(ii,10);

% State Variables
iiq = z(:,pointer_sv_ibr(ii)+0);
iid = z(:,pointer_sv_ibr(ii)+1);
Ex  = z(:,pointer_sv_ibr(ii)+2);
Ey  = z(:,pointer_sv_ibr(ii)+3);
s1  = z(:,pointer_sv_ibr(ii)+4);
s2  = z(:,pointer_sv_ibr(ii)+5);
s3  = z(:,pointer_sv_ibr(ii)+6);
s4  = z(:,pointer_sv_ibr(ii)+7);

% Algebraic Variables
iq    = z(:,pointer_av_ibr(ii)+0);
id    = z(:,pointer_av_ibr(ii)+1);
Ed    = z(:,pointer_av_ibr(ii)+2);
Eq    = z(:,pointer_av_ibr(ii)+3);
Qcmd  = z(:,pointer_av_ibr(ii)+4);
IQcmd = z(:,pointer_av_ibr(ii)+5);
Pcmd  = z(:,pointer_av_ibr(ii)+6);
IPcmd = z(:,pointer_av_ibr(ii)+7);

% Algebraic variables
V     = z(:,nsv+nav-2*n+k);
theta = z(:,nsv+nav-n+k);
phi   = theta;

% Indirect variables
Pg   = real(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*phi)));
Qg   = imag(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*phi)));
if exist('u02','var')
    Pref = u(:,m*nin+nin*(ii-1)+1);
    Qref = u(:,m*nin+nin*(ii-1)+2);
else
    Pref = u0(m*nin+nin*(ii-1)+1)*ones(length(t),1); 
    Qref = u0(m*nin+nin*(ii-1)+2)*ones(length(t),1);
end
%%%%%%%

figure(3)
title_index = sprintf('IBR Type 11 - Bus %d',k);
sgtitle(title_index,'Interpreter','Latex')
subplot(3,3,2)
plot(t,-IQcmd,t,iiq,t,iq)
ylabel('Current, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$-I_{Qcmd}$','$ii_q$','$i_q$','Interpreter','Latex')

subplot(3,3,1)
plot(t,IPcmd,t,iid,t,id)
ylabel('Current, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$I_{Pcmd}$','$ii_d$','$i_d$','Interpreter','Latex')

subplot(3,3,3)
plot(t,Ed,t,Ex)
ylabel('$\Re(E)$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$E_d$','$E_x$','Interpreter','Latex')

subplot(3,3,5)
plot(t,V)
ylabel('Voltage, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$V$','Interpreter','Latex')

subplot(3,3,6)
plot(t,Eq,t,Ey)
ylabel('$\Im(E)$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$E_q$','$E_y$','Interpreter','Latex')

subplot(3,3,8)
plot(t,Qref*100,t,s1*100,'--',t,Qcmd*100,t,Qg*100)
ylabel('Reactive Power, MVAr','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$Q_{ref}$','$s_1$','$Q_{cmd}$','$Q_g$','Interpreter','Latex')

subplot(3,3,7)
plot(t,Pref*100,t,s3*100,'--',t,Pcmd*100,t,Pg*100)
ylabel('Real Power, MW','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$P_{ref}$','$s_3$','$P_{cmd}$','$P_g$','Interpreter','Latex')

subplot(3,3,9)
plot(t,s2,t,s4)
ylabel('$s_i$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$s_2$','$s_4$','Interpreter','Latex')
