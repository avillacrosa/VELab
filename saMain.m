clc; close all; clear;
addpath(genpath('src'))

[Geo, Mat, Set] = mx_harm;
Result = runVE(Geo, Mat, Set);
