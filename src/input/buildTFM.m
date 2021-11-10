function Geo = buildTFM(Geo)
    ustruct = load(Geo.u);
    nx = size(ustruct.ux,1);
    ny = size(ustruct.ux,2);
    
    Geo.ns         = [nx, ny, Geo.ns(1)];
    
    z = (Geo.ns(3)-1)*Geo.ds(3);
    Geo.dBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];
end