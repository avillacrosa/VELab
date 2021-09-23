clc; close all;

addpath(genpath('src'))
addpath(genpath('examples'))


data_f = input('> Data file path (if left blank, assume ./input_data): ', 's');

Result = run(data_f);
