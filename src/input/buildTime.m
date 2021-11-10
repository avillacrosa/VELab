function time = buildTime(Geo)
    if isfield(Geo, 'ufile') 
        ustruct = load(Geo.ufile);
        if isfield(ustruct, 't')
            time = ustruct.t;
        end
    else
       time = 0; 
    end
end