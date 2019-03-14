
function perf_disk_ab_v_1(u::Array{Float64,2},v::Array{Float64,3})

	n = size(u,1)
	m = size(u,2)
	h = 1/sqrt(n*m)

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
	h = 1/sqrt(n*m)


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


function perf_disk_grad(u::Array{Float64,2}, res_arr::Array{Float64,3})
	perf_disk_ab_v_1(u,res_arr)
	perf_disk_ab_v_2(u,res_arr)
end
