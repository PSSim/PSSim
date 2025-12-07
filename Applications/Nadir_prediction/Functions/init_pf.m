function [z0,u0] = init_pf(y0)
% Initialization given solution from load flow y0 = [vi thetai]
global n m l Ybus mpc dyn nsv nav_SG nav_IBR nin nsv_PMU nav_PMU
global pointer_sv pointer_av pointer_sv_ibr pointer_av_ibr nsv_SG nsv_IBR

% Grid variables
SG_bus  = mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end
V       = y0(1:n);
theta   = y0(n+1:end);

% V,I,S phasors
V_phasor  = V.*exp(1i*theta);
I_phasor  = Ybus*V_phasor;
S_phasor  = V_phasor.*conj(I_phasor);

%% SG models initialization
for i = 1:m
    % Extract Models Type
    SG_type = [dyn.gen(i,2);dyn.avr(i,2);dyn.gov(i,2)];
    [nsv_SGi,nav_SGi] = var_num(SG_type);
    
    % Convert SG_type to a unique identifier
    SG_key = sprintf('%d%d%d', SG_type(1), SG_type(2), SG_type(3));
    
    % Load SG model using switch-case
    switch SG_key
        case '000'
            init_type0;
        case '001'
            init_type001;
        case '002'
            init_type002;
        case '003'
            init_type003;
        case '111'
            init_type111;
        case '112'
            init_type112;
        case '113'
            init_type113;
        case '121'
            init_type121;
        case '122'
            init_type122;
        case '123'
            init_type123;
        case '131'
            init_type131;
        case '132'
            init_type132;
        case '133'
            init_type133;
        case '211'
            init_type211;
        case '212'
            init_type212;
        case '213'
            init_type213;
        case '221'
            init_type221;
        case '222'
            init_type222;
        case '223'
            init_type223;
        case '231'
            init_type231;
        case '232'
            init_type232;
        case '233'
            init_type233;
        otherwise
            error('Invalid SG_type combination');
    end
end

%% IBR models initialization
for i = 1:l
    % Extract IBR model type
    IBR_type = [dyn.ibr(i,2);dyn.control(i,2)];
    [nsv_IBRi,nav_IBRi] = var_num_ibr(IBR_type);
    % Load IBR model
    if      IBR_type(1) == 1 && IBR_type(2) == 1 %
        init_ibr_type11;
    elseif  IBR_type(1) == 1 && IBR_type(2) == 2 % %
        init_ibr_type12; 
    end
end

%% PMU model initialization
theta_est = theta;
w_est     = ones(n,1);
zz0(sum(nsv_SG)+sum(nsv_IBR)+1:sum(nsv_SG)+sum(nsv_IBR)+nsv_PMU*n,1) = theta_est;
zz0(pointer_av(1)+sum(nav_SG)+sum(nav_IBR):pointer_av(1)+sum(nav_SG)+sum(nav_IBR)+nav_PMU*n-1,1) = w_est;

x0 = zz0(1:sum(nsv_SG)+sum(nsv_IBR)+nsv_PMU*n,1);
i0 = zz0(pointer_av(1):pointer_av(1)+sum(nav_SG)+sum(nav_IBR)+nav_PMU*n-1,1);
z0 = [x0;i0;y0];
end