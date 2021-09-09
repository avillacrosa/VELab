close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  0 1;  1 0;  1 1];
n   = [1 3 4 2];
x0  = [1 1 0; 1 2 0; 2 1 0; 3 2 0];
t   = [3 1 10; 4 1 10];
P   = [ 100  0.3 ];

type       = 'linear elastic';
mat_type   = 'hookean';
shape_type = 'square';
load_type  = 'surface';

u = run(x, n, t, x0, P, type, mat_type, shape_type);
femplot(x, x+u, n)