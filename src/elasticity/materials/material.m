function D = material(x, X, e, z, Mat)
    if strcmpi(Mat.type, 'hookean')
        D = mhook(Mat.P(1), Mat.P(2));
    elseif strcmpi(Mat.type, 'neohookean')
        D = mneohook(x, X, z, Mat.P(1), Mat.P(2));
    end
end