clc; close all;
addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');
% 
% Result_i = runVE('tfm');
% % Result_i.F
% % Result_i.t
% Result_f = runVE('tfm_check');
% max(abs(Result_f.u - Result_i.u),[], 'all')
% max(abs((Result_f.u - Result_i.u)./Result_i.u),[], 'all')

ns = [2, 5, 10, 15, 20];
errabs = size(ns);
errrel = size(ns);
for i = 1:length(ns)
    f1 = sprintf("tfm_nl_%02d", ns(i));
    f2 = sprintf("tfm_nl_check_%02d", ns(i));
    Result_i = runVE(f1);
    Result_f = runVE(f2);
    ea = max(abs(Result_f.u - Result_i.u),[], 'all');
    er = max(abs((Result_f.u - Result_i.u)./Result_i.u),[], 'all');
    errabs(i) = ea;
    errrel(i) = er;
end
% Result_i = runVE('tfm_nl');
% Result_i.u
% Result_i.F
% Result_i.t
% Result_f = runVE('tfm_nl_check');
% max(abs(Result_f.u - Result_i.u),[], 'all')
% max(abs((Result_f.u - Result_i.u)./Result_i.u),[], 'all')

% Result_pre = runVE('tfm_ve_pre');
% Result_ini = runVE('tfm_ve');
% Result_fin = runVE('tfm_ve_check');

% 
% Result_pre = runVE('tfm_ve_pre_mx');
% Result_ini = runVE('tfm_ve_mx');
% Result_fin = runVE('tfm_ve_check_mx');
% 
% max(abs(Result_fin.u - Result_ini.u),[], 'all')
% max(abs((Result_fin.u - Result_ini.u)./Result_ini.u),[], 'all')