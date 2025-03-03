%% Power System Dynamic Simulator
close all
clear all
clc
tic
%% General Data
global n m l mpc dyn Ybus ws nsv nsv_SG nsv_IBR nav nav_SG nav_IBR nin u0 u01 u02 genout V0 x0
global pointer_sv pointer_av pointer_sv_ibr pointer_av_ibr nsv_PMU nav_PMU 

% Load data
cd 'Data'
mpc   = eval('case118');
dyn   = eval('case118_dyn');
cd ..

%% Global parameters
[n,~]  = size(mpc.bus); % n : number of buses
[m,~]  = size(mpc.gen); % m : number of SGs
[l,~]  = size(mpc.ibr); % l : number of IBRs
nsv_SG = [];
nav_SG = [];
pointer_sv = zeros(m,1);
pointer_av = zeros(m,1);
cd 'Functions'
for i = 1:m
    SG_type = [dyn.gen(i,2);dyn.avr(i,2);dyn.gov(i,2)];
    [nsv_SGi,nav_SGi] = var_num(SG_type);
    pointer_sv(i,1) = sum(nsv_SG)+1; 
    pointer_av(i,1) = sum(nav_SG)+1; 
    nsv_SG = [nsv_SG; sum(nsv_SGi)]; % number of state variables for each SG
    nav_SG = [nav_SG; sum(nav_SGi)]; % number of algebraic variables for each SG
end
cd ..
nsv_IBR = [];
nav_IBR = [];
pointer_sv_ibr = zeros(l,1);
pointer_av_ibr = zeros(l,1);
cd 'Functions'
for i = 1:l
    IBR_type = [dyn.ibr(i,2);dyn.control(i,2)];
    [nsv_IBRi,nav_IBRi] = var_num_ibr(IBR_type);
    pointer_sv_ibr(i,1) = sum(nsv_IBR)+1; 
    pointer_av_ibr(i,1) = sum(nav_IBR)+1; 
    nsv_IBR = [nsv_IBR; sum(nsv_IBRi)]; % number of state variables for each IBR
    nav_IBR = [nav_IBR; sum(nav_IBRi)]; % number of algebraic variables for each IBR
end
cd ..
nsv_PMU = 1;                                                % number of state variables per each PMU (at all buses)
nav_PMU = 1;                                                % number of algebraic vatiables per each PMU (at all buses)
nsv     = sum(nsv_SG) + sum(nsv_IBR) + nsv_PMU*n;           % total number of state variables 
nav     = sum(nav_SG) + sum(nav_IBR) + nav_PMU*n + 2*n;     % total number of algebraic variables (grid + SG)
nin     = 2;                                                % number of inputs (Pc and Vref) for SGs and IBRs (Pref and Qref/Vref)
ws      = 2*pi*60;                                          % nominal frequency in rad/s
u0      = zeros(nin*(m+l),1);                               % Assumption: only 2 inputs per element (SG inputs: Pc and Vref, IBR inputs: Pref and Qref/Vref)
pointer_av = pointer_av + nsv;
pointer_sv_ibr = sum(nsv_SG)+pointer_sv_ibr;
pointer_av_ibr = nsv + sum(nav_SG) + pointer_av_ibr;

%% Dynamic Simulation
% Simulation parameters
M              = zeros(nsv+nav,nsv+nav);
M(1:nsv,1:nsv) = eye(nsv);
options        = odeset('Mass',M,'RelTol',5e-3,'MaxStep',200e-3);

cd 'Functions'
fprintf('\n--- PRE-FAULT CONDITION ---\n')
genout   = 0;
Ybus0    = Y_bus;
Ybus     = Ybus0;
y0       = power_flow;
[z01,u0] = init_pf(y0);
u01      = u0;
time     = [0 1];
[t1,z1]  = ode23t(@h,time,z01,options);
u1       = (u01*ones(1,length(t1)))'; 

