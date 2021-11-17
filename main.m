clc; close all;
addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');

% Result_i = runVE('tfm');
% Result_i.F
% Result_i.t
% Result_f = runVE('tfm_check');


% Result_i = runVE('tfm_nl');
% % Result_i.u
% % Result_i.F
% % Result_i.t
% Result_f = runVE('tfm_nl_check');
% Result_f.u - Result_i.u

% Result_pre = runVE('tfm_ve_pre');
% Result_ini = runVE('tfm_ve');
% Result_fin = runVE('tfm_ve_check');


Result_pre = runVE('tfm_ve_pre_mx');
Result_ini = runVE('tfm_ve_mx');
Result_fin = runVE('tfm_ve_check_mx');