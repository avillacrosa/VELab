function time = buildTime(Geo)
    % TODO FIXIT bad code...
    if isfield(Geo, 'u') 
        if ~strcmpi(Geo.u, 'random')
            ustruct = load(Geo.u);
            if isfield(ustruct, 't')
                time = ustruct.t;
            end
        else
            time = 0;
        end
    elseif isfield(Geo, 't')
        if ~strcmpi(Geo.t, 'random')
            tstruct = load(Geo.t);
            if isfield(tstruct, 't')
                time = tstruct.t;
            end
        else
            time = 0;
        end
    else
       time = 0; 
    end
end