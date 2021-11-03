function M = areaMass(x, Geo, Set)
    M = zeros(Geo.n_nodes);
    gpas = zeros(4,2,2);
    gpas(1,1,:) = [-1 -1];
    gpas(1,2,:) = [+1 -1];
    gpas(2,1,:) = [+1 -1];
    gpas(2,2,:) = [+1 +1];
    gpas(3,1,:) = [+1 +1];
    gpas(3,2,:) = [-1 +1];
    gpas(4,1,:) = [-1 +1];
    gpas(4,2,:) = [-1 -1];
    
    % TODO iterator as a variable?
    for ea = 1:size(Geo.na,1)
        nea = Geo.na(ea,:);
        xe = x(nea,:);
        % TODO remove hardcode
        for gpa = 1:2
            z = squeeze(gpas(ea,gpa,:));
            [~, J] = getdNdx(xe(1,:), z, 2);
            for a = 1:2
                for b = 1:2
                    M(nea(a), nea(b)) = M(nea(a), nea(b)) + ... 
                                        Set.gausscW(gpa)*J;
                end
            end
        end
    end
end