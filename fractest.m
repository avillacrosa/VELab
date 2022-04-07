clc; clear;
stress  = load('stress.txt');

texp = stress(:,1);
stressexp = stress(:,2);

G1 = 3.491862236912258e+04; % This could be calculated analytically
% G1 = 1; % This could be calculated analytically

ca = 229325.50;
cb = 42563.46;
a = 0.22 ;
b = 0.02 ;

%% 
% DT PROBLEM????????
%%
dt = 1e1;
tend = max(texp);
niter = ceil(tend/dt);
% niter = 600;

sigma = zeros(niter,1);
eps   = ones(size(sigma))*0.01;
sigma(1) = 340.74; % This corresponds to t=1, which is wrong if unnormalized
cutoffs = [5, 10, 20, 100];
for cut = 1:3
	for k = 1:(niter-1)
%     	gl_sigma = glderivtest(sigma, k, dt, a-b, 2, inf);
%     	gl_eps   = glderivtest(eps, k, dt, a, 1, inf);
		gl_sigma = glderivtest(sigma, k, dt, a-b, 2, cutoffs(cut));
    	gl_eps   = glderivtest(eps, k, dt, a, 1, cutoffs(cut));
    	J = ca/(dt^(a-b)*cb+ca);
    	sigma(k+1) = J*(cb*dt^(a-b)*gl_eps/1-dt^(a-b)*gl_sigma);
	end
	num = loglog((0:niter-1)*dt+1, sigma );
	% num = plot((0:niter-1)*dt+1, sigma , 'k');
	hold on
end
exp = loglog(texp, stressexp*0.01*G1, 'ko');

