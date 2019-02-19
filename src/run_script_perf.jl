

using FileIO
using Images

include("opt_bild.jl")
include("img_load.jl")

file = "exp_bilder/test_bild1.JPG"

output = "output.png"

r = 0

s = 0

alpha = 1.0

iterationen = 10000




for i in 1:size(ARGS,1)

	if ARGS[i] == "--help"

		println("Die Kommandozeilen Argumente sollten die Form:\njulia run_script.jl [OPTION1] [OPTIONSARGUMENT1] [OPTION2] [OPTIONSARGUMENT2] ...")
		println("OPTIONEN:\n --input\n --vertradius\n --horradius\n --iteration")
		println("haben.")

	elseif ARGS[i] == "--input" || ARGS[i] == "--i"

		global file
		
		file = ARGS[i+1]

		i = i+2
		continue

	elseif ARGS[i] == "--output" || ARGS[i] == "--o"
		
		output = ARGS[i+1]

		i = i+2
		continue

	elseif ARGS[i] == "--alpha" || ARGS[i] == "--a"

		global alpha
		
		alpha = parse(Float64,ARGS[i+1])

		i = i+2
		continue

	elseif ARGS[i] == "--vr" || ARGS[i] == "--vertradius" || ARGS[i] == "--vradius"

		global r

		r = parse(Int,ARGS[i+1])

		i = i+2
		continue

	elseif ARGS[i] == "--hr" || ARGS[i] == "--horradius" || ARGS[i] == "--hradius"

		global s

		s = parse(Int,ARGS[i+1])

		i = i+2
		continue

	elseif ARGS[i] == "--it" || ARGS[i] == "--iterations" || ARGS[i] == "--iteration" || ARGS[i] == "--iter"

		global iterationen

		iterationen = parse(Int,ARGS[i+1])

		i = i+2
		continue

	else
		#println("Die Kommandozeilen Argumente sollten die Form:\njulia run_script.jl [OPTION1] [OPTIONSARGUMENT1] [OPTION2] [OPTIONSARGUMENT2] ...")
		#println("OPTIONEN:\n --input\n --vertradius\n --horradius\n --iteration")
		#println("haben.")
	end


end

println("input: ", file, ", alpha: ", alpha, ", r: ", r, ", s: ", s, ", it: ", iterationen)

a = load_img(file)

b = perf_bild_schaerfer(a, alpha, r, s, kreis_k, iterationen)

c = map(clamp01nan, b)

save(output, c)
