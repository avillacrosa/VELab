function D = material(x, X, e, z, Material)
%     Material.E, e
    if strcmp(Material.type, 'hookean')
        D = mhook(Material.E(e), Material.nu(e));
    elseif strcmp(Material.type, 'neohookean')
        D = mneohook(x, X, z, Material.lambda(e), Material.mu(e));
    end
   
end