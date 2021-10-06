function f = buildF(Geo)
    % Translate load input format to load vector
    f = zeros(Geo.dim*Geo.n_nodes,1);
    if ~isempty(Geo.f)
        for i = 1:size(Geo.f,1)
            f(Geo.dim*(Geo.f(:,1)-1) + Geo.f(:,2)) = Geo.f(:,3);
        end
    end
end