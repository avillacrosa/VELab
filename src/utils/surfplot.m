function surfplot(x, y, v, lay, Geo)
    figure;
    [~, z_idx] = ext_z(lay, Geo);
    xn = reshape(x(z_idx,:), [Geo.ns(1), Geo.ns(2)]);
    yn = reshape(y(z_idx,:), [Geo.ns(1), Geo.ns(2)]);
    vn = vecnorm(v(z_idx,:),2,2);
    vn = reshape(vn, [Geo.ns(1), Geo.ns(2)]);
    surf(xn, yn, vn);
    xlabel("x");
    ylabel("y");
    title(sprintf("u on (z_{max}-%d)", lay))
    view(2);
    colormap(redblue());
    colorbar;
end