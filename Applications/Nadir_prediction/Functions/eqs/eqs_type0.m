% State and Algebraic Equations
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations (No AVR)
% Type 0 GOV Model Equations (No GOV)

% Loading state variables
delta = z(pointer_sv(i)+0);
w     = z(pointer_sv(i)+1);

% Loading SG algebraic variables
iy    = z(pointer_av(i)+0);
ix    = z(pointer_av(i)+1);

% Loading inputs
Pm    = u0(nin*(i-1)+1);
Ei    = u0(nin*(i-1)+2);

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xdp   = dyn.gen(i,6);
D     = dyn.gen(i,11);
k     = SG_bus(i); % Bus index of the SGi

% Electrical power
I  = ix+1i*iy;
E  = Ei*exp(1i*delta);
Pe = real(E*conj(I));

if (genout == i)
    % SG classical model (delta, w)
    out(pointer_sv(i)+0) = 0;
    out(pointer_sv(i)+1) = 0;
            
    % SG equivalent circuit (id, iq)
    out(pointer_av(i)+0) = iy;
    out(pointer_av(i)+1) = ix;
else
    % SG classical model (delta, w)
    out(pointer_sv(i)+0) = ws*(w - w_ref);
    out(pointer_sv(i)+1) = (1/(2*H))*(Pm - Pe - D*(w-w_ref));
            
    % SG equivalent circuit (id, iq)
    out(pointer_av(i)+0) = real(-E + I*1i*Xdp + V_ph(k));
    out(pointer_av(i)+1) = imag(-E + I*1i*Xdp + V_ph(k));
end