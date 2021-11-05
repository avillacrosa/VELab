function u = readUTFM(file)
    if endsWith(file, '.mat')
        ustruct = load(file);
        ts = size(ustruct.ux,3);
        nx = size(ustruct.ux,1);
        ny = size(ustruct.ux,2);
        u = zeros(nx*ny,2, ts);
        for ti = 1:ts
            uxt = vec_nvec(ustruct.ux(:,:,ti));
            uyt = vec_nvec(ustruct.uy(:,:,ti));
            ut = [uxt, uyt];
            u(:,:,ti) = ut;
        end
    end
end