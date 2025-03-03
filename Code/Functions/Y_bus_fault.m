function Ybus_out = Y_bus_fault(k)
global Ybus n

Ybus_out = Ybus;

% Full impedance matrix
Z = inv(Ybus_out);

% Isolating block matrices not realted to k row and column
Z1 = Z; Z1(:,k) = []; Z1(k,:) = [];
Z2 = Z(:,k); Z2(k) = [];
Z3 = Z(k,:); Z3(k) = [];
Z4 = Z(k,k);

% Kron reduction 
Zred = Z1-Z2*inv(Z4)*Z3;
Yred = inv(Zred);

% Reconstruct Ybus for short-circuit case
Ybus_out          = Yred(1:k-1,:);
Ybus_out(k,:)     = zeros(1,n-1);
Ybus_out(k+1:n,:) = Yred(k:end,:);
Ytemp             = Ybus_out(:,k:end);
Ybus_out(:,k)     = zeros(n,1);
Ybus_out(k,k)     = 1+1j; % Arbitrary number to indicate the faulted bus
Ybus_out(:,k+1:n) = Ytemp;
end