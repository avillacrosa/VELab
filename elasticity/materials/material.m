function D = material(type, P)
    if lower(type) == "venant"
        D = mvenant(P);
    end
end