%% Typical Data

%% Generator Data
% Bus   Type    H(s)    Rs(pu)   Xd(pu)   Xd'(pu)  Xq(pu)  Xq'(pu)   Td0'(s)  Tq0'(s)   D(s)
dyn.gen = [     
  xx    0       42.0    0.000    0.1000   0.0310   0.069   0.0080    10.2     0.01      84.0;  % Type 0: Classical Model (no AVR, no GOV)
  xx    1       30.3    0.000    0.2950   0.0697   0.282   0.1700    6.56     1.50      60.6;  % Type 1: One-Axis Model
  xx    2       35.8    0.000    0.2495   0.0531   0.237   0.0876    5.70     1.50      71.6;  % Type 2: Two Axis-Model
];
  
%% AVR Data 
% Bus   Type    KA     TA(s)   KE       TE(s)   KF      TF(s)   TB(s)   TR(s)   TC(s)   Vmin*    Vmax*    Vrmin*   Vrmax*   Kc
dyn.avr = [ 
  xx    1       20.00  6.00    0.0000   0.314   0.0000   0.00   12.5    0.00    0.00    0.00    3.00    -00.00  00.00   0.00; % Type 1: Simplified Excitation System (SEXS_PTI)
  xx    2       20.00  0.20    1.0000   0.314   0.0630   0.35   0.00    0.00    0.00    0.00    0.00    -10.00  10.00   0.00; % Type 2: Type I Exciter 
  xx    3       80.00  0.05    0.0000   0.000   0.1000   1.00   1.00    0.01    1.00    0.00    0.00    -3.000  8.000   0.20; % Type 3: Excitation System ST1 (EXST1) 
];

%% Turbine/Governor Data
% Bus   Type    T1     T2     T3      T4     K1     Dt      Pmin*    Pmax*    At*      Kt
dyn.gov = [
  xx    1       0.25   2.50   9.000   0.00   20.00  0.25    0.00    11.00    0.00    0.00; % Type 1: TGOV1 
  xx    2       0.30   5.00   12.00   0.10   30.00  0.00    0.00    10.00    0.00    0.00; % Type 2: IEESGO 
  xx    3       0.25   0.25   2.500   0.00   20.00  0.25    0.00    8.000    8.00    2.50; % Type 3: GAST 
];
% *Case custom 
%% IBR Data
% Bus    Type    TQ    TD     Rf      Xf    Teq    Ted 
dyn.ibr = [
   xx     1       0.01  0.01   0.0040  0.05  0.01   0.01; % Type 1: REGC_B Renewable Energy Generator Converter, Model B
];

%% IBR Data
% Bus   Type   Kiq   TGqv    Kip     TGpv    Qmax    Qmin    Pmax   Pmin     Tr      Rq      Ki      Kp      Tfrq    Rp
dyn.control = [
  xx    1      5     0.01    5       0.01    1.00    -1.00   1.00   0        0.00    0.00    0.00    0.00    0.00    0.00; % Type 1: PQ mode fixed MW and MVAR output
  xx    2      5     0.01    5       0.01    3.00    -2.00   1.00   0        0.02    0.00    20      4       0.01    0.05; % Type 2: fV mode support for frequency control (droop) and voltage control
];

%% PMU Data
for i=1:1:39
    dyn.pmu(i,1) = i;
    dyn.pmu(i,2) = 0.1;
end