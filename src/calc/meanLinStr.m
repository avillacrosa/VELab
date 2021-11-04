function strain_mean = meanLinStr(x, Geo, Set)
    strains  = zeros(Geo.n_nodes, Geo.dim, Geo.dim); 
    strain_mean = 0;
    for e = 1:Geo.n_elem
        strains_e = zeros(Geo.n_nodes_elem, Geo.dim, Geo.dim); 
        ne = Geo.n(e,:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            Fd = deformF(xe,Xe, z, Geo.n_nodes_elem);
            strains_e(gp,:,:) = (Fd'+Fd)/2-eye(size(Fd));
        end
        strains_e_n = recoverNodals(strains_e, Geo, Set);
        strains(ne,:,:) = strains_e_n(:,:,:);
        strain_mean = strain_mean + mean(norm(strains), 'all');
    end
    strain_mean = strain_mean + mean(norm(strains), 'all');
end