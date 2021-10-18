function u = readUTFM(file)
    if endsWith(file, '.mat')
        ustruct = load(file);
        ux       = vec_nvec(ustruct.ux);
        uy       = vec_nvec(ustruct.uy);
    end
    % TODO FIXIT subdomain, otherwise to large to compute
    ux = ux(1:36);
    uy = uy(1:36);
    u = [ux, uy];
    u = 2e7*u;
end