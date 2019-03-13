

include("disk_faltung.jl")
include("disk_divergenz.jl")
include("disk_gradient.jl")

function bild_schaerfer(bild::Array{Float64,2}, alpha::Float64, r::Int, s::Int, k::Function, it=10000::Int)
	
	n_a = size(bild,1)
	m_a = size(bild,2)

	n = n_a + 2*r
	m = m_a + 2*s

	xk = embed_image(bild,r,s)
	y1k = zeros((n_a,m_a))
	y2k = zeros((n,m,2))

	tau = 1/(sqrt(n)*sqrt(m)*sqrt(8)+1)
	sigma = (1/(sqrt(n)*sqrt(m)*sqrt(8)+1))
	funkwert = 100

	print("<")

	try

		for i = 1:it

			if i % 10 == 0
				print("-")
			end

			xk2 = xk - tau*(disk_falt_adj(y1k,r,s,k) - disk_div(y2k))
			xk3 = 2*xk2 - xk
			
			y1k2 = (1/(1+sigma))*(y1k + sigma*disk_falt(xk3,r,s,k) - sigma*bild)
			y2k2 = alpha*(y2k + sigma*disk_grad(xk3))/max(alpha, m_norm2_3(y2k + sigma*disk_grad(xk3)))

			#Wert:
			#funkwert = 0.5*m_norm2_2(disk_falt(xk2,r,s,k) - bild)^2 + alpha*total_var(xk2)
			#println("x Differenz: ", m_norm2_2(xk2 - xk), ", y Differenz: ", m_norm2_2(y1k2 - y1k),", z Differenz: ", m_norm2_3(y2k2 - y2k))
			#println("Funktionswert: ", funkwert)
			
			xk = xk3
			y1k = y1k2
			y2k = y2k2
		end

		#println("Schritt: ", i, " liefert das Resultat")
		print(">\n")
		
	
		return xk
	catch err
		if isa(err, InterruptException)
			return xk
		else
			throw(err)
		end
	end
	
end

function perf_bild_schaerfer(bild::Array{Float64,2}, alpha::Float64, r::Int, s::Int, k::Function; it=10000, sigma=-1.0, tau=-1.0)
	
	n_a = size(bild,1)
	m_a = size(bild,2)

	n = n_a + 2*r
	m = m_a + 2*s

	xk = embed_image(bild,r,s)
	y1k = zeros((n_a,m_a))
	y2k = zeros((n,m,2))

	div_y2k = zeros((n,m))
	grad_xk3 = zeros((n,m,2))

	falt_adj_y1k = zeros((n,m))

	falt_xk3 = zeros((n_a, m_a))

	sum_y2k2 = zeros((n,m,2))

	xk2 = zeros((n,m))
	xk3 = zeros((n,m))

	y1k2 = zeros((n_a,m_a))

	y2k2 = zeros((n,m,2))

	if sigma < 0 || sigma*tau >= 1/(n*m*8)
		sigma = (1/(sqrt(n)*sqrt(m)*sqrt(8)+1))
	end
	if tau < 0 || sigma*tau >= 1/(n*m*8)
		tau = 1/(sqrt(n)*sqrt(m)*sqrt(8)+1)
	end
	

	#tau = 1/(sqrt(n)*sqrt(m)*sqrt(8)+1)
	#sigma = (1/(sqrt(n)*sqrt(m)*sqrt(8)+1))

	ret_d_falt_kerns = 1/check_number(k,r,s)

	print("<")

	for i = 1:it
		if i % 10 == 0
			print("-")
		end
		perf_disk_div(y2k, div_y2k)
		perf_disk_falt_adj(y1k,r,s,k, ret_d_falt_kerns,falt_adj_y1k)
		@. @inbounds xk2 = xk - tau*(falt_adj_y1k - div_y2k)
		@. @inbounds xk3 = 2.0 *xk2 - xk

		perf_disk_falt(xk3,r,s,k, ret_d_falt_kerns,falt_xk3)
		@. @inbounds y1k2 = (1.0 /(1.0 +sigma))*(y1k + sigma*falt_xk3 - sigma*bild)
			
		perf_disk_grad(xk3, grad_xk3)
		@. @inbounds sum_y2k2 = y2k + sigma*grad_xk3
		#@. @inbounds y2k2 = alpha*(sum_y2k2)/max(alpha, m_norm2_3(sum_y2k2))
		prox_g(sum_y2k2,alpha,y2k2)

		@inbounds xk = xk2
		@inbounds y1k = y1k2
		@inbounds y2k = y2k2
	end

	print(">\n")
			
	return xk
end


function embed_image(inp::Array{Float64,2},r::Int, s::Int)
	n1 = size(inp,1)
	m1 = size(inp,2)

	n = n1 + 2*r
	m = m1 + 2*s

	emb_out = zeros((n,m))

	for i = 1:n1
		for j = 1:m1
			emb_out[i+r,j+s] = inp[i,j]
		end
	end

	return emb_out
end

function prox_g(inp::Array{Float64,3}, alpha, val::Array{Float64,3})
	n = size(inp,1)
	m = size(inp,2)
	#o = size(inp,3)

	for i = 1:n
		for j = 1:m
			#for k = 1:o
				@inbounds val[i,j,1] = alpha*inp[i,j,1]/max(alpha, sqrt(inp[i,j,1]^2 + inp[i,j,2]^2))

				@inbounds val[i,j,2] = alpha*inp[i,j,2]/max(alpha, sqrt(inp[i,j,1]^2 + inp[i,j,2]^2))
			#end
		end
	end
	
	
end


function m_norm2_1(x::Array{Float64,1})
	n = size(x,1)
	h = 1/sqrt(n)
	
	a = 0
	for i = 1:n
		a = a + x[i]^2
	end
	#a = h * sqrt(a)
	a = sqrt(h*a)
	return a
end

function m_norm2_2(x::Array{Float64,2})
	n = size(x,1)
	m = size(x,2)
	h = 1/sqrt(n*m)
	
	a = 0
	for i = 1:n
		for j = 1:m
			a = a + x[i, j]^2
		end
	end
	a = h * sqrt(a)
	#a = sqrt(h*a)
	return a
end

function m_norm2_3(x::Array{Float64,3})
	n = size(x,1)
	m = size(x,2)
	q = size(x,3)
	h = 1/sqrt(n*m*q)
	
	a = 0
	for i = 1:n
		for j = 1:m
			for k = 1:q
				a = a + x[i, j, k]^2
			end
		end
	end
	a = h * sqrt(a)
	#a = sqrt(h*a)
	return a
end

function total_var(u::Array{Float64,2})
	n = size(u,1)
	m  = size(u,2)
	h = 1/sqrt(n*m)
	grad_u = disk_grad(u)

	a = 0
	for i = 1:n
		for j = 1:m
			a = a + m_norm2_1(grad_u[i, j,:])
		end
	end
	a = h^2 * sqrt(a)
	return a

end

