clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');
% data_f = 'rand_tfm_nl';

Result = runVE('input_data');
% Result = runVE('input_data');

% Result = runVE('maxwell_tresD');
% Result = runVE('input_data');
% Result_1 = runVE('input_data');
% Result_2 = runVE('input_data_2');
% Result_f.u(:,:,2)

% Result_i = runVE('kelvin_tresD');

% Result_i = runVE('kelvin_tresD_inv');

% Result_f = runVE('maxwell_tresD');
% Result_f.u(:,:,2)
% Result_i = runVE('maxwell_tresD_inv');

% Result_f = runVE('tfm_out');
% Result_i = runVE('tfm_inv');
