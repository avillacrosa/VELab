function stress_str = writeStressRec(Geo, Set, Result)
    stress_str = sprintf("TENSORS Stress float \n");
    sigmas  = zeros(Geo.dim, Geo.dim, Geo.n_nodes); 

    for e = 1:Geo.n_elem
        ne = Geo.n(e,:);
        sigmas(:,:,ne) = recoverNodals(Result.sigmas(:,:,:,e), Geo, Set);
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