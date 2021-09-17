function  [Mat, Geom, Set] = completeData(Mat, Geom, Set)
    
    Default = struct();
    d_Geom = readGeom(Default, 'src/readers/d_geo.dat');
    d_Mat  = readMat(Default, 'src/readers/d_mat.dat');
    d_Set  = readSet(Default, 'src/readers/d_set.dat');
    
    % TODO FIXIT smart way for this?!
%     required = {'x'};
%     fprintf("Nodal positions not found. Exiting program... \n", f_name);
    
    Geom = addDefault(Geom, d_Geom);
    Set  = addDefault(Set, d_Set);
    Mat  = addDefault(Mat, d_Mat);
    
    % Guess connectivity if not given
    if ~isfield(Geom, 'n')
        fprintf(['Connectivity not given. \n',...
                'Assuming elements are square and nodes are ',...
                'defined left to right and bottom to top \n']);
        nnodes_x = sqrt(size(Geom.x, 1));
        nnodes_y = nnodes_x;
        nelem_x = nnodes_x-1;
        nelem_y = nelem_x;
        
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
        Geom.n = n;
    end
    
    % Additional help variables
    Geom.X                 = Geom.x;
    Geom.n_nodes           = size(Geom.x,1);
    Geom.dim               = size(Geom.x,2);
    Geom.n_elem            = size(Geom.n,1);
    Geom.n_nodes_elem      = size(Geom.n,2);
    
    % TODO FIXIT hardcode... This should be a parameter
    Geom.u = zeros(size(Geom.x));
    Geom.u = Geom.u(:);
    
    % Degrees of freedom for fast access. 
    fix  = 2*(Geom.x0(:,1)-1)+Geom.x0(:,2);
    dof  = zeros(Geom.dim*Geom.n_nodes,1);
    dof(fix)=1;
    dof = find(dof==0);
    Geom.dof               = dof;
    Geom.fixdof            = 2*(Geom.x0(:,1)-1)+Geom.x0(:,2);
    
    % Translate load input format to load vector
    t = zeros(Geom.dim*Geom.n_nodes,1);
    for i = 1:size(Geom.f,1)
        t(2*(Geom.f(:,1)-1) + Geom.f(:,2)) = Geom.f(:,3);
    end
    Geom.f     = t;
    
    [Set.quadx, Set.quadw] = gaussQuad(Set.n_quad);
end
