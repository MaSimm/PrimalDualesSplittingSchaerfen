

function disk_ab_v(u::Array{Float64,2}, k::Int)

	n = size(u,1)
	m = size(u,2)
	h = 1/sqrt(n*m)

	
	v = zeros((n,m))
	
	if k == 1

		for i = 1:n
			for j = 1:m
				if i < n
					v[i, j] = (u[i+1, j] - u[i,j])/h
				else
					v[i, j] = 0
				end
			end
		end

	elseif k == 2

		for i = 1:n
			for j = 1:m
				if j < m
					v[i, j] = (u[i, j+1] - u[i,j])/h
				else
					v[i, j] = 0
				end
			end
		end

	else

		@warn("Die diskrete Ableitung ist nur für k=1 oder k=2 definiert.")
	
	end

	return v

end




function disk_ab_v_w_perf(u::Array{Float64,2}, k::Int)
	
	v = zeros((n,m))
	
	if k == 1

		perf_disk_ab_v_1(u,v)

	elseif k == 2

		perf_disk_ab_v_2(u,v)

	else

		@warn("Die diskrete Ableitung ist nur für k=1 oder k=2 definiert.")
	
	end

	return v

end

function perf_disk_ab_v_1(u::Array{Float64,2},v::Array{Float64,3})

	n = size(u,1)
	m = size(u,2)
	#M = n*m
	h = 1/sqrt(n*m)

	#@simd for a = 0:M-1
	#	j = a % m +1
	#	i = a ÷ m +1

	#	if i < n
	#		@fastmath @inbounds v[i, j, 1] = (u[i+1, j] - u[i,j])/h
	#	else
	#		@inbounds v[i, j, 1] = 0
	#	end
	#end

	for i = 1:n
		for j = 1:m
			if i < n
				@inbounds v[i, j, 1] = (u[i+1, j] - u[i,j])/h
			else
				@inbounds v[i, j, 1] = 0
			end
		end
	end

end

function perf_disk_ab_v_2(u::Array{Float64,2},v::Array{Float64,3})

	n = size(u,1)
	m = size(u,2)
	#M = n*m
	h = 1/sqrt(n*m)

	#@simd for a = 0:(M-1)
	#	j = (a % m) +1
	#	i = (a ÷ m) +1
	#	if j < m
	#		@fastmath @inbounds v[i, j, 2] = (u[i, j+1] - u[i,j])/h
	#	else
	#		@inbounds v[i, j, 2] = 0
	#	end
	#end

	for i = 1:n
		for j = 1:m
			if j < m
				@inbounds  v[i, j,2] = (u[i, j+1] - u[i,j])/h
			else
				@inbounds v[i, j,2] = 0
			end
		end
	end


end


function disk_grad(u::Array{Float64,2})
	return cat(disk_ab_v(u,1), disk_ab_v(u,2), dims=3)
end

function perf_disk_grad(u::Array{Float64,2}, res_arr::Array{Float64,3})
	perf_disk_ab_v_1(u,res_arr)
	perf_disk_ab_v_2(u,res_arr)
end
