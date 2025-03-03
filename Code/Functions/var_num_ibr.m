function [out_sv,out_av] = var_num_ibr(IBR_type)
%% IBR Model
% Type 1: REGC_B Renewable Energy Generator Converter, Model B
%           Type1   
IBR_model = [1;    
             4;      % number of state variables
             4];     % number of algebraic variables 

%% IBT Control Model
% Type 1: PQ mode fixed MW and MVAR output
% Type 2: fV mode support for frequency control (droop) and voltage control
%               Type1   Type2     
IBR_control  = [1,      2;    
                4,      7;      % number of state variables
                4,      4];     % number of algebraic variables 

%% Output 
out_sv = [IBR_model(2,IBR_type(1)); IBR_control(2,IBR_type(2))];
out_av = [IBR_model(3,IBR_type(1)); IBR_control(3,IBR_type(2))];



