function sigma = stress(Fd, e, Material)
    if strcmpi(Material.type, 'hookean')
        sigma = shook(Fd, Material.P(1), Material.P(2));
    elseif strcmpi(Material.type, 'neohookean')
        sigma = sneohook(Fd, Material.P(1), Material.P(2));
    end
end