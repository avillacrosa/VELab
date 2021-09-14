close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

fname = 'topologies/square_1x1.mat';
% fname = 'topologies/square_2x2.mat';
% fname = 'topologies/square_2x2tri.mat'; % Weird! Try at home...
% fname = 'topologies/square_3x3.mat';

load(fname);

x   = [ 0 0;  1 0;  1 1;  0 1];
n   = [1 2 3 4];
x0  = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];
t   = [ 2 1 10 ; 3 1 10];

% mat_type = 'neohookean';
mat_type = 'hookean';

% num_type = 'none';
% num_type = 'newton';
num_type = 'eulerb';
% visco_type = 'kelvin-voigt';
visco_type = 'maxwell2';

%      Niter, tol        for newton
% numP = [10, 1e-10];

%      Nincr, dt, savef  for euler
numP = [500, 0.001, 5];

u0 = [0; 0; 0.1999; 0; 0.1999; -0.0599; 0; -0.0599];
u0 = zeros(size(u0));

P = [100 0.3 1;100 0.3 1;100 0.3 1;100 0.3 1;];

[Topo, Material, Numerical] = init(x, x0, n, t, P, mat_type, load_type, ...
                                    numP, num_type, visco_type, u0);

Result = run(Topo, Material, Numerical);
femplot(Topo.X, Result.x, Topo.n)