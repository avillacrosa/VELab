function [tx_t, ty_t] = shrineRunVE(dt, E, nu, d, h, ux, uy, tmax, settings_ve)
    %% Define simulation parameters for TFM
    fprintf("> Initiating viscoelastic FEM solver for TFM \n")

    nz = 3;
	Geo.ns        = [size(ux,1), size(ux,2), nz];
	Geo.ds        = [d, d, h/nz];

    Geo.uPR = zeros(Geo.ns(1)*Geo.ns(2)*Geo.ns(3), 3, size(ux,3));
    Geo.dim = 3;
    [~, zl_idx] = ext_z(0, Geo);
    for t = 1:size(ux,3)
        Geo.uPR(zl_idx,[1,2],t) = [grid_to_vec(ux(:,:,t)), grid_to_vec(uy(:,:,t))];
    end
    Geo.uBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 h 3 0];
    
	Mat.E  = E; Mat.nu = nu;
	Mat.type = 'hookean'; Mat.rheo = 'maxwell';
	Mat.visco = 10;

	Set.dt     = dt; Set.dt_obs = Set.dt;
	Set.time_incr = tmax; Set.save_freq = 1;
	Set.output = false;
    Set.name = 'tfm_fem';
    %% Run
	Result = runVE(Geo, Mat, Set);

    %% Extract and return tractions
    tx_t = zeros(size(ux,1), size(uy,2), size(ux,3));
    ty_t = zeros(size(ux,1), size(uy,2), size(ux,3));
    for t = 1:size(ux,3)
        tx_t(:,:,t) = vec_to_grid(Result.t_top(:,1,t), Geo);
        ty_t(:,:,t) = vec_to_grid(Result.t_top(:,2,t), Geo);
    end
end

