function [Geo, Set] = buildHelp(Geo, Set)
    % Additional help variables
    Geo.n_nodes           = size(Geo.X,1);
    Geo.dim               = size(Geo.X,2);
    Geo.n_elem            = size(Geo.n,1);
    Geo.n_nodes_elem      = size(Geo.n,2);
    Geo.n_nodes_elem_c    = 2*(Geo.dim-1); % Square approximation...
    Geo.vect_dim          = (Geo.dim+1)*Geo.dim/2;
    
    [Set.quadx, Set.quadw]                     = gaussQuad(Set.n_quad);
    [Set.gaussPoints, Set.gaussWeights]        = buildQuadPoints(Geo, Set);
    [Set.gaussPointsC, Set.gaussWeightsC]      = buildQuadPointsC(Geo,Set);
    [Set.cn, Set.cEq, Set.gausscP, Set.gausscW]= buildAreaDep(Geo,Set);

    Geo.times                 = buildTime(Geo);
    [Geo.u, Geo.dof, Geo.fix] = buildDirichlet(Geo, Set);
    [Geo.t, Geo.F]            = buildNeumann(Geo, Set);
    
    if maxSize(Geo) > 4
        fprintf("> Large mesh. Sparse will be used \n");
        Set.sparse = true;
    end
end