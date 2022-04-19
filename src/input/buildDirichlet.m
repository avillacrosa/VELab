function [u, dof, fix] = buildDirichlet(Geo, Set)
    % Read as TFM: Generate u's, ns, and extra dBCs...
    fixdof = zeros(Geo.n_nodes*Geo.dim,1);
    u = zeros(Geo.n_nodes, Geo.dim, length(Geo.time));
    
    % Geo.u might be 'random' or an actual file name 'fname'
    % Geo.uBC is always an array
    % TODO pretty sure some of these if's might be grouped by setting uBC
    % to 0 if not given.
    % A file given AND additional plane boundaries (TFM)
    % Assume that these two types of boundaries have NO intersection
    if isfield(Geo, 'u')
        if strcmpi(Geo.u, 'random')
            % Geo.u equals to random
            u = randTFM(Geo, max(Geo.ds)/32);
        elseif Set.TFM
            % Geo.u presumably equals to the name of a file containing tfm's u
            udata = load(Geo.u);
            % TFM input
            if isfield(udata, 'ux')
                ts = size(udata.ux,3);
                ux = udata.ux; uy = udata.uy;
            elseif size(udata, 2) >= 5
                ts = 1;
                ux = vec_to_grid(udata(:,3), Geo);
                % TODO FIXME at the moment, data from agata, increases
                % first in y than x. In this code the opposite is assumed,
                % so a transposition is necessary
                ux = ux'; 
                uy = vec_to_grid(udata(:,4), Geo);
                uy = uy';
            end
            for ti = 1:ts
                uxt = grid_to_vec(ux(:,:,ti));
                uyt = grid_to_vec(uy(:,:,ti));
                u((end-Geo.ns(1)*Geo.ns(2)+1):end,[1,2], ti) = [uxt, uyt];
            end
        else
            % Geo.u presumably equals to the name of a file containing 
            % displacements for every node
            u = load(Geo.u);
            u = u.u;
        end
    end
    % TODO FIXIT: CAN WE ASSUME THIS?
    fixdof(vec_nvec(u(:,:,end))~=0) = 1;
    [vals, hits] = BCtoNodal(Geo, Geo.uBC);
    % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
    u(hits) = vals(hits);
    % !---- TODO THIS MIGHT BE TOO MUCH OF A STRETCH ----!
    fixdof(vec_nvec(hits(:,:,end))) = 1;
    dof = find(fixdof==0);
    fix = find(fixdof==1);
end


