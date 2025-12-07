% Plots
% Type 0 SG Model Equations
% Type 0 AVR Model Equations
% Type 0 GOV Model Equations

% State variables
delta = z(:,pointer_sv(i)+0);
w     = z(:,pointer_sv(i)+1);

% Algebraic variables
iy    = z(:,pointer_av(i)+0);
ix    = z(:,pointer_av(i)+1);
V     = z(:,nsv+nav-2*n+k);
theta = z(:,nsv+nav-n+k);

% Loading inputs
Pm    = u0(nin*(i-1)+1)*ones(length(t),1); 
Ei    = u0(nin*(i-1)+2)*ones(length(t),1);

% Indirect variables
P     = real(V.*exp(1i*theta).*conj((ix+1i*iy)));
Q     = imag(V.*exp(1i*theta).*conj((ix+1i*iy)));

figure(1)
title_index = sprintf('SG Type 000 - Bus %d',k);
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
plot(t,P*100,t,Pm*100)
ylabel('Real Power, MW','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
legend('$P$','$P_m$','Interpreter','Latex')

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