%% Small-Signal Analysis
[Asys,L,V,W,PF] = small_signal(z01); 
figure(101)
for i = 1:nsv
    plot(real(L(i)),imag(L(i)),'bx','Linewidth',1.5);
    hold on
    grid on
    ylabel('Imag($\lambda_i$)','Interpreter','Latex')
    xlabel('Real($\lambda_i$)','Interpreter','Latex')
    title('Eigenvalue Plot','Interpreter','Latex')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% NO EVENT %%%
% fprintf('--- NO EVENT ---\n')
% % Concatenated results
% z = z1;
% t = t1;
% u = u1;
% cd ..
% %%% END NO EVENT %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START GENERATOR OUTAGE %%%
fprintf('--- GENERATOR OUTAGE EVENT ---\n')
genout  = 3; % generator number outage index (if not outage genout = 0)
Ybus    = Ybus0;
u02     = u01;
z02     = init(z1(end,:)');
time    = [1 30];
[t2,z2] = ode23t(@h,time,z02,options);
u2      = (u02*ones(1,length(t2)))'; 

% Concatenated results
z = [z1;z2];
t = [t1;t2];
u = [u1;u2];
cd ..
%%% END GENERATOR OUTAGE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% START LOAD IMPACT %%%
% k  = 59;   % Bus where the load will increase
% Fk = 1.5; % Increase factor (only on active power)
% mpc.bus(k,3) = Fk*mpc.bus(k,3);
% 
% fprintf('--- POST-EVENT CONDITION ---\n')
% Ybus    = Ybus0;
% z02     = init(z1(end,:)');
% u02     = u01;
% time    = [1 15];
% [t2,z2] = ode23t(@h,time,z02,options);
% u2      = (u02*ones(1,length(t2)))'; 
% 
% % Concatenated results
% z = [z1;z2];
% t = [t1;t2];
% u = [u1;u2];
% cd ..
% %%% END LOAD IMPACT %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START FAULT EVENT %%%
% % fprintf('--- DURING FAULT CONDITION ---\n')
% % For  9-bus system, start with fault at bus k = 7;
% % For 14-bus system, start with fault at bus k = 12;
% % For 39-bus system, start with fault at bus k = 20;
% % For 68-bus system, start with fault at bus k = 50;
% k       = 5;    % faulted bus (only a PQ bus where no IBR is connected)
% t_cl    = 5/60; % fault clearing time
% Ybus    = Y_bus_fault(k);
% z02     = init(z1(end,:)');
% u02     = u01;
% time    = [1 1+t_cl];
% [t2,z2] = ode23t(@h,time,z02,options);
% u2      = (u02*ones(1,length(t2)))'; 
% 
% fprintf('--- POST-FAULT CONDITION ---\n')
% Ybus    = Ybus0;
% z03     = init(z2(end,:)');
% u03     = u02;
% time    = [1+t_cl 15];
% [t3,z3] = ode23t(@h,time,z03,options);
% u3      = (u03*ones(1,length(t3)))'; 
% 
% % Concatenated results
% z = [z1;z2;z3];
% t = [t1;t2;t3];
% u = [u1;u2;u3];
% cd ..
% %%% END FAULT EVENT %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% IBR P/Q/V REFERENCE CHANGE %%%
% fprintf('--- IBR P/Q/V REFERENCE CHANGE EVENT ---\n')
% Ybus        = Ybus0;
% nIBR_change = 1;
% Qref_new    = 0.5; % in per unit
% u0(m*nin+nin*(nIBR_change-1)+2) = Qref_new;
% u02         = u0;
% z02         = init(z1(end,:)');
% time        = [1 20];
% [t2,z2]     = ode23t(@h,time,z02,options);
% u2          = (u02*ones(1,length(t2)))'; 
% % Concatenated results
% z = [z1;z2];
% t = [t1;t2];
% u = [u1;u2];
% cd ..
% %%% IBR P/Q/V REFERENCE CHANGE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots
plots_dyn;

%% Post-Event Equilibrium Point
% if (genout ~= 0)
%     zeq_post = NR_eq(@h,z02);
% else
%     zeq_post = NR_eq(@h,z01);
% end

%% Simulation Time
elapsedTime = toc;
fprintf('\n Total Simualtion Time: %2.2f seconds \n', elapsedTime)