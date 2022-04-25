clc; close all; clear;
addpath(genpath('src'))

[Geo, Mat, Set] = mx_relax_2d;
Result = runVE(Geo, Mat, Set);
