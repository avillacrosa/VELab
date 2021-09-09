function sigma = stress(type, Fd, P)
    if lower(type) == 'hookean'
        sigma = shook(Fd, P);
    elseif lower(type) == 'neohookean'
        sigma = sneohook(Fd, P);
    end
end