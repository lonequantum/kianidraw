import re

def convert_xcf_to_pngs(infile, outfiles_dir):
	img = pdb.gimp_file_load(infile, infile)

	for layer in img.layers:
		if re.match(r"^" + item_name_pattern + "$", layer.name):
			outfile = outfiles_dir + "/" + layer.name + ".png"
			print(layer.name)
			pdb.gimp_file_save(img, layer, outfile, outfile)
		else:
			print("warning: \"" + layer.name + "\": bad element name -> ignored")

	pdb.gimp_image_delete(img)
