function Mat = readMat(Mat, mat_file)

    mat_data = regexp(fileread(mat_file),'\n','split');

    search_keyw = ["MATERIAL TYPE", "MATERIAL PARAMETERS", "VISCOSITY",...
                   "RHEOLOGY"];
    [used_keyw, k_rs] = usedKeyw(mat_data, search_keyw);

    for k = 1:size(used_keyw,2)
       k_r = k_rs(k,:);
       switch used_keyw(k)
           case "MATERIAL TYPE"
              val = mat_data(k_r(1)+1);
              Mat.type  = val{1};
           case "MATERIAL PARAMETERS"
              Mat.P  = read_matP(mat_data, k_r);
           case "VISCOSITY"
              val = mat_data(k_r(1)+1);
              Mat.visco = str2num(val{1});
           case "RHEOLOGY"
              val = mat_data(k_r(1)+1);
              Mat.rheo = val{1};
       end
    end
end
