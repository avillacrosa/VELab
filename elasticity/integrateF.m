function tint = integrateF(x, t, n, shape_type)

    nelem  = size(n,1);
    ndim   = size(x,2);
    nnodes = size(x,1);
    
    wi  = [1 1];
    wxi = [-1 1]/sqrt(3);
    
    tint = zeros(size(t));
    for e = 1:nelem
        A = 2*(n(e,:)-1)+1;
        B = 2*(n(e,:)-1)+2;
        ide = reshape([A;B], size(A,1), []);
        te = t(ide);
        xe = x(n(e,:),:);
        for a = 1:4
            for d = 1:ndim
                for j = 1:ndim
                    n_id  = 2*(n(e,a)-1)+d;
                    ne_id = 2*(a-1)+d;

                    [N, ~] = fshape(shape_type, [wxi(j), -1]);
                    [~, J] = getdNdx(shape_type, xe, [wxi(j), -1]);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*wi(j)*J^(1/ndim);

                    [N, ~] = fshape(shape_type, [+1, wxi(j)]);
                    [~, J] = getdNdx(shape_type, xe, [+1, wxi(j)]);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*wi(j)*J^(1/ndim);

                    [N, ~] = fshape(shape_type, [wxi(j), +1]);
                    [~, J] = getdNdx(shape_type, xe, [wxi(j), +1]);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*wi(j)*J^(1/ndim);

                    [N, ~] = fshape(shape_type, [-1, wxi(j)]);
                    [~, J] = getdNdx(shape_type, xe, [-1, wxi(j)]);
                    tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*N(a)*wi(j)*J^(1/ndim);
                end
            end
        end
    end
end