clear; close all; clc;
addpath(genpath("ConstModels"))
addpath(genpath("data"))

%% Load Data
stress  = load('stress.txt');
storage = load('storage.txt');
loss    = load('loss.txt');

texp = stress(:,1);
stressexp = stress(:,2);
wexp = storage(:,1);
storexp = storage(:,2);
lossexp = loss(:,2);

p = [311099.53970222827,  10585.855881086107,  23818.228475334025, 0.9136536265513647, 0.052928545735614396, 0.034432436962668525];
% p = num2cell(p);

PlotFits("fzener" , texp, stressexp, wexp, storexp, lossexp, p)
