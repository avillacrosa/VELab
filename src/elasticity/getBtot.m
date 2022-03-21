function B = getBtot(x, Geo, Mat, Set)
    B = zeros(Geo.n_nodes*Geo.vect_dim, Geo.dim);
    % INITIAL STRAIN CASE
    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        xe = x(ne,:);
        for a = 1:Geo.n_nodes_elem
            for gp = 1:size(Set.gaussPoints,1)
                z = Set.gaussPoints(gp,:);
                dNdx = getdNdx(xe,z,Geo.n_nodes_elem);
                for a = 1:Geo.n_nodes_elem
                    na = ne(a);
                    B(Geo.vect_dim*(ne-1)+1:Geo.vect_dim*(ne)+1, :) = getB(dNdx);
                end
            end
        end
    end
end