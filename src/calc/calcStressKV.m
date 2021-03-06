function stress_t = calcStressKV(strain_k, k, stress_t, Geo, Mat, Set)
	if Geo.dim == 3
    D = [   1     Mat.nu  Mat.nu       0          0         0
             Mat.nu      1    Mat.nu       0          0         0
             Mat.nu   Mat.nu     1         0          0         0
                0        0       0    (1-Mat.nu)/2    0         0
                0        0       0         0    (1-Mat.nu)/2    0
                0        0       0         0          0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
	elseif Geo.dim == 2
          D = [   1     Mat.nu    0
             Mat.nu      1      0
                0        0    (1-Mat.nu)/2]*Mat.E/(1-Mat.nu^2);
	end
	if k == 0
		stress_t(:,:,1) = 0;
	else
		s = D*strain_k(:,:,k)'+Mat.visco*(strain_k(:,:,k+1)'-strain_k(:,:,k)')/Set.dt;
		stress_t(:,:,k) = s';
	end
end