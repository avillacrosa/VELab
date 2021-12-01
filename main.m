clc; close all;
addpath(genpath('src'))

% profile on
% data_f = input('> Data file path (default: ./input_data): ', 's');
% Result = runVE('tfm');
% Result = runVE('bssnsqtest');
Result = runVE('input_data');

% profile viewer
