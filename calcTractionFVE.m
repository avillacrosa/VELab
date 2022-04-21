clc;
tmax = 100;
cdata = cell(1,tmax);
for t = 1:tmax-1
    fname = sprintf('PIV_3F4_CM_TGFb_40kPa_Col4_20220210b_A3R2_%02d.txt', t);
    cdata{1,t} = fname;
end
n.files.pivdisp=cdata;
p.files.pivdisptrac{1} = 'data/LeonBurst/';
settings.E = 1;
settings.nu = 0.3;