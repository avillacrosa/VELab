function sigma = stress(type, c, strain)
    if lower(type) == "venant"
        sigma = svenant(c, strain);
    end
end