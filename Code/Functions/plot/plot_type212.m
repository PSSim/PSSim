% Plots
% Type 2 SG Model Equations
% Type 1 AVR Model Equations
% Type 2 GOV Model Equations

% State variables
delta = z(:,pointer_sv(i)+0);
w     = z(:,pointer_sv(i)+1);
eqp   = z(:,pointer_sv(i)+2);
edp   = z(:,pointer_sv(i)+3);
efd   = z(:,pointer_sv(i)+4);
vr    = z(:,pointer_sv(i)+5);
y1    = z(:,pointer_sv(i)+6);
y3    = z(:,pointer_sv(i)+7);
Tm    = z(:,pointer_sv(i)+8);

% Algebraic variables
iq      = z(:,pointer_av(i)+0);
id      = z(:,pointer_av(i)+1);
y2      = z(:,pointer_av(i)+2);
efd_sat = z(:,pointer_av(i)+3);
y2_sat  = z(:,pointer_av(i)+4);
V       = z(:,nsv+nav-2*n+k);
theta   = z(:,nsv+nav-n+k);

% Indirect variables
P     = real(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*(delta-pi/2))));
Q     = imag(V.*exp(1i*theta).*conj((id+1i*iq).*exp(1i*(delta-pi/2))));
vd    = real(V.*exp(1i*theta).*exp(-1i*(delta-pi/2)));
vq    = imag(V.*exp(1i*theta).*exp(-1i*(delta-pi/2)));

figure(1)
title_index = sprintf('SG Type 212 - Bus %d',k);
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
plot(t,efd,'--',t,efd_sat)
ylabel('Voltage, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$E_{fd}$','$E_{fd_sat}$','Interpreter','Latex')

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

subplot(3,3,4)
plot(t,y2,'--',t,y2_sat)
ylabel('$y_i$, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$y_2$','$y_{2-sat}$','Interpreter','Latex')

figure(2)
title_index = sprintf('Phase portrait at generator bus %d',k);
plot(delta,w); grid on
xlabel('$\delta$, rad','Interpreter','Latex')
ylabel('$\omega$, p.u.','Interpreter','Latex')
title(title_index,'Interpreter','Latex')


