

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
		@warn("Die Eingabe für die diskrete vorwärts Ableitung war falsch. Bitte k=1 oder k=2 eingeben!")
	end

	return v

end


function disk_grad(u::Array{Float64,2})
	return cat(disk_ab_v(u,1), disk_ab_v(u,2), dims=3)
end
