function M = massM(Geo, Set)
    M      = zeros(Geo.n_nodes_elem, Geo.n_nodes_elem);
    for gp = 1:size(Set.gaussPoints,1)
        z = Set.gaussPoints(gp,:);
        Ns = fshape(Geo.n_nodes_elem, z);
        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                M(a,b) = M(a,b) + Ns(a)*Ns(b);
            end
        end
    end
end