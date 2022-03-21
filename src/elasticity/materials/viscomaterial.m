function sigma = viscomaterial(x_t, X, stress_t, z, Mat, Set)
    dim = size(X, 2);
    Fs = zeros(dim,dim,Mat.p);
    for i = 1:Mat.p
        Fs(:,:,i) = deformF(x_t(:,:,i), X, z, size(X,1));
    end
    if strcmpi(Mat.rheo, 'kelvin')
        sigma = hookean(Fs(:,:,1), Mat, dim) + newton(Fs(:,:,1), Fs(:,:,2), Mat, Set);
    elseif strcmpi(Mat.rheo, 'maxwell')
        D = [   1     Mat.nu  Mat.nu       0          0         0
             Mat.nu      1    Mat.nu       0          0         0
             Mat.nu   Mat.nu     1         0          0         0
                0        0       0    (1-Mat.nu)/2    0         0
                0        0       0         0    (1-Mat.nu)/2    0
                0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
        sigma = hookean(Fs(:,:,1), Mat, dim)-hookean(Fs(:,:,2), Mat, dim) + ...
                ref_mat((eye(size(D))-D*Set.dt)*stress_t(:,:,1)'/Mat.visco);
    end
end