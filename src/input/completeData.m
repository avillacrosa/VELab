%--------------------------------------------------------------------------
% Collect the data obtained by the user's input file, fill fields left
% empty and define some internal variables to facilitate code 
%--------------------------------------------------------------------------
function  [Geo, Mat, Set] = completeData(Geo, Mat, Set)
    %% Default geometry values
    Def_Geo = struct();
    
    [x, n]        = meshgen([2,2,2],[1,1,1]);
    Def_Geo.x     = x;
    Def_Geo.n     = n;
    Def_Geo.dBC   = [];
    Def_Geo.fBC   = [];
    Def_Geo.ftype = 'surface';
    
    %% Default material values
    Def_Mat = struct();
    
    Def_Mat.type   = 'hookean';
    Def_Mat.P      = [1 0];
    Def_Mat.visco  = 0;
    Def_Mat.rheo   = '';
    
    %% Default numerical settings values
    Def_Set = struct();
    
    Def_Set.type         = 'linear';
    Def_Set.newton_its   = 10;
    Def_Set.newton_tol   = 1e-10;
    Def_Set.time_incr    = 1000;
    Def_Set.dt           = 0.001;
    Def_Set.save         = 50;
    Def_Set.n_quad       = 2;
    Def_Set.euler_type   = 'forward';
    
    % TODO FIXIT smart way for this?!
%     required = {'x'};
%     fprintf("Nodal positions not found. Exiting program... \n", f_name);
    
    Geo  = addDefault(Geo, Def_Geo);
    Mat  = addDefault(Mat, Def_Mat);
    Set  = addDefault(Set, Def_Set);
    
    %% Guess and define other useful parameters for computing
    

    % Additional help variables
    Geo.X                 = Geo.x;
    Geo.x_v               = vec_nvec(Geo.x);
    Geo.X_v               = Geo.x_v;
    Geo.n_nodes           = size(Geo.x,1);
    Geo.dim               = size(Geo.x,2);
    Geo.n_elem            = size(Geo.n,1);
    Geo.n_nodes_elem      = size(Geo.n,2);
    Geo.n_nodes_dim       = Geo.n_nodes^(1/Geo.dim);
    Geo.vect_dim          = (Geo.dim+1)*Geo.dim/2;
    Geo.x0                = nodalBC(Geo.x, Geo.dBC);
    Geo.f                 = nodalBCf(Geo.x, Geo.fBC);
    [Geo.dof, Geo.fix]    = buildBCs(Geo);
    [Geo.u, Set.p_type]   = buildUs(Geo);
    Geo.u_v               = vec_nvec(Geo.u);
    
    [Set.quadx, Set.quadw]              = gaussQuad(Set.n_quad);
    [Set.gaussPoints, Set.gaussWeights] = buildQuadPoints(Geo, Set);

    Geo.f                 = buildF(Geo, Set);
end
