"""
Given lower and upper bounds, the sum value, check whether a vector is feasible to {x|sum(x) = N, lb <= x <= ub}

'x': the vector to be checked
'lb': lower bound vector
'ub': upper bound vector 
'N': sum value
'tol': tolerance in feasibility. (default=eps)
"""
function check_feasibility(x::Union{Vector{Float64}, Vector{Int64}}, lb::Vector{Float64}, ub::Vector{Float64}, N::Float64; tol=2.24e-16)::Bool
    m = length(x)
    return sum(x .>= lb .- tol) == m && sum(x .<= ub .+ tol) == m && isapprox(sum(x), N) 
end

"""
Checks feasibility of a given point with constraints specified by a given node.

'x': vector for the point to be checked.
'node': a given node <: PNODNODE
'N': right hand side value for the linear equality constraint.
'tol': tolerance in feasibility.
"""
check_feasibility(x::Vector{Float64}, node::PNODNODE; N::Float64=1.0, tol::Float64=1e-9) =
    check_feasibility(x, node.lower_bounds, node.upper_bounds, N, tol=tol)