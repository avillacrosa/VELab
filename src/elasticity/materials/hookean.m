function sigma = hookean(Fd, Mat, dim)
    lin_str = (Fd'+Fd)/2-eye(size(Fd));
    % Ideally I would prefer computing c, then D, then sigma but that is
    % much more expensive because of looping...
    if dim == 2
        D = [   1     Mat.nu    0
             Mat.nu      1      0
                0        0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
    elseif dim == 3
        D = [   1     Mat.nu  Mat.nu       0          0         0
             Mat.nu      1    Mat.nu       0          0         0
             Mat.nu   Mat.nu     1         0          0         0
                0        0       0    (1-Mat.nu)/2    0         0
                0        0       0         0    (1-Mat.nu)/2    0
                0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
    end
    sigma = D*vec_mat(lin_str, 2);
    sigma = ref_mat(sigma);
end