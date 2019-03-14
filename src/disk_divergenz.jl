

function perf_disk_ab_r_1(u::Array{Float64,3}, v::Array{Float64,2})
	n = size(u,1)
	m = size(u,2)
	h = 1/sqrt(n*m)

	for i = 1:n
		for j = 1:m
			if i == 1
				@inbounds v[i,j] = u[i,j]/h
			elseif i < n
				@inbounds v[i, j] = (u[i, j] - u[i-1,j])/h
			else
				@inbounds v[i, j] = -u[n-1,j]/h
			end
		end
	end

end

function perf_disk_ab_r_2(u::Array{Float64,3}, v::Array{Float64,2})
	n = size(u,1)
	m = size(u,2)
	h = 1/sqrt(n*m)

	
	for i = 1:n
		for j = 1:m
			if j == 1
				@inbounds v[i,j] = u[i,j]/h
			elseif j < m
				@inbounds v[i, j] = (u[i, j] - u[i,j-1])/h
			else
				@inbounds v[i, j] = -u[i,m-1]/h
			end
		end
	end

end

function perf_disk_div(u::Array{Float64,3}, res_arr::Array{Float64,2})
	perf_disk_ab_r_1(u, res_arr)
	perf_disk_ab_r_2(u, res_arr)
end

