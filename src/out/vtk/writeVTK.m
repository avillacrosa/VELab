%--------------------------------------------------------------------------
% Write a 3D VTK with all elements, and the nodal displacements, stress
% tensors and strain tensors
%--------------------------------------------------------------------------
function writeVTK(Geo, x, u, F, T, t, stress, fname)
    fileH = fopen(fname, 'w+');
    
    header       = "# vtk DataFile Version 2.0\n";
    header       = header + "Cube example\n";
    header       = header + "ASCII\n";
    header       = header + "DATASET UNSTRUCTURED_GRID\n";
    
    geo_str      = writeGeo(x, Geo);
    u_str        = writeVec(u, 'Displacements');
    F_str        = writeVec(F, 'Loads');
    T_str        = writeVec(T, 'Reactions');
    t_str        = writeVec(t, 'Tractions');
    stress_str   = writeStressRec(stress);
    
    fprintf(fileH, header);
    fprintf(fileH, geo_str);
    fprintf(fileH, u_str);
    fprintf(fileH, F_str);
    fprintf(fileH, T_str);
    fprintf(fileH, t_str);
    fprintf(fileH, stress_str);

    fclose(fileH);
end



