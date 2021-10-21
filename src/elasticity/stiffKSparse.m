%--------------------------------------------------------------------------
% Obtain the constitutive component of the stiffness matrix both in 2D and
% 3D
%--------------------------------------------------------------------------
function K = stiffKSparse(Geo, Mat, Set)
    ndim   = Geo.dim;
    
    K_ids = {Geo.n_elem,1};
    K_val = {Geo.n_elem,1};
    n = Geo.n;
    t_hun = tic();
    for e = 1:Geo.n_elem
        ni = n(e,:);
        xe = Geo.x(n(e,:),:);
        Xe = Geo.X(n(e,:),:);
        
        if mod(e,100) == 0
            fprintf("Building K_c | Element %d/%d | Elapsed time: %f\n",...
                    e, Geo.n_elem, toc(t_hun));
            t_hun = tic();
        end
        
        ll = Geo.n_nodes_elem*Geo.dim;
        K_ids_e = zeros(ll^2,2);
        K_val_e = zeros(ll^2,1);
        
        for gp = 1:size(Set.gaussPoints,1)
            z = Set.gaussPoints(gp,:);

            [~, c] = material(xe, Xe, z, Mat);
            D = constD(c);
            if strcmpi(Mat.type,"hookean")
                [dNdx, J] = getdNdx(Xe, z, Geo.n_nodes_elem);
            else
                [dNdx, J] = getdNdx(xe, z, Geo.n_nodes_elem);
            end
            B = getB(dNdx);
            
            % TODO Iterate only over neighbors of nk...
            for ki = 1:Geo.n_nodes_elem
                for li = 1:Geo.n_nodes_elem
                    nk = ni(ki);
                    nl = ni(li);
                        
                    Bk = squeeze(B(ki,:,:));
                    Bl = squeeze(B(li,:,:));
                    int = (Bk'*D*Bl)*Set.gaussWeights(gp,:)*J;
                                        
                    % TODO Can this be an iteration over non-0 values only?
                    % TODO Only 2D...
                    for di = 1:Geo.dim
                        for dj = 1:Geo.dim
                            if int(di,dj) ~= 0
                                nid1 = (ndim*(nk-1)+di);
                                nid2 = (ndim*(nl-1)+dj);
                                
                                nid1_e = (ndim*(ki-1)+di);
                                nid2_e = (ndim*(li-1)+dj);
                                
                                g_id = Geo.n_nodes_elem*Geo.dim*(nid1_e-1)+nid2_e;
                                K_ids_e(g_id,:) = [nid1, nid2];
                                K_val_e(g_id) = K_val_e(g_id)+int(di,dj);
                            end
                        end
                    end
                end
            end
        end
        nz = K_ids_e(:,1)>0;
        K_ids_e = K_ids_e(nz,:);
        K_val_e = K_val_e(nz);
        K_ids{e} = K_ids_e';
        K_val{e} = K_val_e';
    end
    K_ids = cell2mat(K_ids);
    K_val = cell2mat(K_val);
    K_ids = K_ids';
    K_val = K_val';
    K = sparse(K_ids(:,1), K_ids(:,2), K_val);
end