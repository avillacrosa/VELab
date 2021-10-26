clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (if left blank, assume ./input_data): ', 's');

% data_f = 'real_tfm_in';
data_f = 'tfm_out';
% data_f = 'tfm_inv';
% data_f = 'input_data';

Result = run(data_f);