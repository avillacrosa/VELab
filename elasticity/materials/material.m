function D = material(type, x, X, z, P)
    if lower(type) == 'hookean'
        D = mhook(P);
    elseif lower(type) == 'neohookean'
        D = mneohook(x, X, z, P);
    end
   
end