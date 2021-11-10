clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');
% data_f = 'rand_tfm_nl';

<<<<<<< HEAD
% Result = runVE('input_data');
Result = runVE('input_data');

% Result = runVE('maxwell_tresD');
=======
% Result_f = runVE('input_data');
% Result_f = runVE('kelvin_tresD');
% Result_f.u(:,:,2)
% Result_i = runVE('kelvin_tresD_inv');

Result_f = runVE('maxwell_tresD');
Result_f.u(:,:,2)
Result_i = runVE('maxwell_tresD_inv');

% Result_f = runVE('tfm_out');
% Result_i = runVE('tfm_inv');
>>>>>>> b723ec9c0115e995fbdf43873c3258b27ac7fc4c
