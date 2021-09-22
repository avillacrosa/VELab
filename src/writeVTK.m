function writeVTK(x, Geom, fname)
    fileH = fopen(fname, 'w+');
    
    x = x(Geom.n,:);
    
    header       = "# vtk DataFile Version 2.0\n";
    name         = "Cube example\n";
    data_type    = "ASCII\n";
    dataset_type = "DATASET UNSTRUCTURED_GRID\n";
    points_fmt   = sprintf("POINTS %i float \n", Geom.n_nodes);
    
    
    
    points    = cell(Geom.n_nodes,1);
    for pi = 1:Geom.n_nodes
        p = x(pi,:);
        pstr = sprintf('%.2f %.2f %.2f \n',p(1), p(2), p(3));
        points{pi} = pstr;
    end
    
    cells_head   = sprintf("CELLS %i %i \n", ...
                            Geom.n_elem, Geom.n_elem + Geom.n_nodes);

    cells    = cell(Geom.n_elem,1);
    for c = 1:Geom.n_elem
        cstr = sprintf("%i ", Geom.n_nodes_elem);
        for cii = 1:8
            cstr = cstr + sprintf("%i ",cii-1);
        end
        cstr = cstr + "\n";
        cells{c} = cstr;
    end
    
    cell_types    = sprintf("CELL_TYPES %i \n", Geom.n_elem);
    cell_type_val = '12 \n';
    
    %Write
    fprintf(fileH, header);
    fprintf(fileH, name);
    fprintf(fileH, data_type);
    fprintf(fileH, dataset_type);
    fprintf(fileH, points_fmt);
    for pi = 1:Geom.n_nodes
        fprintf(fileH, points{pi});
    end
    fprintf(fileH, cells_head);
    for ci = 1:Geom.n_elem
        fprintf(fileH, cells{ci});
    end
    fprintf(fileH, cell_types);
    for cj = 1:Geom.n_elem
        fprintf(fileH, cell_type_val);
    end
    fclose(fileH);
    
end



