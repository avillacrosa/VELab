%--------------------------------------------------------------------------
% Write a 3D VTK with all elements, and the nodal displacements, stress
% tensors and strain tensors
%--------------------------------------------------------------------------
function writeVTK(x, u, Geo, Result, Mat, fname)
    fileH = fopen(fname, 'w+');
    
    header       = "# vtk DataFile Version 2.0\n";
    header       = header + "Cube example\n";
    header       = header + "ASCII\n";
    header       = header + "DATASET UNSTRUCTURED_GRID\n";

    geo_str      = writeGeo(x, Geo);
    u_str        = writeU(u);
    
    if isfield(Result,'F')
        f_str        = writeT(Result.F, 'Loads');
    else
        f_str        = "";
    end
    if isfield(Result,'T')
        t_str        = writeT(Result.T, 'Reactions');
    else
        t_str        = "";
    end
    
    stress_str   = writeStress(x, Geo, Mat);
    strain_str   = writeStrain(x, Geo);
    
    fprintf(fileH, header);
    fprintf(fileH, geo_str);
    fprintf(fileH, u_str);
    fprintf(fileH, f_str);
    fprintf(fileH, t_str);
    fprintf(fileH, stress_str);
    fprintf(fileH, strain_str);

    fclose(fileH);
end



