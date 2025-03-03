function Ybus = Y_bus()
global n mpc
Ybus     = zeros(n,n);
n_branch = length(mpc.branch(:,1));
branch   = mpc.branch;
Bs       = mpc.bus(:,6);
base     = mpc.baseMVA;

% Branch related elements (pi-model)
for k = 1:n_branch
    z    = branch(k,3) + 1j*branch(k,4);
    y    = 1j*branch(k,5);
    busi = branch(k,1);
    busj = branch(k,2);
        
    % Off-diagonal elements
    Ybus(busi,busj) = Ybus(busi,busj) - 1/z;
    Ybus(busj,busi) = Ybus(busj,busi) - 1/z;
    
    % Diagonal elements
    Ybus(busi,busi) = Ybus(busi,busi) + 1/z + y/2; 
    Ybus(busj,busj) = Ybus(busj,busj) + 1/z + y/2;       
end

% Parallel elements in buses
for k = 1:n
    Ybus(k,k) = Ybus(k,k) + 1i*Bs(k)/base;
end
end