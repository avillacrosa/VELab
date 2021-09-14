close all;clc;

addpath('elasticity')
addpath('elasticity/materials')
addpath('elasticity/stress')

addpath('shape')
addpath('plotters')
addpath('solvers')

x   = [ 0 0;  1 0;  1 1;  0 1];
X=x;
n   = [1 2 3 4];
x0  = [ 1 1 0; 1 2 0; 2 2 0; 4 1 0];
flt   = [ 2 1 10 ; 3 1 10];


mat_type = 'hookean';
num_type = 'eulerf';
numP = [1000, 0.0001, 5];


u0 = [   0
         0
    0.1999
         0
    0.1999
   -0.0599
         0
   -0.0599];


P = [100 0.3 1;100 0.3 1;100 0.3 1;100 0.3 1;];



types = ["kelvin-voigt", "maxwell"];                                
for j = 1:2
    i = 1;
    visco_type = types(j);
    
    [Topo, Material, Numerical] = init(X, x0, n, flt, P, mat_type, load_type, ...
                                    numP, num_type, visco_type, u0);
    Result = run(Topo, Material, Numerical);
    if strcmp(Material.visco_type, 'kelvin-voigt')
        x   = Result.strs;
        inf = Result.str_inf;
        t = Result.times;
        tau = Result.tau;
    elseif strcmp(Material.visco_type, 'maxwell')
        x   = Result.sigmas;
        inf = Result.sigma_0;
        t = Result.times;
        tau = Result.tau;
    end
    figure
    hold on
    % Time series
    plot(t, x(:,i))

    % Line
    if strcmp(Material.visco_type, 'maxwell')

        ft = inf(i)*(exp(-t/tau(i)));
        plot(t, ft, 'color', 'magenta')
        dydx = -inf(i)/tau(i);
        xcut = t(t < tau(i));
        % Tau line
        plot(xcut, dydx*xcut+inf(i), '--', 'color', 'red')

        % Tangential limit
        plot(t, inf(i)*ones(size(t)), '--', 'color', 'black')

        lgd = legend( {'Euler Solution','Analytical Solution','$\tau$', '$\sigma_{0}$'} , 'Interpreter', 'latex');

        yl = ylabel({'$\mathbf{\sigma_x}$'}, 'Interpreter', 'Latex');
    elseif strcmp(Material.visco_type, 'kelvin-voigt')

        ft = inf(i)*(1-exp(-t/tau(i)));
        plot(t, ft, 'color', 'magenta')

        % Tau line
        dydx = inf(i)/tau(i);
        xcut = t(t < tau(i));
        plot(xcut, dydx*xcut, '--', 'color', 'red')

        % Tangential limit
        plot(t, inf(i)*ones(size(t)), '--', 'color', 'black')

        lgd = legend( {'Euler Solution','Analytical Solution', '$\tau$', '$\varepsilon_{\inf}$'} , 'Interpreter', 'latex');
        yl = ylabel({'$\mathbf{\varepsilon_x}$'}, 'Interpreter', 'Latex');

    end
    
        % Horizontal and Vertical lines for strain inf and tau
        lgd.FontSize = 11;
        lgd.Location= 'southeast';
        yl.FontSize=16;
        xlabel('t');
        hold off
end