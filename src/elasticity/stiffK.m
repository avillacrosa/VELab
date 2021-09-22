function K = stiffK(Geom, Mat, Set)
    nnodes = Geom.n_nodes;
    ndim   = Geom.dim;

    K = zeros(nnodes*ndim, nnodes*ndim);

    quadw = Set.quadw;
    quadx = Set.quadx;
    n = Geom.n;
    for e = 1:Geom.n_elem
              
        ni = n(e,:);
        xe = Geom.x(n(e,:),:);
        Xe = Geom.X(n(e,:),:);
        for i = 1:size(quadw,2)
            for j = 1:size(quadw,2)
                for k = 1:size(quadw,2)
                    z = [quadx(i), quadx(j), quadx(k)];
                    D  = material(xe, Xe, e, z, Mat); 

                    [dNdx, J] = getdNdx(xe, z, Geom.n_nodes_elem);

                    B = getB(dNdx);

                    for ki = 1:nnodes
                        for li = 1:nnodes
                            nk = ni(ki);
                            nl = ni(li);
                            sl_k = (ndim*(nk-1)+1):ndim*nk;
                            sl_l = (ndim*(nl-1)+1):ndim*nl;
                            Bk = squeeze(B(ki,:,:));
                            Bl = squeeze(B(li,:,:));
                            K(sl_k,sl_l) = K(sl_k,sl_l)+ ...
                                   (Bk'*D*Bl)*quadw(i)*quadw(j)*quadw(k)*J;
                        end
                    end
                end
            end
        end
    end
end