function [est_x0,reduced_indices] = est_x0(delta_Pl,m,dyn,x0,u0,nin,nsv,genout,pointer_sv)

% ADD GEN OUTAGE

% Estimating x0 in terms of droop characteristic and governors models

if genout ==0
else
    dyn.gov(genout,7)=0;
end

com_speed_reg = sum(dyn.gov(:,7));
delta_freq = -delta_Pl/com_speed_reg;

est_x0=zeros(nsv,1);

reduced_indices =[];
for ii = 1:m
    
    if genout ==ii
    continue;
    end

 SG_type = [dyn.gen(ii,2); dyn.avr(ii,2); dyn.gov(ii,2)];
 [nsv_SGi, ~] = var_num(SG_type);

  % Convert SG_type to a unique identifier
 Gov_key = sprintf('%d', SG_type(3));

%  switch Gov_key
%      
%      case '1'
%         T2    = dyn.gov(ii,4);
%         T3    = dyn.gov(ii,5);
%         K1    = dyn.gov(ii,7);
%         Pc    = u0(nin*(ii-1)+1); 
% 
%         % TGOV1 governor/turbine model (y1, y2)
%         est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = K1*(Pc -(est_x0(pointer_sv(ii)+1)-1)); 
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1)*(1-T2/T3);     
%         
%         reduced_indices = [reduced_indices  pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2];
% 
%      case '2'
%         T2    = dyn.gov(ii,4);
%         T3    = dyn.gov(ii,5);
%         K1    = dyn.gov(ii,7);
%          
%         % IEEESGO governor/turbine model (y1, y3, Tm)
%         est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = K1*(est_x0(pointer_sv(ii)+1)-1);
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1);
% 
%         y2 = (1 - T2/T3)*est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) + (T2/T3)*est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1);
%         
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+3) = Pc - y2;
% 
%         reduced_indices = [reduced_indices pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+3];
% 
%      case '3'
%         K1    = dyn.gov(ii,7);
% 
%         % GAST governor/turbine model (xg1, xg2, xg3)
%         est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
%         aux1  = Pc-K1*(est_x0(pointer_sv(ii)+1)-1); 
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = aux1;
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1);
%         est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+3) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2);
%         reduced_indices = [reduced_indices pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+3];
% 
%  end
 switch Gov_key
     
     case '1'
        T2    = dyn.gov(ii,4);
        T3    = dyn.gov(ii,5);
        K1    = dyn.gov(ii,7);
        Pc    = u0(nin*(ii-1)+1); 

        % TGOV1 governor/turbine model (y1, y2)
        est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)) = K1*(Pc -(est_x0(pointer_sv(ii)+1)-1)); 
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3))*(1-T2/T3);     
        
        reduced_indices = [reduced_indices  pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3) pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1];

     case '2'
        T2    = dyn.gov(ii,4);
        T3    = dyn.gov(ii,5);
        K1    = dyn.gov(ii,7);
         
        Pc    = u0(nin*(ii-1)+1); 
        % IEEESGO governor/turbine model (y1, y3, Tm)
        est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)) = K1*(est_x0(pointer_sv(ii)+1)-1);
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3));

        y2 = (1 - T2/T3)*est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) + (T2/T3)*est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3));
        
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) = Pc - y2;

        reduced_indices = [reduced_indices pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3) pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2];

     case '3'
        K1    = dyn.gov(ii,7);
        Pc    = u0(nin*(ii-1)+1); 
        % GAST governor/turbine model (xg1, xg2, xg3)
        est_x0(pointer_sv(ii)+1)                         = x0(pointer_sv(ii)+1) + delta_freq; 
        aux1  = Pc-K1*(est_x0(pointer_sv(ii)+1)-1); 
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)) = aux1;
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3));
        est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2) = est_x0(pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1);
        reduced_indices = [reduced_indices pointer_sv(ii)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3) pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+1 pointer_sv(ii)+sum(nsv_SGi)-nsv_SGi(3)+2];

 end
end

