function geoStr = writeGeo(x, Geo)    
    pointsStr   = sprintf("POINTS %i float \n", Geo.n_nodes);
    for pi = 1:Geo.n_nodes
        p = x(pi,:);
        pstr = sprintf('%.9f %.9f %.9f \n',p(1), p(2), p(3));
        pointsStr = pointsStr + pstr;
    end
    
    cellsStr   = sprintf("CELLS %i %i \n", ...
                            Geo.n_elem, ...
                            Geo.n_nodes_elem*Geo.n_elem + Geo.n_elem);
    for c = 1:Geo.n_elem
        cstr = sprintf("%i ", Geo.n_nodes_elem);
        for cii = 1:Geo.n_nodes_elem
            cstr = cstr + sprintf("%i ",Geo.n(c,cii)-1);
        end
        cstr = cstr + "\n";
        cellsStr = cellsStr + cstr;
    end
    
    cellsTStr    = sprintf("CELL_TYPES %i \n", Geo.n_elem);
    for ci = 1:Geo.n_elem
        cellsTStr = cellsTStr + '12 \n';
    end
    pdata = sprintf("POINT_DATA %i \n", Geo.n_nodes);

    geoStr = pointsStr + cellsStr + cellsTStr + pdata;
end