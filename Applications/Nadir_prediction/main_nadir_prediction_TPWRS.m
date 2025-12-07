% Before running add the folder Functions and Data to the path (Rigth click
% add selected folders and subfolders to the path)

% Power System Dynamic Simulator
close all; clear all; clc; clear memory;

% General Data
global n m l mpc dyn Ybus ws nsv nsv_SG nsv_IBR nav nav_SG nav_IBR nin u0 u01 u02 genout V0 x0
global pointer_sv pointer_av pointer_sv_ibr pointer_av_ibr nsv_PMU nav_PMU 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load data
mpc   = eval('case9');
dyn   = eval('case9_dyn');

load_step_bus    =  7;
% factor_P         = 1.081; % Increase load factor
% factor_P         = 1.16; % Increase load factor
factor_P         = 1.27; % Increase load factor
gentrip          = 0; % If this is zero take the load step event (Don't trip slack bus)
event_time       = 20;

% Stores original load condition
act_mpc_bus = mpc.bus(:,3);

% Stores original inertia values
act_H = dyn.gen(:,3);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation settings independent from nadir prediction
%Global parameters
[n,~]  = size(mpc.bus); % n : number of buses
[m,~]  = size(mpc.gen); % m : number of SGs
[l,~]  = size(mpc.ibr); % l : number of IBRs
nsv_SG = [];
nav_SG = [];
pointer_sv = zeros(m,1);
pointer_av = zeros(m,1);
cd 'Functions'

indices = [];
for i = 1:m
    SG_type = [dyn.gen(i,2);dyn.avr(i,2);dyn.gov(i,2)];
    [nsv_SGi,nav_SGi] = var_num(SG_type);
    pointer_sv(i,1) = sum(nsv_SG)+1; 
    pointer_av(i,1) = sum(nav_SG)+1; 
    nsv_SG = [nsv_SG; sum(nsv_SGi)]; % number of state variables for each SG
    nav_SG = [nav_SG; sum(nav_SGi)]; % number of algebraic variables for each SG
    
    % Collects indices used in the identification of nadir prediction modes
    indices = [indices, pointer_sv(i,1)+1, pointer_sv(i,1)+nsv_SGi(1)+nsv_SGi(2):pointer_sv(i,1)+sum(nsv_SGi)-1];
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

% Dynamic Simulation
% Simulation parameters
M              = zeros(nsv+nav,nsv+nav);
M(1:nsv,1:nsv) = eye(nsv);
options        = odeset('Mass',M,'RelTol',5e-3,'MaxStep',10e-3);

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

% Event
if (gentrip==0)
fprintf('--- LOAD STEP EVENT ---\n')
Ybus         = Ybus0;
% Load step
init_PL      = sum(mpc.bus(:,3));
mpc.bus(load_step_bus ,3) = mpc.bus(load_step_bus ,3)*factor_P; % load at bus 2
final_PL     = sum(mpc.bus(:,3));
load_step    = true;
z0           = init(z1(end,:)');
u02     = u01;
time         = [1 event_time];
[t2,z2]      = ode23t(@h,time,z0,options);
else
fprintf('\n--- GENERATOR OUTAGE EVENT ---\n')
genout  = gentrip; % generator number outage index (if not outage genout = 0)
mask2           = true(length(mpc.gen(:,2)),1);
mask2(genout,1) = false;
init_gen       = sum(mpc.gen(:,2));
Ybus    = Ybus0;
z02     = init(z1(end,:)');
u02     = u01;
time    = [1 event_time];
[t2,z2] = ode23t(@h,time,z02,options);
final_gen      = sum(mpc.gen(mask2,2));
load_step    = false;
end
u2      = (u02*ones(1,length(t2)))'; 
u = [u1;u2];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nadir Pred Init

% New eq. point
if (gentrip==0)
ze_new         = NR_eq(@h,z01);
else
    ze_new         = NR_eq(@h,z02);
end

% Simulation intial condition
% The following delta means the variation in the initial condition which is
% similar to emulate a disturbance in the system. Deltax = x1-x2

ze_00 = z01-ze_new; % The value of the sv at t=0 minus the value at the ep
x0_new = ze_00(1:nsv,1);

% Concatenated results
z = [z1;z2];
t = [t1;t2];
cd ..

% Simulation Time
% elapsedTime = toc;
% fprintf('\n Total Simualtion Time: %2.2f seconds \n', elapsedTime)

% Plots dynamic simulation
non_linear_nadir;

% Small-Signal Analysis
cd 'Functions'

% Load original loads to linearize around the pre-fault op. condition
mpc.bus(:,3) = act_mpc_bus;

if (gentrip==0)
% Small signal analysis
[Asys,L,V,W_T,W_T_norm,PF,PF_abs,res2,w_dc] = small_signal2(z01,indices);
[nn,~] = size(Asys); %number of states/modes
else
    dyn.gen(:,3) = act_H;
    genout  = 2;
    [Asys,L,V,W_T,W_T_norm,PF,PF_abs,res2,w_dc] = small_signal2(z01,indices);
    [nn,~] = size(Asys); %number of states/modes
    genout  = gentrip;
end

% Participation factor-guided mode selection

% Computing modes used in the estimation
PF_gov_states = PF_abs(indices,:);
PF_gov_states = real(PF_gov_states);

% Added because GAST models have one complete row of almost zero PF. (TGOV1 and IESSGO don't have this issue)

% count the number of zeros in each row. 
zeroCount = sum(PF_gov_states == 0, 2);
rowsToRemove = zeroCount > (nsv-4); % 4 is a random number
PF_gov_states(rowsToRemove, :) = []; % Remove that row

threshold = 0.0001;
for i = 1:nsv
    if any(PF_gov_states(:, i) < threshold)
        PF_gov_states(:, i) = 0;
    end
end

non_zero_cols = any(PF_gov_states ~= 0);
non_zero_col_indices = find(non_zero_cols);

modes_to_observe = non_zero_col_indices; 
nn = length(modes_to_observe);

% Decomposed analysis
number_of_sg_to_observe = m;
vec_size = length(t);
omega = zeros(vec_size,nn,m);

% Is necessary to make 0 the contribution of the tripped generator to gamma
if gentrip ==0
else
        dyn.gen(gentrip,3) =0;
end

H_sum = sum(dyn.gen(:,3));

% Computing Gamma Values
for i = 1:length(modes_to_observe) 
gamma_aux = 0;
for ii = 1:m
    Cz = dyn.gen(ii,3)/H_sum;
    dotp = W_T(modes_to_observe(i),:)*x0_new;
    w_state = pointer_sv(ii)+1;  
    gamma_aux = gamma_aux + Cz*dotp*V(w_state,modes_to_observe(i));  
end

if imag (L(modes_to_observe(i)))==0
    gamma(i) = real(gamma_aux);
else
gamma(i) = gamma_aux;
end
end


% Decomposed solution of frequency at each machine
w_recon = zeros(vec_size,1);
for k = 102 :length(t)
    aux2=1;
    for i=modes_to_observe
        w_recon(k,1) = w_recon(k,1) + exp (L(i)*(t(k)-1))*gamma(1,aux2); 
        aux2=aux2+1;
    end
end

% For last estimation 
w_recon_aux =w_recon;

% Adds the post disturbance frequency
if genout == 1
w_recon = (real(w_recon) + ze_new(pointer_sv(2)+1))*60; 
else
w_recon = (real(w_recon) + ze_new(pointer_sv(1)+1))*60; 
end    
w_recon(1:101)  = 60;

plot(t, w_coi, 'Color', [0.65,0.65,0.65], 'LineWidth',3)
hold on
plot(t, w_recon, 'k:','LineWidth',3)
xlabel('Time (s)')
ylabel('Frequency (Hz)')
legend('Actual','Modal-based')
% axis([0 30 59.875 60.001])
% axis([0 30 59.62 60.001])

minValue            = min(w_recon);
minIndices          = find(w_recon == minValue);
time                = t(minIndices);

% Predicted values
w_coi_r_nadir         = minValue
w_coi_r_ndir_time     = time


%%%%%%%%% Estimating DeltaX0 %%%%%%%%%%%%%

if load_step == true
    delta_Pl = (final_PL - init_PL)/100;
else
    delta_Pl = (init_gen - final_gen)/100;
end

[x0_estimated,reduced_indices] = est_x0(delta_Pl,m,dyn,x0,u0,nin,nsv,genout,pointer_sv);

post_freq_aux  = x0_estimated(reduced_indices);
w_post3        = post_freq_aux(1);    
w_recon3       = (real(w_recon_aux) + w_post3)*60; 

minValue            = min(w_recon3);
minIndices          = find(w_recon3 == minValue);
time                = t(minIndices);

% Predicted values
w_coi_r_nadir3         = minValue;
w_coi_r_ndir_time3     = time;


% %% Simulation Time
% elapsedTime = toc;
% fprintf('\n Total Simualtion Time: %2.2f seconds \n', elapsedTime)




