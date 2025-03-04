%% Plots Dynamic Simulation
global n m mpc nsv nav nav_SG nav_IBR nin u0 u01 u02 genout
SG_bus =  mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end

% Select an SG and IBR to plot
i  = 2; % SG  to plot
ii = 2; % IBR to plot

%% SG plots
k = SG_bus(i);

% Extract Models Type
SG_type = [dyn.gen(i,2);dyn.avr(i,2);dyn.gov(i,2)];
[nsv_SGi,nav_SGi] = var_num(SG_type);

% Convert SG_type to a unique identifier
SG_key = sprintf('%d%d%d', SG_type(1), SG_type(2), SG_type(3));

% Load SG model using switch-case
switch SG_key
    case '000' %
        plot_type0;
    case '001' %
        plot_type001;
    case '002' %
        plot_type002;
    case '003' %
        plot_type003;
    case '111' %
        plot_type111;
    case '112' %
        plot_type112;
    case '113' %
        plot_type113;
    case '121' %
        plot_type121;
    case '122' %
        plot_type122;
    case '123' %
        plot_type123;
    case '131' %
        plot_type131;
    case '132' %
        plot_type132;
    case '133' %
        plot_type133;
    case '211' %
        plot_type211;
    case '212' %
        plot_type212;
    case '213' %
        plot_type213;
    case '221' %
        plot_type221;
    case '222' %
        plot_type222;
    case '223' %
        plot_type223;
    case '231' %
        plot_type231;
    case '232' %
        plot_type232;
    case '233' %
        plot_type233;
    otherwise
        error('Invalid SG_type combination');
end

%% IBR Plot
if l ~= 0
    k = IBR_bus(ii);
    % Extract IBR model type
    IBR_type = [dyn.ibr(ii,2);dyn.control(ii,2)];
    [nsv_IBRi,nav_IBRi] = var_num_ibr(IBR_type);
    % Load IBR model
    if      IBR_type(1) == 1 && IBR_type(2) == 1 %
        plot_ibr_type11;
    elseif  IBR_type(1) == 1 && IBR_type(2) == 2 % %
        plot_ibr_type12; 
    end
end

%% Bus variables plot (Vi, thetai)
V     = z(:,nsv+nav-2*n+1:nsv+nav-n);
theta = z(:,nsv+nav-n+1:end);
theta_est = z(:,nsv-n+1:nsv);
w_est     = z(:,nsv+sum(nav_SG)+sum(nav_IBR)+1:nsv+sum(nav_SG)+sum(nav_IBR)+n);

figure(4)
subplot(2,1,1)
plot(t,V)
ylabel('Voltage, p.u.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
title('Bus Voltages: $V_i$','Interpreter','Latex')

subplot(2,1,2)
plot(t,theta*180/pi)
ylabel('Angle, deg.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
title('Bus Angles: $\theta_i$','Interpreter','Latex')

figure(5)
subplot(2,1,1)
plot(t,theta_est*180/pi)
ylabel('Angle, deg.','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
title('Estimated Bus Angles: $\hat{\theta_i}$','Interpreter','Latex')

subplot(2,1,2)
plot(t,w_est*60); hold on
ylabel('Estimated Frequency, Hz','Interpreter','Latex')
xlabel('Time, s','Interpreter','Latex')
title('SG Speeds: $\hat{f_i}$','Interpreter','Latex')

%% SG main variables (delta, w)
for i = 1:m
    delta = z(:,pointer_sv(i)+0);
    w     = z(:,pointer_sv(i)+1);

    if genout == i % Hide genout variables
    figure(6)
    subplot(2,1,1)
    plot(t,delta*180/pi,'w-'); hold on; 
    ylabel('Angle, deg.','Interpreter','Latex')
    xlabel('Time, s','Interpreter','Latex')
    title('SG Angles: $\delta_i$','Interpreter','Latex')

    subplot(2,1,2)
    plot(t,w*60,'w-'); hold on; 
    ylabel('Frequency, Hz','Interpreter','Latex')
    xlabel('Time, s','Interpreter','Latex')
    title('SG Frequencies: $f_i$','Interpreter','Latex')
    else
    figure(6)
    subplot(2,1,1)
    plot(t,delta*180/pi); hold on
    ylabel('Angle, deg.','Interpreter','Latex')
    xlabel('Time, s','Interpreter','Latex')
    title('SG Angles: $\delta_i$','Interpreter','Latex')

    subplot(2,1,2)
    plot(t,w*60); hold on
    ylabel('Frequency, Hz','Interpreter','Latex')
    xlabel('Time, s','Interpreter','Latex')
    title('SG Frequencies: $f_i$','Interpreter','Latex')
    end
end

% Center of inertia
H_sum = 0;
w_coi = zeros(size(z(:,1)));
for i = 1:m
    w     = z(:,pointer_sv(i)+1);
    H     = dyn.gen(i,3);
    
    if (genout == i)
        H = 0;
    end
    H_sum = H_sum + H;
    w_coi = w_coi + H*w;
end
w_coi = w_coi/H_sum;

figure(6)
subplot(2,1,2)
plot(t,w_coi*60,'k','Linewidth',1.2);
