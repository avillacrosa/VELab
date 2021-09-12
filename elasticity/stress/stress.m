function sigma = stress(Fd, e, Material)
    if strcmp(Material.type, 'hookean')
        sigma = shook(Fd, Material.E(e), Material.nu(e));
    elseif strcmp(Material.type, 'neohookean')
        sigma = sneohook(Fd, Material.lambda(e), Material.mu(e));
    end
end