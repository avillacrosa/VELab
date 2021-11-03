%--------------------------------------------------------------------------
% General integral of the B matrix in both 2D and 3D. Used mainly for
% viscoelasticity
%--------------------------------------------------------------------------
function Bvec = intB(Geo, Set)
    Bvec = zeros(Geo.vect_dim, Geo.n_nodes*Geo.dim);
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = Geo.x(ne,:) + Geo.u(ne,:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            [dNdx, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            B    = getB(dNdx);
            for a = 1:Geo.n_nodes_elem
                sl_k = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
                Ba = squeeze(B(a,:,:));
                Bvec(:, sl_k) = Bvec(:, sl_k)+Ba*J*Set.gaussWeights(gp,:);
            end
        end
    end
end