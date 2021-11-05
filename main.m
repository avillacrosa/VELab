clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');
% data_f = 'rand_tfm_nl';

Result = runVE('kelvin_tresD');
% Result = runVE('maxwell_tresD');
