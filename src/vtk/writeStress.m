function stress_str = writeStress(x, Geo, Mat)
    stress_str = sprintf("TENSORS Stress float \n");
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

    sigmas  = zeros(Geo.n_nodes, Geo.dim, Geo.dim); 

    for e = 1:Geo.n_elem
        n = Geo.n;
        xe = x(n(e,:),:);
        Xe = Geo.X(n(e,:),:);
        for a = 1:Geo.n_nodes_elem
            [sigma, ~] = material(xe, Xe, nodal_zeta_coords(n(e,a),:), Mat);
            sigmas(n(e,a),:,:)  = sigma;
        end
    end
    for a = 1:Geo.n_nodes
        stress_str = stress_str + sprintf("%.1f %.1f %.1f \n %.1f %.1f %.1f \n %.1f %.1f %.1f \n\n",...
                            sigmas(a,1,1),sigmas(a,1,2),sigmas(a,1,3),...
                            sigmas(a,2,1),sigmas(a,2,2),sigmas(a,2,3),...
                            sigmas(a,3,2),sigmas(a,3,2),sigmas(a,3,3));
    end
end