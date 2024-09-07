"""
Create first incumbent for the BnB method in a greedy fashion.

'A': exeperiments matrix
'N': experiment budget.
'ub': upper bound for the initial solution.
"""
function greedy_incumbent(A::Matrix{Float64}, ub::Vector{Float64}, N::Float64)::Vector{Float64}

    # Get n linearly independent rows of A
    m, n = size(A)
    S = linearly_independent_rows(A, m, n)
    @assert length(S) == n

    # set entries to their upper bound
    x = zeros(m)
    x[S] .= ub[S]

    if isapprox(sum(x), N; atol=1e-4, rtol=1e-2)
        return x
    elseif sum(x) > N
        while sum(x) > N
            remove_from_max!(x)
        end
    elseif sum(x) < N
        S1 = S
        while sum(x) < N
            jdx = rand(setdiff(collect(1:m), S1))
            x[jdx] = min(N - sum(x), ub[jdx])
            push!(S1, jdx)
            sort!(S1)
        end
    end
    @assert isapprox(sum(x), N; atol=1e-4, rtol=1e-2)
    @assert sum(ub - x .>= 0) == m
    return x
end

"""
Find n linearly independent rows of A to build the starting point.
"""
function linearly_independent_rows(A::Matrix{Float64}, m::Int64, n::Int64)::Vector{Int64}

    S = Vector{Int64}()
    for i in 1:m
        S_i = vcat(S, i)
        if rank(A[S_i, :]) == length(S_i)
            S = S_i
        end
        if length(S) == n 
            return S
        end
    end
    return S 
end

"""
Remove 1 from the max entries.

'x': the vector to modify.
"""
function remove_from_max!(x::Vector{Float64})::Nothing
    perm = sortperm(x, rev=true)
    j = findlast(x -> x != 0, x[perm])

    for i in 1:j
        if x[perm[i]] > 1
            x[perm[i]] -= 1
            break
        else
            continue
        end
    end
end