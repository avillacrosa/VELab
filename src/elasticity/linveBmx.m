%--------------------------------------------------------------------------
% General integral of the product B'*B matrix in both 2D and 3D. Used 
% mainly for viscoelasticity
%--------------------------------------------------------------------------
function Btot = linveBmx(Geo, Set)
    Btot = zeros(Geo.vect_dim, Geo.n_nodes*Geo.dim);
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = Geo.x(Geo.n(e,:),:) + Geo.u(Geo.n(e,:),:);
        for gp = size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            [dNdx, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            B    = getB(dNdx);
            for a = 1:Geo.n_nodes_elem
                sl_k = (Geo.dim*(ne(a)-1)+1):Geo.dim*ne(a);
                Ba = squeeze(B(a,:,:));
                Btot(:, sl_k) = Btot(:, sl_k)+Ba*J*Set.gaussWeights(gp,:);
            end
        end
    end
end