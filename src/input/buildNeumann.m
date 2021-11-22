function [t, F] = buildNeumann(Geo, Set)
    % Translate load input format to load vector
    t = zeros(Geo.n_nodes, Geo.dim, length(Geo.times));
    if isfield(Geo, 't')
        if strcmpi(Geo.t, 'random')
            t = randTFM(Geo, 15);
        elseif Set.TFM
            tdata = load(Geo.t);
            % TFM input
            ts = size(tdata.tr_x,3);
            for ti = 1:ts
                tr_xt = vec_nvec(tdata.tr_x(:,:,ti));
                tr_yt = vec_nvec(tdata.tr_y(:,:,ti));
                t((end-Geo.ns(1)*Geo.ns(2)+1):end,[1,2], ti) = [tr_xt, tr_yt];
            end
        else
            tstr = load(Geo.t);
            t = tstr.tr;
        end
    end
    [vals, hits] = BCtoNodal(Geo, Geo.tBC);
    % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
    t(hits) = vals(hits);
    % !!!!!!!!!!!!! TODO FIXIT !!!!!!!!!!!! traction is assumed constant!
    t = t(:,:,1);
%     M = areaMassNL(Geo.X, Geo, Set);
    M = areaMassLI(Geo.X, Geo, Set);
    F = M*t;
    % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
end

