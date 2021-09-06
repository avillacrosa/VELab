function sigma = svenant(c, strain)
    vec_strain = vectorize(strain);
    vec_sigma = c*vec_strain;
    % TODO
    sigma = [vec_sigma(1) vec_sigma(3)
             vec_sigma(3) vec_sigma(2)];
end