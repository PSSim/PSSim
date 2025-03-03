% Plots
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

% State variables
delta = z(:,pointer_sv(i)+0);
w     = z(:,pointer_sv(i)+1);
eqp   = z(:,pointer_sv(i)+2);
efd   = z(:,pointer_sv(i)+3);
rf    = z(:,pointer_sv(i)+4);
vr    = z(:,pointer_sv(i)+5);
xg1   = z(:,pointer_sv(i)+6);
xg2   = z(:,pointer_sv(i)+7);
xg3   = z(:,pointer_sv(i)+8);

% Algebraic variables
iq      = z(:,pointer_av(i)+0);
id      = z(:,pointer_av(i)+1);
Tm      = z(:,pointer_av(i)+2);
vr_sat  = z(:,pointer_av(i)+3);
xg1_sat = z(:,pointer_av(i)+4);
edp     = (Xq-Xqp)*iq;
V       = z(:,nsv+nav-2*n+k);
theta   = z(:,nsv+nav-n+k);

% Indirect variables
P     = real(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*(delta-pi/2))));
Q     = imag(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*(delta-pi/2))));
vd    = real(V.*exp(1i*theta).*exp(-1i*(delta-pi/2)));
vq    = imag(V.*exp(1i*theta).*exp(-1i*(delta-pi/2)));

figure(1)
title_index = sprintf('SG Type 123 - Bus %d',k);
sgtitle(title_index,'Interpreter','Latex')
subplot(3,3,3)
plot(t,delta*180/pi)
ylabel('Angle, deg.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$\delta$','Interpreter','Latex')

subplot(3,3,1)
plot(t,w*60)
ylabel('Frequency, Hz','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$f$','Interpreter','Latex')

subplot(3,3,6)
plot(t,edp,t,eqp)
ylabel('$E^{\prime}$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$E_d^{\prime}$','$E_q^{\prime}$','Interpreter','Latex')

subplot(3,3,5)
plot(t,efd,t,vr,'--',t,vr_sat)
ylabel('Voltage, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$E_{fd}$','$V_r$','$V_{r-sat}$','Interpreter','Latex')

subplot(3,3,4)
plot(t,xg1,'--',t,xg1_sat,t,xg2,t,xg3)
ylabel('$x_{gi}$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$x_{g1}$','$x_{g1-sat}$','$x_{g2}$','$x_{g3}$','Interpreter','Latex')

subplot(3,3,9)
plot(t,id,t,iq)
ylabel('Current, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$i_d$','$i_q$','Interpreter','Latex')

subplot(3,3,2)
plot(t,V)
ylabel('Voltage, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$V$','Interpreter','Latex')

subplot(3,3,7)
plot(t,P*100,t,Tm*100)
ylabel('Real Power, MW','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$P$','$T_m$','Interpreter','Latex')

subplot(3,3,8)
plot(t,Q*100)
ylabel('Reactive Power, MVAr','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$Q$','Interpreter','Latex')

figure(2)
title_index = sprintf('Phase portrait at generator bus %d',k);
plot(delta,w); grid on
xlabel('$\delta$, rad','Interpreter','Latex')
ylabel('$\omega$, p.u.','Interpreter','Latex')
title(title_index,'Interpreter','Latex')