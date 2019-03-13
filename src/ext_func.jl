

include("img_load.jl")
include("opt_bild.jl")


function primal_dual_opt_falt(inp_str,alpha,r,s;iter=10000,sigma=-1.0,tau=-1.0)

	a = load_img(inp_str)
	b = perf_bild_schaerfer(a,alpha,r,s,kreis_k, it=iter,sigma=sigma,tau=tau)
	return map(clamp01nan, b)
end

function slow_primal_dual_opt_falt(inp_str,alpha,r,s;it=10000)

	a = load_img(inp_str)
	b = bild_schaerfer(a,alpha,r,s,kreis_k,it)
	return map(clamp01nan, b)
end
