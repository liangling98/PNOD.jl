"""
Build data for testing.

'seed': for the Random functions.
'm': number of experiments.
'corr': boolean deciding whether we build the independent or correlated data.   
"""
function build_data(seed::Int64, m::Int64, n::Int64, corr::Bool)::Tuple{Matrix{Float64},Vector{Float64},Float64}

    # set up
    Random.seed!(seed)
    if corr
        B = rand(m, n)
        B = B' * B
        @assert isposdef(B)
        D = MvNormal(randn(n), B)

        A = rand(D, m)'
        @assert rank(A) == n
    else
        A = rand(m, n)
        
        # check that A has the desired rank!
        @assert rank(A) == n 
    end

    N = floor(1.5 * n)
    u = floor(N / 3)
    ub = rand(1.0:u, m)

    return A, ub, N
end