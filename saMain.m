clc; close all; clear;
addpath(genpath('src'))

% [Geo, Mat, Set] = kv_creep;
% Result = runVE(Geo, Mat, Set);

% Mock data
tmax = 99;
cdata = cell(1,tmax);
for t = 1:tmax
    fname = sprintf('PIV_3F4_CM_TGFb_40kPa_Col4_20220210b_A3R2_%02d.txt', t);
    cdata{1,t} = fname;
end

n.files.pivdisp=cdata;
p.files.pivdisptrac{1} = 'data/LeonBurst/';
settings.E = 1;
settings.nu = 0.3;
settings.H = 5;
settings.dt = 1;
emax=1;
for e = 1:emax
    [Geo, Mat, Set] = shrineToVELab(e, n, p,  settings, tmax);
    Result = runVE(Geo, Mat, Set);
end

% profile viewer
