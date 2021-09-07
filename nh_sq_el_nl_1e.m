%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neo hookean material for a single element                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')


addpath('shape')
addpath('plotters')
addpath('solvers')

load = 10;

x   = [ 0 0;  0 1;  1 0;  1 1];
X = x;    
t   = [ 0 0;  0 0; load 0; load 0];    
x0   = [ 1 1 0; 1 2 0; 2 1 0; 3 2 0];
dx0 = 0;

n = [1 3 4 2];

P = [  58    38.5    1  ];

n_inc = 20;

x = newton(t, x, n, x0, dx0, P, n_inc, 'neohookean');
femplot(X,x,n);
