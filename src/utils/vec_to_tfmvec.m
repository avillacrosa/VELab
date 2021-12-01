function tfmvec = vec_to_tfmvec(vec, Geo)
    vec_grid = vec_to_grid(vec, Geo);
    vec_grid = vec_grid';
    tfmvec   = grid_to_vec(vec_grid);
end