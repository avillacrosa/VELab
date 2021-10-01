%--------------------------------------------------------------------------
% Obtain the constitutive component of the stiffness matrix both in 2D and
% 3D
%--------------------------------------------------------------------------
function K = stiffK(Geo, Mat, Set)
    nnodes = Geo.n_nodes;
    ndim   = Geo.dim;

    K = zeros(nnodes*ndim, nnodes*ndim);
    n = Geo.n;
    for e = 1:Geo.n_elem
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
            
            for ki = 1:Geo.n_nodes_elem
                for li = 1:Geo.n_nodes_elem
                    nk = ni(ki);
                    nl = ni(li);
                    sl_k = (ndim*(nk-1)+1):ndim*nk;
                    sl_l = (ndim*(nl-1)+1):ndim*nl;
                    Bk = squeeze(B(ki,:,:));
                    Bl = squeeze(B(li,:,:));
                    K(sl_k,sl_l) = K(sl_k,sl_l)+ ...
                           (Bk'*D*Bl)*Set.gaussWeights(gp,:)*J;
                end
            end
        end
    end
end