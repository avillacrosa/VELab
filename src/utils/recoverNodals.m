function nodals = recoverNodals(gauss, Geo, Set)
    nodals = zeros(Geo.n_nodes_elem, Geo.dim, Geo.dim);
    M      = zeros(Geo.n_nodes_elem, Geo.n_nodes_elem);
    bmat = zeros(Geo.n_nodes_elem,Geo.vect_dim);
    for gp = 1:size(Set.gaussPoints,1)
        z = Set.gaussPoints(gp,:);
        Ns = fshape(Geo.n_nodes_elem, z);
        for a = 1:Geo.n_nodes_elem
            for b = 1:Geo.n_nodes_elem
                M(a,b) = M(a,b) + Ns(a)*Ns(b);
            end
            gauss_v = vec_mat(squeeze(gauss(gp,:,:)));
            bmat(a,:) = bmat(a,:) + Ns(a)*gauss_v';
        end
    end
    nodals_vec = M \ bmat;
    for ne_i = 1:Geo.n_nodes_elem
        nodals(ne_i,:,:) = ref_mat(nodals_vec(ne_i,:)');
    end
end