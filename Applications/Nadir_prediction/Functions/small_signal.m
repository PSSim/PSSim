function [Asys,L,V,W,PF] = small_signal(z0)
% Linearized model around z0
% dx/dt = f(x,y)  --> d∆x/dt = A∆x + B∆y
%     0 = g(x,y)  -->      0 = C∆x + D∆y
global nsv nav

% Jacobian matrix J = [A,B;C,D]
epsilon = 1e-4;
h0      = h(0,z0);
J       = zeros(nsv+nav,nsv+nav);
for k=1:(nsv+nav)
    z1      = z0;
    z1(k,1) = z0(k,1) + epsilon;
    h1      = h(0,z1);
    J(:,k)  = (h1-h0)/epsilon;
end

% Submatrices of the Jacobian 
A = J(1:nsv,1:nsv);
B = J(1:nsv,nsv+1:end);
C = J(nsv+1:end,1:nsv);
D = J(nsv+1:end,nsv+1:end);

% Kron reduction of algebraic variables
Asys = A - B*inv(D)*C;

% Eigenvalues, eigenvectors and participation factors
[V,L] = eig(Asys);
L     = diag(L);
W     = transpose(inv(V));
PF    = abs(W.*V);

% Mode related parameters
for i = 1:length(L)
    wn(i,1)  = norm(L(i));
    chi(i,1) = -real(L(i))/wn(i);
    w(i,1)   = wn(i)*sqrt(1 - chi(i,1)^2);
end

% Printing modes
for i = 1:length(L)/2
    fprintf('Mode %i\n',i)
    fprintf('Damping ratio     : %2.2f %% \n', chi(2*i-1)*100);
    fprintf('Natural Frequency : %2.2f Hz \n', wn(2*i-1)/2/pi);
    fprintf('Damped Frequency  : %2.2f Hz \n\n', w(2*i-1)/2/pi);
end
end