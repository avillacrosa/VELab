function grid = vec_to_grid(vec, Geo)
    grid = reshape(vec,[Geo.ns(1), Geo.ns(2)]);
end