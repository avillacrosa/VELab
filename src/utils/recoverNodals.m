function nodals_vec = recoverNodals(gauss, Geo, Set)
    M      = zeros(Geo.n_nodes_elem, Geo.n_nodes_elem);
    bmat = zeros(Geo.n_nodes_elem, Geo.vect_dim);
    for gp = 1:size(Set.gaussPoints,1)
        z = Set.gaussPoints(gp,:);
        Ns = fshape(Geo.n_nodes_elem, z);
        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                M(a,b) = M(a,b) + Ns(a)*Ns(b);
            end
            % TODO FIXIT, THIS MIGHT BE OFF...
            bmat(a,:) = bmat(a,:) + Ns(a)*gauss(gp,:);
        end
    end
    nodals_vec = M \ bmat;
end