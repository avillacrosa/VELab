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

juliacsv = zeros(size(wexp,1), 3);
juliacsv(:,1) = wexp;
juliacsv(:,2) = storexp;
juliacsv(:,3) = lossexp;
writematrix(juliacsv,'data/data.csv') 
