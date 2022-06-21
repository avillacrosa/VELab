clc; close all; clear;
addpath(genpath('src'))

% [Geo, Mat, Set] = hk_patch;
% [Geo, Mat, Set] = gmx_flow_2d;
[Geo, Mat, Set] = gmxve_flow_2d;
% [Geo, Mat, Set] = gmxve_relax_2d;
% [Geo, Mat, Set] = hk_patch;
% [Geo, Mat, Set] = hk_patch_u;
% [Geo, Mat, Set] = nhk_patch;

Result = runVE(Geo, Mat, Set);
