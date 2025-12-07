function z0 = init(z0)
global n m l nsv nav nav_SG x0

x0   = z0(1:nsv); 
y0   = z0(nsv+1:end);

% New inital guess for power flow
y0(nav-2*n+1:nav-n) = ones(n,1);
y0(nav-n+1:end)     = zeros(n,1);

y0   = NR(@g,y0);

% Display results
fprintf('Power flow solution: [Bus#  V(p.u.)  theta(deg.)] \n')
buses = zeros(n,1);
for i = 1:n
    buses(i) = i;
end
PF_results = [buses y0(nav-2*n+1:nav-n) y0(nav-n+1:end)*180/pi]

z0 = [x0;y0];
end