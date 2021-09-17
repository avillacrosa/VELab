function Geom = readGeom(Geom, geom_file)

    topo_data = regexp(fileread(geom_file),'\n','split');

    search_keyw = ["NODES", "CONNECTIVITY", "BOUNDARY", "LOADS"];
    [used_keyw, k_rs] = usedKeyw(topo_data, search_keyw);
    
    for k = 1:size(used_keyw,2)
       k_r = k_rs(k,:);
       switch used_keyw(k)
           case "NODES"
              Geom.x  = read_x(topo_data, k_r);
           case "CONNECTIVITY"
              Geom.n  = read_n(topo_data, k_r);
           case "BOUNDARY"
              Geom.x0 = read_x0(topo_data, k_r);
           case "LOADS"
              Geom.f  = read_t(topo_data, k_r);
       end
    end
end
