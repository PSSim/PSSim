function out = NR_eq(func,x0)
% This function is used to solve the DAE model for the new operating
% condition. The solution includes state and algebraic variables. 

global mpc n nsv_PMU nsv m genout pointer_sv nsv_SG
out0    = func(0,x0);
J       = zeros(size(x0));
epsilon = 1e-4;
tol     = 1e-5;
error   = 1;
k = 0; % k: number of iterations
while (error > tol)
    for i = 1:length(x0)
        x1      = x0;
        x1(i,1) = x0(i,1) + epsilon;
        out1    = func(0,x1);
        J(:,i)  = (out1 - out0)/epsilon;
    end
    % Incorporating 1 in diagonal to counteract ddelta/dt = 0 at ref. machine
    SG_bus = mpc.gen(:,1);
    for i = 1:n
        type = mpc.bus(i,2);
        if (type == 3) % Checking slack bus delta equation
            j = find(SG_bus == i);
            J(pointer_sv(j),:)                          = zeros(1,length(J));
            J(:,pointer_sv(j))                          = zeros(length(J),1);
            J(pointer_sv(j),pointer_sv(j))              = 1;
        elseif (type == 2) % Transforming data assoc to gen out 
            j = find(SG_bus == i);
            if (genout == j)
                J(pointer_sv(j):pointer_sv(j)+nsv_SG(j)-1,:) = zeros(nsv_SG(j),length(J));
                J(:,pointer_sv(j):pointer_sv(j)+nsv_SG(j)-1) = zeros(length(J),nsv_SG(j));
                J(pointer_sv(j):pointer_sv(j)+nsv_SG(j)-1,pointer_sv(j):pointer_sv(j)+nsv_SG(j)-1) = eye(nsv_SG(j),nsv_SG(j));
            end
        end
    end 
    corr   = -J\out0;
    x0     = x0 + corr;
    out0   = func(0,x0);
    error  = max(out0);
    k = k+1;
end
fprintf('NR solved in %2.0f iterations \n',k)
out = x0;
end