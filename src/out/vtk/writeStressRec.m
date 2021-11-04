function stress_str = writeStressRec(x, Geo, Mat, Set)
    stress_str = sprintf("TENSORS Stress float \n");

    sigmas  = zeros(Geo.n_nodes, Geo.dim, Geo.dim); 

    for e = 1:Geo.n_elem
        sigmas_e = zeros(Geo.n_nodes_elem, Geo.dim, Geo.dim); 
        ne = Geo.n(e,:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            [sigma, ~] = material(xe, Xe, z, Mat);
            sigmas_e(gp,:,:)  = sigma;
        end
        sigmas_e_n = recoverNodals(sigmas_e, Geo, Set);
        sigmas(ne,:,:) = sigmas_e_n(:,:,:);
    end
    
    for a = 1:Geo.n_nodes
        stress_str = stress_str + sprintf("%.6f %.6f %.6f \n"+...
                                          "%.6f %.6f %.6f \n"+...
                                          "%.6f %.6f %.6f \n\n",...
                            sigmas(a,1,1),sigmas(a,1,2),sigmas(a,1,3),...
                            sigmas(a,2,1),sigmas(a,2,2),sigmas(a,2,3),...
                            sigmas(a,3,1),sigmas(a,3,2),sigmas(a,3,3));
    end
end