def convert_xcf_to_pngs(infile, outfiles_dir):
	img = pdb.gimp_file_load(infile, infile)
	for layer in img.layers:
		outfile = outfiles_dir + "/" + layer.name + ".png"
		print(layer.name)
		pdb.gimp_file_save(img, layer, outfile, outfile)
	pdb.gimp_image_delete(img)
