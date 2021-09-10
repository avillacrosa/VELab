close all;clc;
format short
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

X = x;
P = repmat([100 0.3], size(n,1),1);

n_ints  = 5000;
n_its   = 1;
max_tol = 10e-10;

% type       = 'nonlinear elastic';
% type       = 'linear elastic';
type       = 'linear viscoelastic';
mat_type   = 'hookean';
shape_type = 'square';
load_type  = 'surface';
algo_type  = 'forward';
x = run(x, n, t, x0, P, type, mat_type, shape_type, load_type, ...
        max_tol, n_ints, n_its, algo_type);

femplot(X, x, n)