function sigma = stress(type, Fd, P)
    if lower(type) == "venant"
        sigma = svenant(Fd, P);
    elseif lower(type) == "neohookean"
        sigma = sneohook(Fd, P);
    end
end