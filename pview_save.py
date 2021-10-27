fname               = "/home/doctorantlacan/VELab/out/out_t01_tfm_inv.vtk"
session_name        = "inv_lin"
observables = ['Displacements', 'Reactions', 'Stress', 'Tractions']
obs_names   = ['u','r','sts','t'];

reader                = OpenDataFile(fname)
disp                  = Show(reader)
view                  = GetActiveView()

pos_dir = [13.5, -12.5]
pos_name = ['top', 'bot']

for p in range(len(pos_dir)):

	view.CameraFocalPoint = [12, 12, 0]
	view.CameraViewAngle  = 90
	view.CameraPosition   = [12, 12, pos_dir[p]]
	view.ViewSize         = [800, 800]
	for i in range(len(observables)):
		obs = observables[i]
		disp.ColorArrayName   = obs
		ColorBy(disp, ('POINTS', obs))
		disp.RescaleTransferFunctionToDataRange(True)
		fout                  = "/home/doctorantlacan/VELab/out/"+ obs_names[i] +"_"+ session_name +"_"+pos_name[p]+".png"
		SaveScreenshot(fout, view)
