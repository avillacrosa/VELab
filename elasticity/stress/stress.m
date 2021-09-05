function sigma = stress(type, c, strain)
    if lower(type) == "venant"
        sigma = venant(c, strain)
    end
end