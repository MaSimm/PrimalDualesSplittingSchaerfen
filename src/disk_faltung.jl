

function k(p,q,r,s)

	#if p^2/r^2 + q^2/s^2 <= 1
	#	return 1
	#else
	#	return 0
	#end
	return 1

	end

function disk_falt(u::Array{Float64,2}, r::Int, s::Int)
	n_d = size(u,1)
	m_d = size(u,2)
	h = 1/((2*r+1)*(2*s+1))
	A = zeros((n_d-2*r, m_d-2*s))

	for i = 1:n_d-2*r
		for j = 1:m_d-2*s
			a = 0

			for n = i-r:i+r
			for m = j-s:j+s
				a = a + u[n+r, m+s]*k(i-n,j-m,r,s)
			end
			end
			a = h*a
			A[i,j] = a

		end
	end
	
	return A
	end

function disk_falt_adj(w::Array{Float64,2}, r::Int, s::Int)
	n_a = size(w,1)
	m_a = size(w,2)
	h = 1/((2*r+1)* (2*s+1))
	A = zeros((n_a + 2*r, m_a + 2*s))
	
	for i = 1:n_a+2*r
	for j = 1:m_a+2*s
		a = 0
		for n = max(1,i-2*r):min(i, n_a)
		for m = max(1,j-2*s):min(j, m_a)
			a = a + w[n, m]*k(n-i+r,m-j+s,r,s)			
		end
		end
		a = h*a
		A[i,j] = a
	end
	end

	return A
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

function teste_adj_faltung(n_wert,m_wertr_wert,s_wert)
	f = 0
	for r=1:15
		println("r: ",r)
		for s=5:10
			for n=70:80
				for m=75:85
				u = rand(Float64,(n,m))
				w = rand(Float64,(n-2*r,m-2*s))
				res1 = dual_paarung(w,  disk_falt(u,r,s))
				res2 = dual_paarung(disk_falt_adj(w,r,s),u)
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
