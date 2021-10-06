clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (if left blank, assume ./input_data): ', 's');

% data_f = 'test_data'


% data_f = 'ven_patch_test1x1x1';
% data_f = 'ven_patch_test2x2x2';
% data_f = 'max_patch_test1x1x1';
% data_f = 'max_patch_test2x2x2';
% data_f = 'kv_patch_test1x1x1';
% data_f = 'ven_patch_test1x1';
% data_f = 'nh_patch_test1x1';
% data_f = 'lin_patch_test1x1';
% data_f = 'nh_patch_test1x1';
% data_f = 'input_data';
% data_f = 'lin_patch_test5x5';
% data_f = 'lin_patch_test2x2x2';

% data_f = 'nh_patch_test2x2x2';
% data_f = 'lin_patch_test1x1x1';
% data_f = 'shear_in';
% data_f = 'shear_out';
data_f = 'input_data';


Result = run(data_f);

plot(Result.times, Result.strs(:,1))