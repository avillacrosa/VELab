function Geo = buildTFM(Geo)
    if (isstring(Geo.u) || ischar(Geo.u))
        u_read         = readUTFM(Geo.u);
    else
        u_read = Geo.u;
    end
    
    n_nodes_xy     = size(u_read,1);
    Geo.u          = zeros(n_nodes_xy*Geo.ns(1), 3);

    Geo.u((end-n_nodes_xy+1):end,[1,2]) = u_read;
    Geo.ns         = [n_nodes_xy^(1/2), n_nodes_xy^(1/2), Geo.ns(1)];
    
    z = (Geo.ns(3)-1)*Geo.ds(3);
    Geo.dBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 
                       3 z 1 z; 3 z 2 z; 3 z 3 z];
end