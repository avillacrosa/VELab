function c = material_c(x, X, z, Mat)
    Fd = deformF(x, X, z, size(x,1));
    dim = size(Fd, 1);
    if strcmpi(Mat.type, 'hookean')
        c = hookean_c(Fd, Mat, dim);
    elseif strcmpi(Mat.type, 'neohookean')
        c = neohookean_c(Fd, Mat, dim);
    elseif strcmpi(Mat.type, 'venant')
        c = venant_c(Fd, Mat, dim);
    end
end