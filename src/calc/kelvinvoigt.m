function stress_t = kelvinvoigt(strain_k, k, stress_t, Geo, Mat, Set)
    D = [   1     Mat.nu  Mat.nu       0          0         0
             Mat.nu      1    Mat.nu       0          0         0
             Mat.nu   Mat.nu     1         0          0         0
                0        0       0    (1-Mat.nu)/2    0         0
                0        0       0         0    (1-Mat.nu)/2    0
                0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
    stress_t = D*lin_str'+Mat.visco*(strain_k(:,:,2)'-strain_k(:,:,1)')/Set.dt;
    stress_t = stress_t';
end