function stress_t = calcStressFMX(strain_k, k, stress_t, Geo, Mat, Set)
	a = Mat.alpha;
	b = Mat.beta;
	ca = Mat.c_alpha;
	cb = Mat.c_beta;
	dt = Set.dt;
	gl_eps = glderivTensor(strain_k, k, dt, a, 1, inf);
	gl_sigma = glderivTensor(stress_t, k, dt, a-b, 2, inf);
	J = ca/(dt^(a-b)*cb+ca);
	stress_t = J*(cb*dt^(a-b)*gl_eps/1-dt^(a-b)*gl_sigma);
end