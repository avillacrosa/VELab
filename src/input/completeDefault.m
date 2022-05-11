%--------------------------------------------------------------------------
% Collect the data obtained by the user's input file, fill fields left
% empty and define some internal variables to facilitate code 
%--------------------------------------------------------------------------
function  [Geo, Mat, Set] = completeDefault(Geo, Mat, Set)
    %% Default geometry values
    
    if ~isfield(Geo, 'X') || ~isfield(Geo, 'n') 
        fprintf("Initial coordinates not found. Quitting \n")
        return
    end

    DefGeo = struct();
    DefGeo.uBC      = [];
    DefGeo.tBC      = [];
    DefGeo.randMag  = 10;
    DefGeo.x_units  = 1;
	DefGeo.w        = 1;
	DefGeo.uPR      = '';
    
    DefMat = struct();
    DefMat.type   = 'hookean';
    DefMat.visco  = 0;
    DefMat.rheo   = '';
    
    DefSet = struct();
    DefSet.n_steps       = 10;
    DefSet.newton_tol    = 1e-10;
    DefSet.time_incr     = 1;
    DefSet.save_freq     = 1;
    DefSet.dt            = 0.00001;
    DefSet.n_quad        = 2;
    DefSet.euler_type    = 'forward';
	DefSet.output        = '';
    DefSet.sparse        = false;
    DefSet.TFM           = false;
	DefSet.calc_stress   = false;
	DefSet.calc_strain   = false;
	DefSet.plot_strain   = false;
	DefSet.plot_stress   = false;
    
    Geo  = addDefault(Geo, DefGeo);
    Mat  = addDefault(Mat, DefMat);
    Set  = addDefault(Set, DefSet);

	DefSet.dt_obs        = Set.dt;
	DefSet.name = sprintf('%s_%s',Mat.type, Mat.rheo);
    Set  = addDefault(Set, DefSet);
end
