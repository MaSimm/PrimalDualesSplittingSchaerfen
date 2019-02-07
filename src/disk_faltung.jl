

function k(p,q,r,s)

	if p^2/r^2 + q^2/s^2 <= 1
		return 1
	else
		return 0
	end

	end

function disk_falt(u, r, s)
	n_d = size(u,1)
	m_d = size(u,2)
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

function disk_falt_adj(w,r,s)
	n_a = size(w,1)
	m_a = size(w,2)
	A = zeros((n_a + 2*r, m_a + 2*s))
	
	for i = 1:n_a+2*r
	for j = 1:m_a+2*s
		a = 0
		for n = max(0,i-2*r):min(i, n_a)
		for m = max(0,j-2*s):min(j, m_a)
			a = a + w[n, m]*k(n-i-r,m-j-s)			
		end
		end
		a = h*a
		A[i,j] = a
	end
	end

	return A
	end

