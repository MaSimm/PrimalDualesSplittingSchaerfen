
#using FileIO
#using Images

function load_img(bildname)
	img = load(bildname)
	img2 = Gray.(img)
	img3 = float64.(img2)
	img4 = real(img3)
	return img4
end

#using FileIO
#img = load("myimage.png")
#..... Berechnung .....
# img2 = image(img_com)
#save("imagecopy.png", img2)
