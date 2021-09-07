%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear elasticity (Venant) solved with NR with 4 elements               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;

addpath('elasticity')
addpath('elasticity/materials')

addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  1 0;  2 0;  0 1; 1 1;  2 1; 0 2 ; 1 2; 2 2]/2;
X = x;
t   = [ 0 0;  0 0;  5 0;  0 0; 0 0; 10 0; 0 0 ; 0 0; 5 0];
x0  = [1 1 0 ; 1 2 0 ; 2 2 0 ; 3 2 0 ; 4 1 0 ; 7 1 0 ;];
dx0 = 0;

n = [1 2 5 4; 2 3 6 5; 4 5 8 7; 5 6 9 8];

P = [  100    0.3    1; 100    0.3    1; 100    0.3    1; 100    0.3    1];

n_inc = 10;

x = newton(t, x, n, x0, dx0, P, n_inc, 'venant');

femplot(X,x,n);
