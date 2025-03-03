%% Plots
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations (No AVR)
% Type 1 GOV Model Equations

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xd    = dyn.gen(i,5);
Xdp   = dyn.gen(i,6);
Xq    = dyn.gen(i,7);
Xqp   = dyn.gen(i,8);
Td0p  = dyn.gen(i,9);
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
xg1   = z(:,pointer_sv(i)+2);
xg2   = z(:,pointer_sv(i)+3);
xg3   = z(:,pointer_sv(i)+4);

% Algebraic variables
iy      = z(:,pointer_av(i)+0);
ix      = z(:,pointer_av(i)+1);
Tm      = z(:,pointer_av(i)+2);
xg1_sat = z(:,pointer_av(i)+3);
V       = z(:,nsv+nav-2*n+k);
theta   = z(:,nsv+nav-n+k);

% Indirect variables
P     = real(V.*exp(1i*theta).*conj((ix+1i*iy)));
Q     = imag(V.*exp(1i*theta).*conj((ix+1i*iy)));

figure(1)
title_index = sprintf('SG Type 003 - Bus %d',k);
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

subplot(3,3,4)
plot(t,xg1,'--',t,xg1_sat,t,xg2,t,xg3)
ylabel('$x_{gi}$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$x_{g1}$','$x_{g1-sat}$','$x_{g2}$','$x_{g3}$','Interpreter','Latex')

subplot(3,3,9)
plot(t,ix,t,iy)
ylabel('Current, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$i_x$','$i_y$','Interpreter','Latex')

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