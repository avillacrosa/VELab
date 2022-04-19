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

%% Fit params
% stress, storage, loss
lambdas = [1, 1, 1];
model = 'fmaxwell';
uselog = true;

nits = 10;
best = realmax; bestit = 0;
errit = zeros(nits,1);
%% Fit
for it = 1:nits
    [p0, p0_lb, p0_ub] = GetModelP0s(model);
    [params,err] = MinFunc(model, texp, stressexp, wexp, storexp, lossexp, p0, p0_lb, p0_ub, lambdas, uselog);
    if err < best
        bestPs = params;
        best = err;
        bestit = it;
    end
    errit(it) = best;
    length = fprintf("It %d/%d completed \r", it, nits);
end

%% Plot
PlotFits(model, texp, stressexp, wexp, storexp, lossexp, bestPs)
% figure
% plot(1:nits, errit)
%% Print best params
fprintf('Best params: %.2f \n', bestPs)
fprintf('With error %e at iteration %d\n', best, bestit)