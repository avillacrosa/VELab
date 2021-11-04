function strain_str = writeStrainRec(x, Geo, Set)
    strain_str = sprintf("TENSORS Strain float \n");
    
    strains  = zeros(Geo.n_nodes, Geo.dim, Geo.dim); 

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
    end
    for a = 1:Geo.n_nodes    
        strain_str = strain_str + sprintf("%.6f %.6f %.6f \n"+...
                                          "%.6f %.6f %.6f \n"+...
                                          "%.6f %.6f %.6f \n\n",...
                            strains(a,1,1),strains(a,1,2),strains(a,1,3),...
                            strains(a,2,1),strains(a,2,2),strains(a,2,3),...
                            strains(a,3,1),strains(a,3,2),strains(a,3,3));  
    end
end