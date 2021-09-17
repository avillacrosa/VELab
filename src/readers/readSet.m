function Set = readSet(Set, set_file)

    set_data = regexp(fileread(set_file),'\n','split');
    
    search_keyw = ["SYSTEM TYPE", "NONLINEAR ITERATIONS", ...
                      "NONLINEAR TOLERANCE", "TIME INCREMENTS", ...
                      "TIMESTEP", "GAUSSIAN QUADRATURE", ...
                      "SAVE FREQUENCY", "EULER"]; 
                  
    [used_keyw, k_rs] = usedKeyw(set_data, search_keyw);
    
    for k = 1:size(used_keyw,2)
       k_r = k_rs(k,:);
       val_k = set_data(k_r(1)+1);
       val = val_k{1};
       switch used_keyw(k)
           case "SYSTEM TYPE"
              Set.type   = val;
           case "NONLINEAR ITERATIONS"
              Set.newton_its = str2num(val);
           case "NONLINEAR TOLERANCE"
              Set.newton_tol = str2num(val);
           case "TIME INCREMENTS"
              Set.time_incr  = str2num(val);
           case "TIMESTEP"
              Set.dt = str2num(val);
           case "GAUSSIAN QUADRATURE"
              Set.n_quad = str2num(val);
           case "SAVE FREQUENCY"
              Set.save = str2num(val);
           case "EULER"
              Set.euler_type = val;
       end
    end
end