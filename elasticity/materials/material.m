function D = material(type, x, X, z, P)
    if lower(type) == "venant"
        D = mvenant(P);
    elseif lower(type) == "neohookean"
        D = mneohook(x, X, z, P);
    end
   
end