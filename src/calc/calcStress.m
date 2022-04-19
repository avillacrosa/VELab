function stress_t = calcStress(strain_k, k, stress_t, Geo, Mat, Set)
    if strcmpi(Mat.rheo, 'kelvin')
        stress_t = calcStressKV(strain_k, k, stress_t, Geo, Mat, Set);
    elseif strcmpi(Mat.rheo, 'maxwell')
		stress_t = calcStressMX(strain_k, k, stress_t, Geo, Mat, Set);
	elseif strcmpi(Mat.rheo, 'fmaxwell')
		stress_t = calcStressFMX(strain_k, k, stress_t, Geo, Mat, Set);
    end
end