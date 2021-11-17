function writeTract(Result, Geo, Set, name)    
    tr = Result.t;
    if strcmpi(Set.output, 'normal')
        if isfield(Result,'times')
            t = Result.times;
        else
            t = 0;
        end
        save(sprintf('output/tr_%s.mat', name), 'tr', 't');    
    elseif strcmpi(Set.output, 'tfm')
        tr_x = zeros(Geo.ns(1), Geo.ns(1), size(tr,3));
        tr_y = zeros(Geo.ns(2), Geo.ns(2), size(tr,3));
        % Yeah...
        zmax = Geo.X(:,3)==max(Geo.X(:,3));
        for ti = 1:size(tr,3)
            tr_t = tr(:,:,ti);
            tr_xt = tr_t(zmax, 1);
            tr_yt = tr_t(zmax, 2);
            tr_xt = reshape(tr_xt, [Geo.ns(1), Geo.ns(1)])';
            tr_yt = reshape(tr_yt, [Geo.ns(2), Geo.ns(2)])';
            tr_x(:,:,ti) = tr_xt;
            tr_y(:,:,ti) = tr_yt;
        end
        
        if isfield(Result,'times')
            t = Result.times;
        else
            t = 0;
        end
        save(sprintf('output/u_%s.mat', name), 'tr_x', 'tr_y', 't');
    end
end