function [out_sv,out_av] = var_num(SG_type)
%% Generator Model
% Type 0: Classical Model (no AVR, no GOV)
% Type 1: One-Axis Model
% Type 2: Two Axis-Model
%           Type0   Type1   Type2
SG_model = [0,      1,      2;    
            2,      3,      4;      % number of state variables
            2,      2,      2];     % number of algebraic variables 

%% AVR Model
% Type 0; No AVR
% Type 1: Simplified Excitation System (SEXS_PTI)
% Type 2: Type I Exciter 
% Type 3: Excitation System ST1 (EXST1) 
%           Type0   Type1   Type2   Type3   
SG_AVR   = [0,      1,      2,      3;    
            0,      2,      3,      4;      % number of state variables
            0,      1,      1,      1];     % number of algebraic variables 

%% GOV Model
% Type 0: No GOV
% Type 1: TGOV1 
% Type 2: IEESGO
% Type 3: GAST  
%           Type0   Type1   Type2   Type 3
SG_GOV   = [0,      1,      2,      3;    
            0,      2,      3,      3;      % number of state variables
            0,      2,      2,      2];     % number of algebraic variables 

%% Output 
if SG_type(1) == 0 % Force no AVR for SG classical model
    out_sv = [SG_model(2,SG_type(1)+1); SG_AVR(2,SG_type(1)+1); SG_GOV(2,SG_type(3)+1)];
    out_av = [SG_model(3,SG_type(1)+1); SG_AVR(3,SG_type(1)+1); SG_GOV(3,SG_type(3)+1)];
else
    out_sv = [SG_model(2,SG_type(1)+1); SG_AVR(2,SG_type(2)+1); SG_GOV(2,SG_type(3)+1)];
    out_av = [SG_model(3,SG_type(1)+1); SG_AVR(3,SG_type(2)+1); SG_GOV(3,SG_type(3)+1)];
end

