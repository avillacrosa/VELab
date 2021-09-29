%--------------------------------------------------------------------------
% Write a 3D VTK with all elements, and the nodal displacements, stress
% tensors and strain tensors
%--------------------------------------------------------------------------
function writeVTK(x, Geo, Result, Mat, fname)
    fileH = fopen(fname, 'w+');
    
    header       = "# vtk DataFile Version 2.0\n";
    name         = "Cube example\n";
    data_type    = "ASCII\n";
    dataset_type = "DATASET UNSTRUCTURED_GRID\n";
    points_fmt   = sprintf("POINTS %i float \n", Geo.n_nodes);
    
    points    = cell(Geo.n_nodes,1);
    for pi = 1:Geo.n_nodes
        p = x(pi,:);
        pstr = sprintf('%.2f %.2f %.2f \n',p(1), p(2), p(3));
        points{pi} = pstr;
    end
    
    cells_head   = sprintf("CELLS %i %i \n", ...
                            Geo.n_elem, ...
                            Geo.n_nodes_elem*Geo.n_elem + Geo.n_elem);

    cells    = cell(Geo.n_elem,1);
    for c = 1:Geo.n_elem
        cstr = sprintf("%i ", Geo.n_nodes_elem);
        for cii = 1:8
            cstr = cstr + sprintf("%i ",Geo.n(c,cii)-1);
        end
        cstr = cstr + "\n";
        cells{c} = cstr;
    end
    
    cell_types    = sprintf("CELL_TYPES %i \n", Geo.n_elem);
    cell_type_val = '12 \n';
    
    lookup_scalars = sprintf("POINT_DATA %i \n", Geo.n_nodes);
   
    displacements = "VECTORS displacements float\n";
    for u_i = 1:size(Result.u,1)
        u = Result.u(u_i,:);
        displacements = displacements + sprintf("%.2f %.2f %.2f \n",...
            u(1), u(2), u(3));
    end
    
    % Nodal coordinates. FIXIT only for quad2...
    quad2 = [-1 1];
    nodal_zeta_coords = zeros(8,3);
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
            [sigma, ~] = material(xe, Xe, nodal_zeta_coords(a,:), Mat);
            sigmas(a,:,:)  = sigma;
            Fd = deformF(xe,Xe,nodal_zeta_coords(a,:), Geo.n_nodes_elem);
            strains(a,:,:) = (Fd'+Fd)/2-eye(size(Fd));
        end
    end

%     sigmas_xx = sprintf("SCALARS sigma_xx float 1 \nLOOKUP_TABLE default\n",...
%                         Geo.n_nodes);
%     sigmas_yy = sprintf("SCALARS sigma_yy float 1 \nLOOKUP_TABLE default\n",...
%                         Geo.n_nodes);
%     sigmas_zz = sprintf("SCALARS sigma_zz float 1 \nLOOKUP_TABLE default\n",...
%                         Geo.n_nodes);
    sigmas_tot  = sprintf("TENSORS sigma float \n");
    strains_tot = sprintf("TENSORS strain float \n");

    for a = 1:Geo.n_nodes
%         sigmas_xx  = sigmas_xx + sprintf("%.2f \n", sigmas(a,1,1));
%         sigmas_yy  = sigmas_yy + sprintf("%.2f \n", sigmas(a,2,2));
%         sigmas_zz  = sigmas_zz + sprintf("%.2f \n", sigmas(a,3,3));
        sigmas_tot = sigmas_tot + sprintf("%.1f %.1f %.1f \n %.1f %.1f %.1f \n %.1f %.1f %.1f \n\n",...
                            sigmas(a,1,1),sigmas(a,1,2),sigmas(a,1,3),...
                            sigmas(a,2,1),sigmas(a,2,2),sigmas(a,2,3),...
                            sigmas(a,3,2),sigmas(a,3,2),sigmas(a,3,3));
        strains_tot = strains_tot + sprintf("%.1f %.1f %.1f \n %.1f %.1f %.1f \n %.1f %.1f %.1f \n\n",...
                            strains(a,1,1),strains(a,1,2),strains(a,1,3),...
                            strains(a,2,1),strains(a,2,2),strains(a,2,3),...
                            strains(a,3,2),strains(a,3,2),strains(a,3,3));
                        
    end
    
    %Write
    fprintf(fileH, header);
    fprintf(fileH, name);
    fprintf(fileH, data_type);
    fprintf(fileH, dataset_type);
    fprintf(fileH, points_fmt);
    for pi = 1:Geo.n_nodes
        fprintf(fileH, points{pi});
    end
    fprintf(fileH, cells_head);
    for ci = 1:Geo.n_elem
        fprintf(fileH, cells{ci});
    end
    fprintf(fileH, cell_types);
    for cj = 1:Geo.n_elem
        fprintf(fileH, cell_type_val);
    end
    fprintf(fileH, lookup_scalars);
    fprintf(fileH, displacements);
%     fprintf(fileH, sigmas_xx);
%     fprintf(fileH, sigmas_yy);
%     fprintf(fileH, sigmas_zz);
    fprintf(fileH, sigmas_tot);
    fprintf(fileH, strains_tot);

    fclose(fileH);
    
end



