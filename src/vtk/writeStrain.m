function strain_str = writeStrain(x, Geo)
    strain_str = sprintf("TENSORS Strain float \n");

    % Nodal coordinates. FIXIT only for quad2...
    quad2 = [-1 1];
    nodal_zeta_coords = zeros(Geo.n_nodes_elem*Geo.n_elem,3);
    for i = 1:2
        for j = 1:2
            for k = 1:2
                idii = k+2*(j-1)+2*2*(i-1);
                nodal_zeta_coords(idii,:) = [quad2(i), quad2(j), quad2(k)];
            end
        end
    end

    % TODO : Repeated calculations, not most effective
    sigmas  = zeros(Geo.n_nodes, Geo.dim, Geo.dim); 
    strains = zeros(size(sigmas));
    for e = 1:Geo.n_elem
        n = Geo.n;
        xe = x(n(e,:),:);
        Xe = Geo.X(n(e,:),:);
        for a = 1:Geo.n_nodes_elem
            % FIXIT Linear only...
            Fd = deformF(xe,Xe,nodal_zeta_coords(n(e,a),:), Geo.n_nodes_elem);
            strains(n(e,a),:,:) = (Fd'+Fd)/2-eye(size(Fd));
        end
    end
    for a = 1:Geo.n_nodes    
        strain_str = strain_str + sprintf("%.1f %.1f %.1f \n %.1f %.1f %.1f \n %.1f %.1f %.1f \n\n",...
                            strains(a,1,1),strains(a,1,2),strains(a,1,3),...
                            strains(a,2,1),strains(a,2,2),strains(a,2,3),...
                            strains(a,3,2),strains(a,3,2),strains(a,3,3));  
    end
end