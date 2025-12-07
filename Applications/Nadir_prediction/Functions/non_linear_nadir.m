%% Non-linear nadir
global n m mpc dyn nsv_PMU nsv genout
SG_bus = mpc.gen(:,1);
aux = nsv-nsv_PMU*n;

H_sum = 0;
w_coi = zeros(size(z(:,1)));
for ii = 1:m
    w     = z(:,pointer_sv(ii)+1).*60;
    H     = dyn.gen(ii,3);
    if (genout == ii)
        H = 0;
    end
    w_coi = w_coi + H*w;
    H_sum = H_sum + H;
end
w_coi = w_coi/H_sum;

minValue            = min(w_coi);
minIndices          = find(w_coi == minValue);
time                = t(minIndices);
w_coi_nadir         = minValue
w_coi_ndir_time     = time