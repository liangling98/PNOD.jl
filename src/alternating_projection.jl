"""
Alternating projection onto the generalized simplex constraint {x|sum(x) = N, lb <= x <= ub}

'x': the vector to be projected
'lb': lower bound vector
'ub': upper bound vector 
'N': sum value
"""
function alternating_projection(x::Vector{Float64}, lb::Vector{Float64}, ub::Vector{Float64}, N::Float64)::Union{Vector{Float64}, Nothing}
    if sum(lb) > N || sum(ub) < N || !all(lb <= ub)
        return nothing
    end

    iter = 0

    while !check_feasibility(x, lb, ub, N) && iter < 1000000
        x = project_onto_cube(x, lb, ub)
        x = project_on_prob_simplex(x, N) 
        iter += 1
    end

    return x
end

function project_onto_cube(x::Vector{Float64}, lb::Vector{Float64}, ub::Vector{Float64})::Vector{Float64}
    return clamp.(x, lb, ub)
end

function project_on_prob_simplex(x::Vector{Float64}, N::Float64)::Vector{Float64}
    n = length(x)
    return x - (sum(x)-N)/n * ones(n)
end