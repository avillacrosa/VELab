function u = readUTFM(file)
    if endsWith(file, '.mat')
        ustruct = load(file);
        ux       = vec_nvec(ustruct.ux);
        uy       = vec_nvec(ustruct.uy);
    end
    u = [ux, uy];
end