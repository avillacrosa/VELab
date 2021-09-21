function D = material(x, X, e, z, Mat)
    dim = size(x,2);
    if strcmpi(Mat.type, 'hookean')
        D = mhook(Mat.P(1), Mat.P(2), dim);
    elseif strcmpi(Mat.type, 'neohookean')
        D = mneohook(x, X, z, Mat.P(1), Mat.P(2));
    end
end