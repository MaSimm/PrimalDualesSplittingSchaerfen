

using FileIO
using Images

include("opt_bild.jl")
include("img_load.jl")

bild = load_img("../exp_bilder/test_bild1.JPG")

bild_falt = disk_falt(bild, 3,3, kreis_k)

output = bild_schaerfer(bild_falt, 1.0,3,3,kreis_k)

save("../exp_bilder/output_kreis.png", output)