%--------------------------------------------------------------------------
% General integral of the product B'*B matrix in both 2D and 3D. Used 
% mainly for viscoelasticity
%--------------------------------------------------------------------------
function Btot = intBB(Geo, Set)
    nnodes = Geo.n_nodes;
    ndim   = Geo.dim;

    Btot = zeros(nnodes*ndim, nnodes*ndim);

    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = Geo.x(Geo.n(e,:),:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            [dNdx, J] = getdNdx(xe,z, Geo.n_nodes_elem);
            B    = getB(dNdx);
            for a = 1:Geo.n_nodes_elem
                for b = 1:Geo.n_nodes_elem
                    sl_k = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
                    sl_l = (Geo.dim*(ne(b)-1)+1):Geo.dim*ne(b);
                    Ba = squeeze(B(a,:,:));
                    Bb = squeeze(B(b,:,:));
                    Btot(sl_k, sl_l) = Btot(sl_k, sl_l) + ...
                                    Ba'*Bb*J*Set.gaussWeights(gp,:);
                end
            end
        end
    end
end