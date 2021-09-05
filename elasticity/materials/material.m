function D = material(type, P)
    if lower(type) == "venant"
        D = venant(P);
    end
end