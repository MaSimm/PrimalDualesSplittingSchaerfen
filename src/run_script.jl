

using FileIO
using Images

include("opt_bild.jl")
include("img_load.jl")

#bild = load_img("../exp_bilder/test_bild1.JPG")

#bild_falt = disk_falt(bild, 3,3, kreis_k)

#output = bild_schaerfer(bild_falt, 1.0,3,3,kreis_k)

#save("../exp_bilder/output_kreis.png", output)

file = "exp_bilder/test_bild1.JPG"

output = "output.png"

r = 0

s = 0

alpha = 1.0

iterationen = 10000




for i in 1:size(ARGS)

	if ARGS[i] == "--help"

		println("Die Kommandozeilen Argumente sollten die Form:\njulia run_script.jl [OPTION1] [OPTIONSARGUMENT1] [OPTION2] [OPTIONSARGUMENT2] ...")
		println("OPTIONEN:\n --input\n --vertradius\n --horradius\n --iteration")
		println("haben.")

	elseif ARGS[i] == "--input" || ARGS[i] == "--i"
		
		file = ARGS[i+1]

		i = i+2

	elseif ARGS[i] == "--output" || ARGS[i] == "--o"
		
		output = ARGS[i+1]

		i = i+2

	elseif ARGS[i] == "--alpha" || ARGS[i] == "--a"
		
		alpha = parse(Float64,ARGS[i+1])

		i = i+2

	elseif ARGS[i] == "--vr" || ARGS[i] == "--vertradius" || ARGS[i] == "--vradius"

		r = parse(Int,ARGS[i+1])

		i = i+2

	elseif ARGS[i] == "--hr" || ARGS[i] == "--horradius" || ARGS[i] == "--hradius"

		s = parse(Int,ARGS[i+1])

		i = i+1

	elseif ARGS[i] == "-it" || ARGS[i] == "--iterations" || ARGS[i] == "--iteration" || ARGS[i] == "--iter"

		iterationen = parse(Int,ARGS[i+1])

		i = i+1

	else
		println("Die Kommandozeilen Argumente sollten die Form:\njulia run_script.jl [OPTION1] [OPTIONSARGUMENT1] [OPTION2] [OPTIONSARGUMENT2] ...")
		println("OPTIONEN:\n --input\n --vertradius\n --horradius\n --iteration")
		println("haben.")
	end


end

a = load_img(file)

b = bild_schaerfer(a, alpha, r, s, kreis_k, it=iterationen)

save(output, b)
