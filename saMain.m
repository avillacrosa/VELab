clc; close all; clear;
addpath(genpath('src'))

% [Geo, Mat, Set] = mx_relax_2d;
% [Geo, Mat, Set] = hk_patch;
[Geo, Mat, Set] = nhk_patch;

Result = runVE(Geo, Mat, Set);
