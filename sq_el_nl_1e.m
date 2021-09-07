clc

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')


addpath('shape')
addpath('plotters')
addpath('solvers')

% x   = [ 0 0;  1 0;  1 1;  0 1];        
% X = x;
% t   = [ 0 0;  10 0; 10 0; 0 0];        
% x0  = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];   
% dx0 = 0;
% n = [1 2 3 4];

x   = [ 0 0;  0 1;  1 0;  1 1];
X = x;
t   = [ 0 0;  0 0; 10 0; 10 0];    
x0   = [ 1 1 0; 1 2 0; 2 1 0; 3 2 0];
dx0 = 0;
n = [1 3 4 2];

% Material properties, one for element
P = [  100    0.3    1  ];

n_inc = 1;

x = newton(t, x, n, x0, dx0, P, n_inc, 'venant');
femplot(X,x,n);
