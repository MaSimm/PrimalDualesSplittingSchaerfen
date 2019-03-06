
using Base.Threads

function konst_k(h,p,q,r,s)

	return h
	#return 1

end

function kreis_k(h,p,q,r,s)

	if p^2/r^2 + q^2/s^2 <= 1
		return h
	#	return 1
	else
		return 0
	end

end




function disk_falt(u::Array{Float64,2}, r::Int, s::Int, k::Function)
	n_d = size(u,1)
	m_d = size(u,2)
	h = 1/((2*r+1)*(2*s+1))
	A = zeros((n_d-2*r, m_d-2*s))

	for i = 1:n_d-2*r
		for j = 1:m_d-2*s
			a = 0

			for n = i-r:i+r
			for m = j-s:j+s
				a = a + u[n+r, m+s]*k(h,i-n,j-m,r,s)
			end
			end
			#a = h*a
			A[i,j] = a

		end
	end
	
	return A
end

function disk_falt_adj(w::Array{Float64,2}, r::Int, s::Int, k::Function)
	n_a = size(w,1)
	m_a = size(w,2)
	h = 1/((2*r+1)* (2*s+1))
	A = zeros((n_a + 2*r, m_a + 2*s))
	
	for i = 1:n_a+2*r
	for j = 1:m_a+2*s
		a = 0
		for n = max(1,i-2*r):min(i, n_a)
		for m = max(1,j-2*s):min(j, m_a)
			a = a + w[n, m]*k(h,n-i+r,m-j+s,r,s)			
		end
		end
		#a = h*a
		A[i,j] = a
	end
	end

	return A
end

function perf_disk_falt(u::Array{Float64,2}, r::Int, s::Int, k::Function, A::Array{Float64,2})
	n_d = size(u,1)
	m_d = size(u,2)
	h = 1/((2*r+1)*(2*s+1))
	#B = zeros((2*r+1,2*s+1))

	@threads for i = 1:n_d-2*r
		for j = 1:m_d-2*s
			a = 0

			for n = i-r:i+r
			for m = j-s:j+s
				@inbounds a = a + u[n+r, m+s]*k(h,i-n,j-m,r,s)
			end
			end
			@inbounds A[i,j] = a

		#	for a = 0:((2*r+1)*(2*s+1)-1)
		#		m = (a % (2*s+1)) +1
		#		n = (a ÷ (2*s+1)) +1
		#		@inbounds B[n, m] = u[n+i-1, m+j-1]*k(h,n-r-1,m-s-1,r,s)
		#	end

		#	@inbounds A[i,j] = sum(B)

		end
	end
	
end


function perf_disk_falt_adj(w::Array{Float64,2}, r::Int, s::Int, k::Function, A::Array{Float64,2})
	n_a = size(w,1)
	m_a = size(w,2)
	h = 1/((2*r+1)* (2*s+1))
	
	@threads for i = 1:n_a+2*r
	for j = 1:m_a+2*s
		a = 0
		for n = max(1,i-2*r):min(i, n_a)
		for m = max(1,j-2*s):min(j, m_a)
			@inbounds a = a + w[n, m]*k(h,n-i+r,m-j+s,r,s)			
		end
		end
		@inbounds A[i,j] = a
	end
	end

end


function dual_paarung(u::Array{Float64,2}, w::Array{Float64,2})
	n1 = size(u,1)
	n2 = size(u,2)
	a = 0

	for i=1:n1
		for j=1:n2
			a = a + u[i, j]*w[i, j]
		end
	end

	return a

end

function teste_adj_faltung(n_wert,m_wert,r_wert,s_wert, k)
	f = 0
	for r=1:r_wert
		println("r: ",r)
		for s=1:s_wert
			for n = (n_wert-10):n_wert
				for m = (m_wert-10):m_wert
				u = rand(Float64,(n,m))
				w = rand(Float64,(n-2*r,m-2*s))
				res1 = dual_paarung(w,  disk_falt(u,r,s,k))
				res2 = dual_paarung(disk_falt_adj(w,r,s,k),u)
				if abs(res1-res2) > 1e-4
					println("!Fehler: ", res1, ", ", res2)
					f = f+1
				end
				end
			end
		end
	end
	return f
end
