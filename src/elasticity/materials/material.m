function [sigma, c] = material(x, X, z, Mat)
    Fd = deformF(x, X, z, size(x,1));
    dim = size(Fd, 1);
    if strcmpi(Mat.type, 'hookean')
        sigma = hookean(Fd, Mat, dim);
    elseif strcmpi(Mat.type, 'neohookean')
        sigma = neohookean(Fd, Mat, dim);
    elseif strcmpi(Mat.type, 'venant')
        sigma = venant(Fd, Mat, dim);
    end
end