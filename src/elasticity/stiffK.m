%--------------------------------------------------------------------------
% Obtain the constitutive component of the stiffness matrix both in 2D and
% 3D
%--------------------------------------------------------------------------
function K = stiffK(Geo, Mat, Set)
    nnodes = Geo.n_nodes;
    ndim   = Geo.dim;

    % TODO try catch here
%     K = zeros(nnodes*ndim, nnodes*ndim);
    
    n = Geo.n;
    ll = Geo.n_nodes_elem*Geo.dim;
    K_id1 = zeros(ll^2*Geo.n_elem,1);
    K_id2 = zeros(ll^2*Geo.n_elem,1);
    K_val = zeros(ll^2*Geo.n_elem,1);
    k = 1;

    for e = 1:Geo.n_elem
        Ke     = zeros(Geo.n_nodes_elem*ndim, Geo.n_nodes_elem*ndim);
        Ke_id1 = zeros(Geo.n_nodes_elem*ndim, Geo.n_nodes_elem*ndim);
        Ke_id2 = zeros(Geo.n_nodes_elem*ndim, Geo.n_nodes_elem*ndim);
        
        ni = n(e,:);
        xe = Geo.x(n(e,:),:);
        Xe = Geo.X(n(e,:),:);
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
            
            for a = 1:Geo.n_nodes_elem
                for b = 1:Geo.n_nodes_elem
                    sl_a_e = (ndim*(a-1)+1):ndim*a;
                    sl_b_e = (ndim*(b-1)+1):ndim*b;
                    
                    Bk = squeeze(B(a,:,:));
                    Bl = squeeze(B(b,:,:));
                    
                    na = ni(a);
                    nb = ni(b);
                    sl_a = (ndim*(na-1)+1):ndim*na;
                    sl_b = (ndim*(nb-1)+1):ndim*nb;
                    % TODO repeats here
                    Ke_id1(sl_a_e) = sl_a;
                    Ke_id2(sl_b_e) = sl_b;
                    
                    Ke(sl_a_e, sl_b_e) = Ke(sl_a_e, sl_b_e)+ ...
                           (Bk'*D*Bl)*Set.gaussWeights(gp,:)*J;
                end
            end
        end
        for aa = 1:size(Ke,1)
            for bb = 1:size(Ke,2)
                K_id1(k) = Ke_id1(aa);
                K_id2(k) = Ke_id2(bb);
                K_val(k) = Ke(aa,bb);
                k = k+1;
            end
        end
    end
    nz = K_id1>0;
    K_id1 = K_id1(nz);
    K_id2 = K_id2(nz);
    K_val = K_val(nz);
    K = sparse(K_id1, K_id2, K_val);
end