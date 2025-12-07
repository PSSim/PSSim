function out = NR(func,x0)
out0    = func(x0);
J       = zeros(size(x0));
epsilon = 1e-4;
tol     = 1e-4;
error   = 1;
k = 0; % k: number of iterations
while (error > tol)
    for i = 1:length(x0)
        x1      = x0;
        x1(i,1) = x0(i,1) + epsilon;
        out1    = func(x1);
        J(:,i)  = (out1 - out0)/epsilon;
    end
    corr   = -J\out0;
    x0     = x0 + corr;
    out0   = func(x0);
    error  = max(out0);
    k = k+1;
end
fprintf('NR solved in %2.0f iterations \n',k)
out = x0;
end