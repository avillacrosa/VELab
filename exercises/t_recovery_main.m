clc; close all;

addpath(genpath('src'))

data_f = 't_rec_init.m';
Result_in = run(data_f);

fileh = fopen('u_t_rec.txt','w+');
for ui = 1:size(Result_in.u,1)
    uii = Result_in.u(ui,:);
    fprintf(fileh, "%.6f %.6f %.6f \n", uii(1), uii(2), uii(3));
end

data_f = 't_rec_inv.m';
Result_out = run(data_f);
in_t  = vec_nvec(Result_in.t);
out_t = Result_out.tinv;