function Mat = fitVE(stress_t, storage, loss, lambdas, model, uselog, nits)
	stress  = load(stress_t);
	storage = load(storage);
	loss    = load(loss);
	texp = stress(:,1); stressexp = stress(:,2);

	wexp = storage(:,1);
	storexp = storage(:,2);
	lossexp = loss(:,2);
	
	%% Fit
	for it = 1:nits
    	[p0, p0_lb, p0_ub] = getModelP0s(model);
    	[params,err] = minFunc(model, texp, stressexp, wexp, storexp, lossexp, p0, p0_lb, p0_ub, lambdas, uselog);
		if err < best
        	bestPs = params;
        	best = err;
        	bestit = it;
		end
	end	
	%% Plot
	plotFits(model, texp, stressexp, wexp, storexp, lossexp, bestPs)
	%% Print best params
	fprintf('Best params: %.2f \n', bestPs)
	fprintf('With error %e at iteration %d\n', best, bestit)
end

