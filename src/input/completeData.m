%--------------------------------------------------------------------------
% Collect the data obtained by the user's input file, fill fields left
% empty and define some internal variables to facilitate code 
%--------------------------------------------------------------------------
function  [Geo, Mat, Set] = completeData(Geo, Mat, Set)
    %% Default geometry values
    
    if ~isfield(Geo, 'X') || ~isfield(Geo, 'n') 
        fprintf("Initial coordinates not found. Quitting \n")
        return
    end

    DefGeo = struct();
    DefGeo.uBC      = [];
    DefGeo.tBC      = [];
    DefGeo.traction = true;
    DefGeo.randMag  = 10;
    DefGeo.x_units  = 1;
    
    DefMat = struct();
    DefMat.type   = 'hookean';
    DefMat.P      = [1 0];
    DefMat.visco  = 0;
    DefMat.rheo   = '';
    
    DefSet = struct();
    DefSet.type         = 'linear'; %TODO bad
    DefSet.n_steps      = 10;
    DefSet.newton_tol   = 1e-10;
    DefSet.time_incr    = 10000;
    DefSet.save_freq    = 1000;
    DefSet.dt           = 0.00001;
    DefSet.n_quad       = 2;
    DefSet.euler_type   = 'forward';
    DefSet.sparse       = false;
    DefSet.TFM          = false;
    DefSet.output       = 'normal'; %TODO bad
    
    Geo  = addDefault(Geo, DefGeo);
    Mat  = addDefault(Mat, DefMat);
    Set  = addDefault(Set, DefSet);
end
