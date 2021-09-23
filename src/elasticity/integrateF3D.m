function tint = integrateF3D(Geo, Set)
    
    tint = zeros(size(Geo.f));
    ndim = Geo.dim;
    quadx = Set.quadx;
    quadw = Set.quadw;
    n = Geo.n;
    summ = zeros(6,1);
    for e = 1:Geo.n_elem
        A = Geo.dim*(n(e,:)-1)+1;
        B = Geo.dim*(n(e,:)-1)+2;
        C = Geo.dim*(n(e,:)-1)+3;
        ide = reshape([A;B;C], size(A,1), []);
        te = Geo.f(ide);
        xe = Geo.x(n(e,:),:);
        for a = 2:2
%             for d = 1:ndim
                for j = 1:Set.n_quad
                    for k = 1:Set.n_quad
%                         n_id  = Geo.dim*(n(e,a)-1)+d;

%                         ne_id = Geo.dim*(a-1)+d;

                        front = [+1, quadx(k), quadx(j)];
                        back  = [-1, quadx(k), quadx(j)];
                        right = [quadx(k), +1, quadx(j)];
                        left  = [quadx(k), -1, quadx(j)];
                        top   = [quadx(k), quadx(j), +1];
                        bot   = [quadx(k), quadx(j), -1];

                        points = [front; back; right; left; top; bot];
                        for face_i = 1:size(points,1)
                            z = points(face_i,:);
                            [N, ~] = fshape(Geo.n_nodes_elem, z);
                            [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
%                             if n_id == 4
%                                 fprintf(" Face: %i, Val: %.2f \n", face_i, ...
%                                     N(a)*J^((ndim-1)/ndim));
%                             end
                            summ(face_i) = summ(face_i) + te(4, :)*N(a)*J^((ndim-1)/ndim);
%                             tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*...
%                                 N(a)*quadw(j)*quadw(k)*J^((ndim-1)/ndim);
                        end
                    end
%                 end
            end
        end
    end
    summ
end