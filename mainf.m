close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

% fname = 'topologies/square_1x1.mat';
fname = 'topologies/square_2x2.mat';
% fname = 'topologies/square_2x2tri.mat'; % Weird! Try at home...
% fname = 'topologies/square_3x3.mat';

load(fname);
X = x;

P = repmat([100 0.3], size(n,1),1);

n_ints  = 500;
n_its   = 5;
max_tol = 10e-10;

type       = 'nonlinear elastic';
% type       = 'linear elastic';
mat_type   = 'hookean';
shape_type = 'square';
load_type  = 'surface';
x = run(x, n, t, x0, P, type, mat_type, shape_type, load_type, ...
        max_tol, n_ints, n_its);

femplot(X, x, n)