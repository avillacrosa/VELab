function [u, dof, fix] = buildDirichlet(Geo)
    % Read as TFM: Generate u's, ns, and extra dBCs...
    fixdof = zeros(Geo.n_nodes*Geo.dim,1);
    u = zeros(Geo.n_nodes, Geo.dim, length(Geo.times));
    if isfield(Geo, 'ufile')
        udata = load(Geo.ufile);
        if isfield(udata, 'ux') && isfield(udata, 'uy')
            % TFM input
            ts = size(udata.ux,3);
            
            ztop = (Geo.ns(3)-1)*Geo.ds(3);
            dBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 ztop 3 0];
            [vals, hits] = dBCtoU(Geo, dBC);
            % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
            u(hits) = vals(hits);
            % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
            for ti = 1:ts
                uxt = vec_nvec(udata.ux(:,:,ti));
                uyt = vec_nvec(udata.uy(:,:,ti));
                u((end-Geo.ns(1)*Geo.ns(2)+1):end,[1,2], ti) = [uxt, uyt];
            end
            fixdof(ext_z(0, Geo)) = 1;
            fixdof(vec_nvec(hits)) = 1;
        else
            u = udata.u;
        end
    elseif isfield(Geo, 'u')
        u = Geo.u;
    elseif isfield(Geo, 'dBC')
        [vals, hits] = dBCtoU(Geo, Geo.dBC);
        u(hits)      = vals(hits);
        fixdof(vec_nvec(hits)) = 1;
    end
    dof = find(fixdof==0);
    fix = find(fixdof==1);
end