

function disk_ab_r(u,k)
	n = size(u,1)
	m = size(u,2)
	h = 1/(n*m)

	v = copy(u)

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


function disk_div(u)
	return disk_ab_r(u[:,:,1],1) + disk_ab_r(u[:,:,2],2)
end

