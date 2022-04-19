clc; close all; clear;
addpath(genpath('src'))

% profile on
% data_f = input('> Data file path (default: ./input_data): ', 's');
% Result = runVE('input_data');

% Result = runVE('kv_creep');
% Result = runVE('kv_creep_2d');

% Result = runVE('mx_flow');
% Result = runVE('mx_flow_2d');

Result = runVE('mx_relax');

% Result = runVE('fract_maxwell');

% profile viewer
