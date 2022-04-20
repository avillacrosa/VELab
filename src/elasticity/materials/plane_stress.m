function D = plane_stress(dim, Mat)
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
end