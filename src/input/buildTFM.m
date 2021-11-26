function Geo = buildTFM(Geo)
    ustruct = load(Geo.u);
    if isfield(ustruct, 'ux')
        nx = size(ustruct.ux,1);
        ny = size(ustruct.ux,2);
    elseif  size(ustruct,2) >= 5
        xs = unique(ustruct(:,1)); ys = unique(ustruct(:,2));
        nx = numel(xs);
        ny = numel(ys);
        Geo.ds(1) = xs(2) - xs(1);
        Geo.ds(2) = ys(2) - ys(1);
    end
    
    Geo.ns         = [nx, ny, Geo.ns(1)];
    
    z = (Geo.ns(3)-1)*Geo.ds(3);
    Geo.uBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];
end