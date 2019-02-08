

include("disk_faltung.jl")
include("disk_divergenz.jl")
include("disk_gradient.jl")

function bild_schaerfer(bild, alpha, r, s)
	i=0

	n_a = size(bild,1)
	m_a = size(bild,2)

	n = n_a + 2*r
	m = m_a + 2*s

	xk = zeros((n,m))
	yk = zeros((n_a,m_a))
	zk = zeros((n,m,2))

	h = 1/(n*m)
	tau = 1/(n*m*sqrt(8)*2)
	sigma = 1/(n*m*sqrt(8)*2)

	while true
		i = i +1
		xk2 = xk - tau*(disk_falt_adj(yk,r,s) - disk_div(zk))
		xk3 = 2*xk2 - xk
		
		yk2 = 1/(1+sigma)*(yk + sigma*disk_falt(xk3,r,s) - sigma*bild)
		zk2 = alpha*(zk + sigma*disk_grad(xk2))/max(alpha, m_norm2_3(zk + sigma*disk_grad(xk2)))

		if m_norm2_2(xk2 - xk) < 1e-14 && m_norm2_2(yk2 - yk) < 1e-14 && m_norm2_3(zk2 - zk) <1e-14
			xk = xk2
			yk = yk2
			zk = zk2
			break
		end

		xk = xk2
		yk = yk2
		zk = zk2
	end

	println("Schritt: ", i, "liefert das Resultat")

	return xk
	
end

function m_norm2_2(x)
	n = size(x,1)
	m = size(x,2)
	h = 1/(n*m)
	
	a = 0
	for i = 1:n
		for j = 1:m
			a = a + x[i, j]^2
		end
	end
	a = h* sqrt(a)
	return a
end

function m_norm2_3(x)
	n = size(x,1)
	m = size(x,2)
	q = size(x,3)
	h = 1/(n*m*q)
	
	a = 0
	for i = 1:n
		for j = 1:m
			for k = 1:q
				a = a + x[i, j, k]^2
			end
		end
	end
	a = h* sqrt(a)
	return a
end

