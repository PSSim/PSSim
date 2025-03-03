% State and Algebraic Equations
% Type 0 SG  Model Equations
% Type 0 AVR Model Equations (No AVR)
% Type 2 GOV Model Equations 

% Loading state variables
delta = z(pointer_sv(i)+0);
w     = z(pointer_sv(i)+1);
y1    = z(pointer_sv(i)+2);
y3    = z(pointer_sv(i)+3);
Tm    = z(pointer_sv(i)+4);

% Loading SG algebraic variables
iy      = z(pointer_av(i)+0);
ix      = z(pointer_av(i)+1);
y2      = z(pointer_av(i)+2);
y2_sat  = z(pointer_av(i)+3);

% Loading inputs
Pc    = u0(nin*(i-1)+1);
Ei    = u0(nin*(i-1)+2);

% Loading parameters
H     = dyn.gen(i,3);
Rs    = dyn.gen(i,4);
Xdp   = dyn.gen(i,6);
D     = dyn.gen(i,11);
T1    = dyn.gov(i,3);
T2    = dyn.gov(i,4);
T3    = dyn.gov(i,5);
T4    = dyn.gov(i,6);
K1    = dyn.gov(i,7);
Pmin  = dyn.gov(i,9);
Pmax  = dyn.gov(i,10);
k     = SG_bus(i); % Bus index of the SGi

% Electrical power
I  = ix+1i*iy;
E  = Ei*exp(1i*delta);
Pe = real(E*conj(I));

if (genout == i)
    % SG classical model (delta, w) + Governor IEESGO
    out(pointer_sv(i)+0) = 0;
    out(pointer_sv(i)+1) = 0;
    out(pointer_sv(i)+2) = 0; 
    out(pointer_sv(i)+3) = 0;  
    out(pointer_sv(i)+4) = 0;  
            
    % SG equivalent circuit (id, iq) + gov alg. variables (y2, y2_sat)
    out(pointer_av(i)+0) = iy;
    out(pointer_av(i)+1) = ix;
    out(pointer_av(i)+2) = y2; 
    out(pointer_av(i)+3) = y2_sat;
else
    % SG classical model (delta, w)
    out(pointer_sv(i)+0) = ws*(w - w_ref);
    out(pointer_sv(i)+1) = (1/(2*H))*(Tm - Pe - D*(w-w_ref));

    % IEEESGO governor/turbine model (y1, y3, Tm)
    out(pointer_sv(i)+2) = (1/T1)*(-y1 + K1*(w-1));
    out(pointer_sv(i)+3) = (1/T3)*(-y3 + y1);
    out(pointer_sv(i)+4) = (1/T4)*(-Tm + Pc - y2_sat);
            
    % SG equivalent circuit (id, iq) and governor alg. variables (y2, y2_sat)
    out(pointer_av(i)+0) = real(-E + I*1i*Xdp + V_ph(k));
    out(pointer_av(i)+1) = imag(-E + I*1i*Xdp + V_ph(k));
    out(pointer_av(i)+2) = -y2 + (1 - T2/T3)*y3 + (T2/T3)*y1;    
    if y2 < Pc-Pmin && y2 > Pc-Pmax
        out(pointer_av(i)+3) = -y2_sat + y2;
    elseif y2 >= Pc-Pmin
        out(pointer_av(i)+3) = -y2_sat + Pc-Pmin;
    elseif y2 <= Pc-Pmax
        out(pointer_av(i)+3) = -y2_sat + Pc-Pmax;
    end
end