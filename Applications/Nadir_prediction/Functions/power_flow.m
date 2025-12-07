function y0 = power_flow()
global n mpc V0 l

SG_bus  = mpc.gen(:,1);
if l ~= 0  
    IBR_bus = mpc.ibr(:,1);
end

% Initial guess for load flow
V0               = ones(n,1);

if l~=0 %Check for IBR existance
    for i =1:n
    type = mpc.bus(i,2);
        if (type == 3 || type == 2) % Slack and PV buses
            k         = find(SG_bus == i);
            kk        = find(IBR_bus == i);    
            if isempty(k)
                V0(i) = mpc.ibr(kk,6); 
            elseif isempty(kk)
                V0(i) = mpc.gen(k,6); 
            end
        end
    end
else
    V0(mpc.gen(:,1)) = mpc.gen(:,6); % Data from slack and PV buses
end
theta0           = zeros(n,1);
y0               = [V0;theta0];

y0 = NR(@pf,y0);

% Display results
fprintf('Power flow solution: [Bus#  V(p.u.)  theta(deg.)] \n')
buses = zeros(n,1);
for i = 1:n
    buses(i) = i;
end
PF_results = [buses y0(1:n) y0(n+1:end)*180/pi]
end