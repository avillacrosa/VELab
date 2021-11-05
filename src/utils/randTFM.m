function t = randTFM(Geo, max_t)
    pad = 2;
%     if (Geo.ns(1)-pad) <= pad || (Geo.ns(2)-pad) <= pad
%         pad = 0;
%     end
    t = zeros(Geo.ns(1), Geo.ns(2), Geo.ns(3), 3);
    trand = rand(Geo.ns(1)-2*pad, Geo.ns(2)-2*pad, 2)*max_t;
    t((pad+1):(end-pad), (pad+1):(end-pad), Geo.ns(3),[1,2]) = trand;
    t = reshape(t, [Geo.n_nodes,3]);
    t = vec_nvec(t);
end