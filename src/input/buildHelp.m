function [Geo, Set] = buildHelp(Geo, Mat, Set)
    % Additional help variables
    Geo.n_nodes           = size(Geo.X,1);
    Geo.dim               = size(Geo.X,2);
    Geo.n_elem            = size(Geo.n,1);
    Geo.n_nodes_elem      = size(Geo.n,2);
    Geo.n_nodes_elem_c    = 2*(Geo.dim-1); % Square approximation...
    Geo.vect_dim          = (Geo.dim+1)*Geo.dim/2;
    if ~isfield(Geo, 'x0')
        Geo.x0                = nodalBC(Geo, Geo.dBC, 0);
    end
    [Geo.dof, Geo.fix]    = buildDOF(Geo);
    Geo.u                 = buildDirichlet(Geo);
    [Set.quadx, Set.quadw]                     = gaussQuad(Set.n_quad);
    [Set.gaussPoints, Set.gaussWeights]        = buildQuadPoints(Geo, Set);
    [Set.gaussPointsC, Set.gaussWeightsC]      = buildQuadPointsC(Geo,Set);

    if maxSize(Geo) > 4
        fprintf("> Large mesh. Sparse will be used \n");
        Set.sparse = true;
    end
    [Set.cn, Set.cEq, Set.gausscP, Set.gausscW] = buildAreaDep(Geo,Set);

    [Geo.t, Geo.F] = buildNeumann(Geo, Set);
    
end