function plotStress3D(Geo, Mat, Set, Result)
	figure
	hold on
	plot(Result.time, reshape(max(Result.stress(:,1,:),[],1), size(Result.time)), 'o');
	plot(Result.time, reshape(max(Result.stress(:,2,:),[],1), size(Result.time)), 'o');
	plot(Result.time, reshape(max(Result.stress(:,3,:),[],1), size(Result.time)), 'o');
	lgdStr = ["\sigma_{xx}","\sigma_{yy}","\sigma_{zz}"];
	ylabel(char(949), "FontSize", 14);
	xlabel("t(s)", "FontSize", 12)
	if strcmpi(Mat.rheo, 'maxwell')
		stress_1d = max(abs(Result.strain(:,1,1)))*Mat.E*exp(-Mat.E*Result.time/Mat.visco);
		lgdStr(end+1) = "1D Solution";
		plot(Result.time, stress_1d);
	end
	lgd = legend(lgdStr);
	lgd.FontSize = 10;
	lgd.Location = 'northwest';
	figure
	hold on
	plot(Result.time, reshape(max(Result.stress(:,4,:),[],1), size(Result.time)), 'o');
	plot(Result.time, reshape(max(Result.stress(:,5,:),[],1), size(Result.time)), 'o');
	plot(Result.time, reshape(max(Result.stress(:,6,:),[],1), size(Result.time)), 'o');
	lgdStr = ["\sigma_{xy}","\sigma_{xz}","\sigma_{yz}"];
	ylabel(char(949), "FontSize", 14);
	xlabel("t(s)", "FontSize", 12)
	if Geo.w ~= 0
		strain_1d = max(abs(Result.strain(:,4,:)),[], "all")*abs(sin(Geo.w*Result.time));
		lgdStr(end+1) = "1D Solution";
		plot(Result.time, strain_1d);
	end
	lgd = legend(lgdStr);
	lgd.FontSize = 10;
	lgd.Location = 'northwest';
end