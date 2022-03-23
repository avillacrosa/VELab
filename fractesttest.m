clc; clear;
stress  = load('stress.txt');

texp = stress(:,1);
stressexp = stress(:,2);


ca = 16.9541;
E = 1.0930*1000;
a = 0.33;
b = 0;
dt = 1e-8;

% tend = 0.1;
% niter = ceil(tend/dt);
niter = 5000;

sigma = zeros(niter,1);
eps   = ones(size(sigma))*0.01;
sigma(1) = 1; % This corresponds to t=1

for k = 1:(niter-1)
    gl = glderiv(sigma, k, dt, -a, 2);
%     gl = gl/dt^(b-a);
%     gl_eps = glderiv(eps, k, dt, a);
%     sigma(k+1) = (gl_eps*cb*dt^(a-b)-gl)/(dt^(a-b)*cb/ca+1);
    J = E*ca/(E*dt^(a)+ca);
    sigma(k+1) = J*(eps(k+1)-gl/ca);
end
plot((0:niter-1)*dt+1, sigma , 'k') 
hold on

sigma = zeros(niter,1);
eps   = ones(size(sigma))*0.01;
sigma(1) = 1; % This corresponds to t=1
cb = E;
for k = 1:(niter-1)
    gl_sigma = glderiv(sigma, k, dt, a, 2);
    gl_eps   = glderiv(eps, k, dt, a, 1);
    sigma(k+1) = ca*dt^a*(cb*gl_eps-gl_sigma)/(cb*dt^a+ca);
end
plot((0:niter-1)*dt+1, sigma , '--') 
