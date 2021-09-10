function sigma = stress(type, Fd, P)
    if strcmp(type, 'hookean')
        sigma = shook(Fd, P);
    elseif strcmp(type, 'neohookean')
        sigma = sneohook(Fd, P);
    end
end