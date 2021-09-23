function  [Geo, Mat, Set] = completeData(Geo, Mat, Set)
    %% Default geometry values
    Def_Geo = struct();
    
    [x, n]        = meshgen([2,2,2],[1,1,1]);
    Def_Geo.x     = x;
    Def_Geo.n     = n;
    Def_Geo.u     = zeros(size(x));
    Def_Geo.x0    = [];
    Def_Geo.f     = [];
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
    
    % Guess connectivity if not given
    if ~isfield(Geo, 'n')
        fprintf(['Connectivity not given. \n',...
                'Assuming elements are square and nodes are ',...
                'defined left to right and bottom to top \n']);
        nnodes_x = size(Geo.x, 1)^(1/size(Geo.x,2));
        nnodes_y = nnodes_x;
        nelem_x = nnodes_x-1;
        nelem_y = nelem_x;
        % TODO this is only for 2d...
        n = zeros(nelem_x*nelem_y,4);
        for ey = 1:nelem_y
            for ex = 1:nelem_x
                bl = ex+nnodes_y*(ey-1);
                br = ex+1+nnodes_y*(ey-1);
                tr = ex+nnodes_x+1+nnodes_y*(ey-1);
                tl = ex+nnodes_x+nnodes_y*(ey-1);
                n(ex+nelem_y*(ey-1),:) = [bl, br, tr, tl]';
            end
        end
        Geo.n = n;
    end
    
    % Additional help variables
    Geo.X                 = Geo.x;
    Geo.n_nodes           = size(Geo.x,1);
    Geo.dim               = size(Geo.x,2);
    Geo.n_elem            = size(Geo.n,1);
    Geo.n_nodes_elem      = size(Geo.n,2);
    Geo.n_nodes_dim       = Geo.n_nodes^(1/Geo.dim);
    Geo.vect_dim          = (Geo.dim+1)*Geo.dim/2;
    
    % Degrees of freedom for fast access. 
    if size(Geo.x0,1) ~= 0 
        fix  = 2*(Geo.x0(:,1)-1)+Geo.x0(:,2);
        dof  = zeros(Geo.dim*Geo.n_nodes,1);
        dof(fix)=1;
        dof = find(dof==0);
        Geo.dof               = dof;
        Geo.fixdof            = 2*(Geo.x0(:,1)-1)+Geo.x0(:,2);
    end
    [Set.quadx, Set.quadw] = gaussQuad(Set.n_quad);
    Set.gaussPoints  = zeros(Set.n_quad^Geo.dim,Geo.dim);
    Set.gaussWeights = zeros(Set.n_quad^Geo.dim, 1);
    for i = 1:Set.n_quad
        for j = 1:Set.n_quad
            if Geo.dim == 3
                for k = 1:Set.n_quad
                    z = [Set.quadx(i), Set.quadx(j), Set.quadx(k)];
                    w =  Set.quadw(i)*Set.quadw(j)*Set.quadw(k);
                    idx = k+Set.n_quad*(j-1)+Set.n_quad*Set.n_quad*(i-1);
                    Set.gaussPoints(idx,:)  = z;
                    Set.gaussWeights(idx) = w;
                end
            elseif Geo.dim == 2
                z = [Set.quadx(i), Set.quadx(j)];
                w =  Set.quadw(i)*Set.quadw(j);
                idx = j+2*(i-1);
                Set.gaussPoints(idx,:) = z;
                Set.gaussWeights(idx) = w;
            end
        end
    end
    
    % Translate load input format to load vector
    t = zeros(Geo.dim*Geo.n_nodes,1);
    for i = 1:size(Geo.f,1)
        t(Geo.dim*(Geo.f(:,1)-1) + Geo.f(:,2)) = Geo.f(:,3);
    end
    
    Geo.f     = t;

    if strcmp(Geo.ftype, 'surface')
        if Geo.dim == 2
            Geo.f = integrateF2D(Geo, Set);
        elseif Geo.dim == 3
            Geo.f = integrateF3D(Geo, Set);
        end
    end
end
