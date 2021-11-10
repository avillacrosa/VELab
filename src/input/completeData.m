%--------------------------------------------------------------------------
% Collect the data obtained by the user's input file, fill fields left
% empty and define some internal variables to facilitate code 
%--------------------------------------------------------------------------
function  [Geo, Mat, Set] = completeData(Geo, Mat, Set)
    %% Default geometry values
    Def_Geo = struct();
    
    if ~isfield(Geo, 'X') || ~isfield(Geo, 'n') 
        fprintf("Initial coordinates not found. Quitting \n")
        return
    end

    Def_Geo.dBC      = [];
    Def_Geo.fBC      = [];
    Def_Geo.traction = true;
    Def_Geo.randMag  = 10;
    
    Def_Mat = struct();
    
    Def_Mat.type   = 'hookean';
    Def_Mat.P      = [1 0];
    Def_Mat.visco  = 0;
    Def_Mat.rheo   = '';
    
    Def_Set = struct();
    
    % char arrays must be bools (or flags)
    Def_Set.type         = 'linear'; %TODO bad
    Def_Set.n_steps      = 10;
    Def_Set.newton_tol   = 1e-10;
    Def_Set.time_incr    = 10000;
    Def_Set.n_saves      = 20;
    Def_Set.dt           = 0.00001;
    Def_Set.n_quad       = 2;
    Def_Set.euler_type   = 'forward';
    Def_Set.sparse       = false;
    Def_Set.TFM          = false;
    Def_Set.output       = 'normal'; %TODO bad
    
    Geo  = addDefault(Geo, Def_Geo);
    Mat  = addDefault(Mat, Def_Mat);
    Set  = addDefault(Set, Def_Set);
end
