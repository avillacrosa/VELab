function Set = initializeOutFolder(Set)
	Set.DirOutput=fullfile(pwd, Set.output_folder);
    Set.VTKDirOutput=fullfile(Set.DirOutput, 'VTKOut');
    Set.TFMDirDisp=fullfile(Set.DirOutput, 'TFM','Displacements');
    Set.TFMDirTrac=fullfile(Set.DirOutput, 'TFM','Tractions');
    if exist(Set.DirOutput, 'dir')
% 		dlt=input('Remove everything from output directory?[y]');
		dlt='y';
		if isempty(dlt) || dlt == 'y'
			try
				rmdir(Set.DirOutput, 's')
				mkdir(Set.DirOutput)
			catch
				fprintf(" %s was not deleted." + ...
						" Check you have write permissions\n", Set.DirOutput);
			end
		end
	else
		mkdir(Set.DirOutput)
    end

    mkdir(Set.VTKDirOutput)
    mkdir(Set.TFMDirDisp)
    mkdir(Set.TFMDirTrac)
end