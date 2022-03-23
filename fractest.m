clc; clear;
stress  = load('stress.txt');

texp = stress(:,1);
stressexp = stress(:,2);

G1 = 3.491862236912258e+04; % This could be calculated analytically
ca = 229325.50;
cb = 42563.46;
a = 0.22 ;
b = 0.02 ;

%% 
% DT PROBLEM????????
%%
dt = 1e0;
tend = max(texp);
niter = ceil(tend/dt);
% niter = 600;

sigma = zeros(niter,1);
eps   = ones(size(sigma));
sigma(1) = 1; % This corresponds to t=1

for k = 1:(niter-1)
    gl_sigma = glderiv(sigma, k, dt, a-b, 2, 300);
    gl_eps   = glderiv(eps, k, dt, a, 1, 300);
    J = ca/(dt^(a-b)*cb+ca);
    sigma(k+1) = J*(cb*dt^(a-b)*gl_eps/G1-dt^(a-b)*gl_sigma);
end
num = loglog((0:niter-1)*dt+1, sigma , 'k');
hold on
exp = loglog(texp, stressexp, 'ko');

