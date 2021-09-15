close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

% fname = 'topologies/square_1x1.mat';
% fname = 'topologies/square_2x2.mat';
% fname = 'topologies/square_2x2tri.mat'; % Weird! Try at home...
% fname = 'topologies/square_3x3.mat';

% load(fname);

x   = [ 0 0;  1 0;  1 1;  0 1];
n   = [1 2 3 4];
x0  = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];
t   = [ 2 1 10 ; 3 1 10];

% mat_type = 'neohookean';
mat_type = 'hookean';

% num_type = 'none';
% num_type = 'newton';
num_type = 'eulerf';
% visco_type = 'kelvin-voigt';
visco_type = 'maxwell';

%      Niter, tol        for newton
% numP = [10, 1e-10];

%      Nincr, dt, savef  for euler
numP = [1000, 0.0001, 20];

% For viscoelasticity only...
% t(:,3) = 0;
u0 = [0; 0; 0.1999; 0; 0.1999; -0.0599; 0; -0.0599];
u0 = zeros(size(u0));


% Values for a hookean material
P = repmat([100 0.3 1], size(n,1),1);

% Values for a neohookean
% P = repmat([57.7 38.5], size(n,1),1);

[Topo, Material, Numerical] = init(x, x0, n, t, P, mat_type, load_type, ...
                                    numP, num_type, visco_type, u0);
                                
Result = run(Topo, Material, Numerical);

% plot(Result.sigmas(:,1));

femplot(Topo.X, Result.x, Topo.n)