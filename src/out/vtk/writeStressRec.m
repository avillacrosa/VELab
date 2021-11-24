function stress_str = writeStressRec(x, Geo, Mat, Set)
    stress_str = sprintf("TENSORS Stress float \n");

    sigmas  = zeros(Geo.dim, Geo.dim, Geo.n_nodes); 

    for e = 1:Geo.n_elem
        sigmas_e = zeros(Geo.dim, Geo.dim, Geo.n_nodes_elem); 
        ne = Geo.n(e,:);
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);
            
            xe = x(ne,:);
            Xe = Geo.X(ne,:);
            sigma = material(xe, Xe, z, Mat);
            sigmas_e(:,:,gp)  = sigma;
        end
        sigmas_e_n = recoverNodals(sigmas_e, Geo, Set);
        sigmas(:,:,ne) = sigmas_e_n(:,:,:);
    end
    
    for a = 1:Geo.n_nodes
        stress_str = stress_str + sprintf("%.9f %.9f %.9f \n"+...
                                          "%.9f %.9f %.9f \n"+...
                                          "%.9f %.9f %.9f \n\n",...
                            sigmas(1,1,a),sigmas(1,2,a),sigmas(1,3,a),...
                            sigmas(2,1,a),sigmas(2,2,a),sigmas(2,3,a),...
                            sigmas(3,1,a),sigmas(3,2,a),sigmas(3,3,a));
    end
end