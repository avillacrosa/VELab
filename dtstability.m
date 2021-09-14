close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')


x   = [ 0 0;  1 0;  1 1;  0 1];
n   = [1 2 3 4];
x0  = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];
t   = [ 2 1 10 ; 3 1 10];

mat_type   = 'hookean';
num_type   = 'eulerf';
visco_type = 'kelvin-voigt';
load_type  ='surface';
u0 = [   0
         0
         0
   -0.0599
    0.1999
         0
    0.1999
   -0.0599];

P = [100 0.3 1;100 0.3 1;100 0.3 1;100 0.3 1;];

ninc = 4;
dts   = logspace(-2, -ninc-1, ninc );
legend_labs = zeros(ninc,1);

colors = ["blue", "red", "green", "magenta"];
colors2 = ["bl", "red", "green", "magenta"];

figure
hold on
for i = 1:ninc
    numP = [5000, dts(i), 5];
    [Topo, Material, Numerical] = init(x, x0, n, t, P, mat_type, load_type, ...
                                    numP, num_type, visco_type, u0);
    Result = run(Topo, Material, Numerical);
    plot(Result.strs(:,1), 'color', colors(i))
    legend_labs(i) = dts(i);
end

num_type = 'eulerb';

for i = 1:ninc
    numP = [5000, dts(i), 5];
    [Topo, Material, Numerical] = init(x, x0, n, t, P, mat_type, load_type, ...
                                    numP, num_type, visco_type, u0);
    Result = run(Topo, Material, Numerical);
    plot(Result.strs(:,1), '--' ,'color', 'black')
    legend_labs(i) = dts(i);
end