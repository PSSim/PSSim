function [Asys,L,V,W_T,W_T_norm,PF,PF_abs,res2,w_dc] = small_signal2(z0,indices)
% Linearized model around z0
% dx/dt = f(x,y)  --> d∆x/dt = A∆x + B∆y
%     0 = g(x,y)  -->      0 = C∆x + D∆y
global nsv nav nav_SG m

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
J1 = J(1:nsv,1:nsv);
J2 = J(1:nsv,nsv+1:end);
J3 = J(nsv+1:end,1:nsv);
J4 = J(nsv+1:end,nsv+1:end);

% Kron reduction of algebraic variables
Asys = J1 - J2*inv(J4)*J3;

% Eigenvalues, eigenvectors and participation factors
[V,L] = eig(Asys);
L     = diag(L);
W_T   = inv(V); %left eigenvectors, matrix with rows. w_ti
% W     = transpose(W_T);
% % mul = W_T*V;
% % mul2 = W_T(1,:)*V(:,1) 

PF       =  transpose(W_T).*V; %V is normalized 
PF_abs   =  abs(PF);

%% Testing all PF over a treshold
% pattern = [4 8 9 10];
% indices=[];
% for i = 1:3
%     indices = [indices pattern+10*(i-1)];
% end

PF_gov_states = PF_abs(indices,:);


%Normalizing over maximum PF in each column
max_val = max(PF_abs, [], 1);
PF_abs  = PF_abs./max_val;
% PF_abs  = round(PF_abs,3);

%Normalizing left eigenvectors
for i =1:nsv
    W_T_norm(i,:) = W_T(i,:)/norm(W_T(i,:));
end



% 
% PF1 = zeros(nsv,nsv);
% for mm=1:nsv
%     for nn=1:nsv
%         PF1(mm,nn) = real((W(mm,nn)*V(mm,nn))/(W_T(mm,:)*V(:,mm))); 
%     end
% end
 

% Mode related parameters
for i = 1:length(L)
    wn(i,1)  = norm(L(i));
    chi(i,1) = -real(L(i))/wn(i);
    w(i,1)   = imag(L(i))/(2*pi);
end

% % Printing modes
% for i = 1:length(L)
%     fprintf('Eigenvalue %i: ',i)
%     fprintf('%2.4f + j%2.4f \n',real(L(i)),imag(L(i)));
%     fprintf('Damping ratio     : %2.2f %% \n',chi(i)*100);
% %     fprintf('Natural Frequency : %2.2f Hz \n',wn(i)/2/pi);
%     fprintf('Oscillation Frequency  : %2.2f Hz \n\n',w(i));
% end

% % B related Jacobian matrix B = [J5;J6]
% epsilon = 1e-4;
% h0      = h(0,z0);
% B       = zeros(nsv+nav,1); % Just related to bus power injection at bus 2
% 
% % It is necessary to use a new "h" function since we need to perturbe the
% % input. Previos h function only allowed state variable perturbations. 
% 
% h1      = h_B(0,z0,2,epsilon);
% B       = (h1-h0)/epsilon;
% J5      = B(1:nsv,:);
% J6      = B(nsv+1:end,:);
% 
% % C matrix: C = [C1,C2];
% C1 = zeros(1,nsv);
% C2 = zeros(1,nav); C2(nav_SG*m+2) = 1;
% 
% % Residue relatred to input (Bus 2 power injection) and output (frequency
% % estimation at bus 2)
% Modei = 10;
% w_dc  = abs(imag(L(Modei)));
% vi    = V(:,Modei);
% w_ti  = W_T(Modei,:);
% mul22 = w_ti*vi;
% C     = -C2*inv(J4)*J3;
% B     = J5 - J2*inv(J4)*J6;
% res2  = C*vi*w_ti*B;

w_dc=0; %Dummy variable 
res2=0; %Dummy variable

end