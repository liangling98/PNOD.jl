"""
Finds the extremal (minimum or maximum) entry and its location of a vector g on the indices with respect to {x cmp bd}.

'x': weight vector. 
'g': gradient vector. 
'bd': lower bound vector or upper bound vector. 
'cmp': comparison rule, "l" less than, "g" greater than.
'extm': extreme mode, "minimum" or "maximum"
'tol': tolerance when comparing x and bd
"""
function find_ext_grad(x::Vector{Float64}, g::Vector{Float64}, bd::Vector{Float64}, cmp::String, extm::String; tol::Float64=0.0)::Tuple{Int64,Float64}

    @assert cmp in ["l", "g"]
    @assert extm in ["minimum", "maximum"]

    bool_vec = cmp == "l" ? x .< bd .+ tol : x .> bd .- tol
    if sum(bool_vec) == 0
        return -1, NaN
    end
    idx_set = findall(x -> x == 1, bool_vec)
    extreme_value = extm == "minimum" ? minimum(g[idx_set]) : maximum(g[idx_set])

    return findfirst(x -> x == extreme_value, g), extreme_value
end