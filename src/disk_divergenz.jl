

function disk_ab_r(u::Array{Float64,2}, k::Int)
	n = size(u,1)
	m = size(u,2)
	h = 1/sqrt(n*m)

	v = zeros((n,m))

	if k == 1

		for i = 1:n
			for j = 1:m
				if i == 1
					v[i,j] = u[i,j]/h
				elseif i < n
					v[i, j] = (u[i, j] - u[i-1,j])/h
				else
					v[i, j] = -u[n-1,j]/h
				end
			end
		end

	elseif k == 2

		for i = 1:n
			for j = 1:m
				if j == 1
					v[i,j] = u[i,j]/h
				elseif j < m
					v[i, j] = (u[i, j] - u[i,j-1])/h
				else
					v[i, j] = -u[i,m-1]/h
				end
			end
		end

	else
		@warn("Die Eingabe für die diskrete rückwärts Ableitung war falsch. Bitte k=1 oder k=2 eingeben!")
	end

	return v

end




function disk_ab_r_w_p(u::Array{Float64,2}, k::Int)

	v = zeros((n,m))

	if k == 1

		perf_disk_ab_r_1(u,v)

	elseif k == 2

		perf_disk_ab_r_2(u,v)

	else
		@warn("Die Eingabe für die diskrete rückwärts Ableitung war falsch. Bitte k=1 oder k=2 eingeben!")
	end

	return v

end

function perf_disk_ab_r_1(u::Array{Float64,3}, v::Array{Float64,2})
	n = size(u,1)
	m = size(u,2)
	M = n*m
	h = 1/sqrt(n*m)

	@simd for a = 0:(M-1)
		j = (a % m) +1
		i = (a ÷ m) +1		

		
		if i == 1
			@fastmath @inbounds v[i,j] = u[i,j,1]/h
		elseif i < n
			@fastmath @inbounds v[i, j] = (u[i, j,1] - u[i-1,j,1])/h
		else
			@fastmath @inbounds v[i, j] = -u[n-1,j,1]/h
		end
	end
end

function perf_disk_ab_r_2(u::Array{Float64,3}, v::Array{Float64,2})
	n = size(u,1)
	m = size(u,2)
	M = n*m
	h = 1/sqrt(n*m)

	@simd for a = 0:(M-1)
		j = (a % m) +1
		i = (a ÷ m) +1		
		
		if j == 1
			@fastmath @inbounds v[i,j] += u[i,j,2]/h
		elseif j < m
			@fastmath @inbounds v[i, j] += (u[i, j,2] - u[i,j-1,2])/h
		else
			@fastmath @inbounds v[i, j] += -u[i,m-1,2]/h
		end
	end
end


function disk_div(u::Array{Float64,3})
	return disk_ab_r(u[:,:,1],1) + disk_ab_r(u[:,:,2],2)
end

function perf_disk_div(u::Array{Float64,3}, res_arr::Array{Float64,2})
	perf_disk_ab_r_1(u, res_arr)
	perf_disk_ab_r_2(u, res_arr)
end

