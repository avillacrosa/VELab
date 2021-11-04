function Mf = areaMass(x, Geo, Set)
    M = zeros(Geo.n_nodes);
    quadw = [-1 1]/sqrt(3);
%     quadw = [-1 1];
    % TODO iterator as a variable?
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        xe  = x(nea(2:end),nea(1));
        for gpa = 1:2
            z = quadw(gpa);
            [N, ~] = fshape(2, z);
            [~, J] = getdNdx(xe, z, 2);
            for a = 1:2
                for b = 1:2
                    neaa = nea(a+1);
                    neab = nea(b+1);
                    M(neaa, neab) = M(neaa, neab) + ... 
                                        N(a,:)*N(b,:)*Set.gausscW(gpa)*J;

%                     M(neaa, neab) = M(neaa, neab) + Set.gausscW(gpa)*J;
                end
            end
        end
    end
    % Lumping
%     Mf = zeros(size(M));
%     for d_i = 1:size(M,1)
%         Mf(d_i, d_i) = sum(M(d_i,:));
%     end
    Mf = M;
end