function writeVecTop(vec, Geo, fname)
    [~, top_idx] = ext_z(0, Geo);
    ftfm  = fopen(fname,'w+');
    x  = vec_to_tfmvec(Geo.X(top_idx, 1), Geo);
    y  = vec_to_tfmvec(Geo.X(top_idx, 2), Geo);
    vecx = vec_to_tfmvec(vec(top_idx, 1), Geo);
    vecy = vec_to_tfmvec(vec(top_idx, 2), Geo);
    fprintf(ftfm,'%d %d %d %d \n', [x'; y'; vecx'; vecy']);
    fclose(ftfm);
end