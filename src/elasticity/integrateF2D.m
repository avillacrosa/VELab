%--------------------------------------------------------------------------
% Obtain the integral of the interpolation of the surface traction force
% for the line element enclosing the area element. Only 2D
%--------------------------------------------------------------------------
function tint = integrateF2D(Geo, Set)
    % Converts given tensions per area and per element to global 
    % nodal tension forces. 
    tint = zeros(size(Geo.f));
    ndim = Geo.dim;
    quadx = Set.quadx;
    quadw = Set.quadw;
    n = Geo.n;
    for e = 1:Geo.n_elem
        A = 2*(n(e,:)-1)+1;
        B = 2*(n(e,:)-1)+2;
        ide = reshape([A;B], size(A,1), []);
        te = Geo.f(ide);
        xe = Geo.x(n(e,:),:);
        for j = 1:Set.n_quad
            bot   = [quadx(j), -1];
            top   = [quadx(j), +1];
            left  = [-1, quadx(j)];
            right = [+1, quadx(j)];

            points = [bot; top; left; right];

            for face_i = 1:size(points,1)
                z = points(face_i,:);
                [N, ~] = fshape(Geo.n_nodes_elem, z);
                [~, J] = getdNdx(xe, z, Geo.n_nodes_elem);
                for a = 1:Geo.n_nodes_elem
                    for d = 1:ndim
                        n_id  = 2*(n(e,a)-1)+d;
                        ne_id = 2*(a-1)+d;
                        tint(n_id,:) = tint(n_id,:) + ...
                            te(ne_id, :)*N(a)*quadw(j)*J^((ndim-1)/ndim);
                    end
                end        
            end
        end
    end
end