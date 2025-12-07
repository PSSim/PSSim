function dyn = case9_dyn
%% CASE9: Dynamic data for 9 bus, 3 generator case.
% This is the data file for the 9-Bus system with 3-machines. 
% The data is partially taken from [1] with some of the 
% parameters modified to account for a more realistic model. 
% This MATPOWER based data has been prepared by Sebastian Martinez from 
% Prof. Pulgar's research team at the University of Tennessee, Knoxville.
%
% Last update: July, 2023.
%
%   References:
%   [1] Sauer, Peter W., Mangalore A. Pai, and Joe H. Chow. 
%       Power system dynamics and stability: with synchrophasor 
%       measurement and power system toolbox. John Wiley & Sons, 2017.

%% Bus Data
% Bus   exp_P   exp_Q  
dyn.bus = [
  1     2       2;
  2     2       2;
  3     2       2;
  4     2       2;
  5     2       2;
  6     2       2;
  7     2       2;
  8     2       2;
  9     2       2;
];

dyn.bus(:,2:3) = 0;
%% Generator Data
% Bus   Type    H(s)    Rs(pu)   Xd(pu)   Xd'(pu)  Xq(pu)  Xq'(pu)   Td0'(s)  Tq0'(s)    D(s)
dyn.gen = [     
  1     2       23.64   0.000    0.1460   0.0608   0.0969  0.0969    8.96     0.310      0.00;
  2     2        6.40   0.000    0.8958   0.1198   0.8645  0.1969    6.00     0.535     12.80;
  3     2        3.01   0.000    1.3125   0.1813   1.2578  0.2500    5.89     0.600      6.02;
];

%% AVR Data 
% Bus   Type    KA     TA(s)   KE     TE(s)   KF      TF(s)   TB(s)   TR(s)   TC(s)   Vmin    Vmax    Vrmin   Vrmax   Kc
dyn.avr = [
  1     2       20.00  0.20    1.0000   0.314   0.0630   0.35   0.00    0.00    0.00    0.00    0.00    -10.00  10.00   0.00; % Type 2: Type I Exciter 
  2     2       20.00  0.20    1.0000   0.314   0.0630   0.35   0.00    0.00    0.00    0.00    0.00    -10.00  10.00   0.00; % Type 2: Type I Exciter 
  3     2       20.00  0.20    1.0000   0.314   0.0630   0.35   0.00    0.00    0.00    0.00    0.00    -10.00  10.00   0.00; % Type 2: Type I Exciter 
];

%% Turbine/Governor Data
% Bus   Type    T1     T2     T3      T4     K1     Dt      Pmin    Pmax    At      Kt
dyn.gov = [
  1     1       0.25   2.50   9.000   0.00   20.00  0.25    0.00    11.00    0.00    0.00; % Type 1: TGOV1 
  2     2       0.30   5.00   12.00   0.10   30.00  0.00    0.00    10.00    0.00    0.00; % Type 2: IEESGO 
  3     3       0.25   0.25   2.500   0.00   20.00  0.25    0.00    8.000    8.00    2.50; % Type 3: GAST 
];

%% IBR Data
% Bus   Type    TQ    TD     Rf      Xf    Teq    Ted 
dyn.ibr = [
  6     1       0.01  0.01   0.0040  0.05  0.01   0.01;
  8     1       0.01  0.01   0.0040  0.05  0.01   0.01;
];

%% IBR Data
% Bus  Type   Kiq   TGqv    Kip     TGpv    Qmax    Qmin    Pmax   Pmin     Tr      Rq      Ki      Kp      Tfrq    Rp
dyn.control = [
  6    1      5     0.01    5       0.01    1.00    -1.00   1.00   0        0.02    0.00    20      4       0.01    0.05;
  8    2      5     0.01    5       0.01    1.00    -1.00   1.00   0        0.02    0.00    20      4       0.01    0.05;
];

%% PMU Data
for i=1:1:9
    dyn.pmu(i,1) = i;
    dyn.pmu(i,2) = 0.1;
end

end
