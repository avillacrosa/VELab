%--------------------------------------------------------------------------
% Obtain the integral of the interpolation of the surface traction force
% for the area element enclosing the volume element. Only 3D
%--------------------------------------------------------------------------
function tint = integrateF3D(Geo, Set)
    % Converts given tensions per area and per element to global 
    % nodal tension forces. 
    tint = zeros(size(Geo.f));
    ndim = Geo.dim;
    quadx = Set.quadx;
    quadw = Set.quadw;
    n = Geo.n;
    for e = 1:Geo.n_elem
        A = Geo.dim*(n(e,:)-1)+1;
        B = Geo.dim*(n(e,:)-1)+2;
        C = Geo.dim*(n(e,:)-1)+3;
        ide = reshape([A;B;C], size(A,1), []);
        
        te = Geo.f(ide);
        xe = Geo.x(n(e,:),:);
        for j = 1:Set.n_quad
            for k = 1:Set.n_quad

                front = [+1, quadx(k), quadx(j)]; %x
                back  = [-1, quadx(k), quadx(j)];
                right = [quadx(k), +1, quadx(j)];
                left  = [quadx(k), -1, quadx(j)]; %x
                top   = [quadx(k), quadx(j), +1];
                bot   = [quadx(k), quadx(j), -1]; %x

                points = [front; back; right; left; top; bot];

                for face_i = 1:size(points,1)
                    z = points(face_i,:);
                    [N, ~] = fshape(Geo.n_nodes_elem, z);
                    [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
                    for a = 1:Geo.n_nodes_elem
                        for d = 1:ndim
                            n_id  = Geo.dim*(n(e,a)-1)+d;
                            ne_id = Geo.dim*(a-1)+d;
                            tint(n_id,:) = tint(n_id,:) + te(ne_id, :)*...
                                N(a)*quadw(j)*quadw(k)*J^((ndim-1)/ndim);
                        end
                    end
                end
            end
        end
    end
end