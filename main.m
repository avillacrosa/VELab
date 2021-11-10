clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');
% data_f = 'rand_tfm_nl';

% Result = runVE('input_data');
Result = runVE('input_data');

% Result = runVE('maxwell_tresD');
