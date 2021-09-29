%--------------------------------------------------------------------------
% Geometrical or initial stress component of the stiffness matrix for 2D
% and 3D
%--------------------------------------------------------------------------
function K = initStressK(Geo, Mat, Set)

    K = zeros(Geo.n_nodes*Geo.dim);
    
    for e = 1:Geo.n_elem
        ni = Geo.n(e,:);
        xe = Geo.x(ni,:);
        Xe = Geo.X(ni,:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            [sigma, ~] = material(xe, Xe, z, Mat);
            [dNdx, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            for ki = 1:Geo.n_nodes_elem
                for li = 1:Geo.n_nodes_elem
                    nk = ni(ki);
                    nl = ni(li);
                    sl_k = (Geo.dim*(nk-1)+1):Geo.dim*nk;
                    sl_l = (Geo.dim*(nl-1)+1):Geo.dim*nl;
                    K(sl_k,sl_l) = K(sl_k,sl_l)+J*dNdx(ki,:)*sigma*...
                                            dNdx(li,:)'*eye(Geo.dim)...
                                            *Set.gaussWeights(gp,:);

                end
            end
        end
    end    
end