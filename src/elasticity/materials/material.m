function [sigma, c] = material(x, X, z, Mat)
    Fd = deformF(x, X, z, size(x,1));
    dim = size(Fd, 1);
    if strcmpi(Mat.type, 'hookean')
        [sigma, c] = hookean(Fd, Mat.P(1), Mat.P(2), dim);
    elseif strcmpi(Mat.type, 'neohookean')
        [sigma, c] = neohookean(Fd, Mat.P(1), Mat.P(2), dim);
    elseif strcmpi(Mat.type, 'venant')
        [sigma, c] = venant(Fd, Mat.P(1), Mat.P(2), dim);
    end
end