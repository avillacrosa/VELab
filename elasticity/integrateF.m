function tint = integrateF(Topo)
    
    tint = zeros(size(Topo.f));
    ndim = Topo.dim;
    quadx = Topo.quadx;
    quadw = Topo.quadw;
    n = Topo.n;
    
    for e = 1:Topo.tote
        A = 2*(n(e,:)-1)+1;
        B = 2*(n(e,:)-1)+2;
        ide = reshape([A;B], size(A,1), []);
        te = Topo.f(ide);
        xe = Topo.x(n(e,:),:);
        for a = 1:Topo.ne
            for d = 1:ndim
                for j = 1:ndim
                    n_id  = 2*(n(e,a)-1)+d;
                    ne_id = 2*(a-1)+d;

                    [N, ~] = fshape(Topo.shape, [quadx(j), -1]);
                    [~, J] = getdNdx(xe, [quadx(j), -1], Topo.shape);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Topo.shape, [+1, quadx(j)]);
                    [~, J] = getdNdx(xe, [+1, quadx(j)], Topo.shape);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Topo.shape, [quadx(j), +1]);
                    [~, J] = getdNdx(xe, [quadx(j), +1], Topo.shape);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);

                    [N, ~] = fshape(Topo.shape, [-1, quadx(j)]);
                    [~, J] = getdNdx(xe, [-1, quadx(j)], Topo.shape);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*quadw(j)*J^(1/ndim);
                end
            end
        end
    end
end