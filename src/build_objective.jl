"""
Build the objective function for optimal design problem under either D-criterion or A-criterion.

'A': data matrix collect all the experiments.
'p': 0 (D-criterion) or -1 (A-criterion).
'μ': perturbation parameter to ensure the positive definiteness of the information matrix.

Returns a function f!(x::Vector{Float64}; storage_g::Union{Vector{Float64}, Nothing}=nothing, storage_h::Union{Matrix{Float64}, Nothing}=nothing).

'x': the input vector.
'storage_g': predefined storage space for gradient (optional).
'storage_h': predefined storage space for Hessian (optional). 
"""
function build_objective(A::Matrix{Float64}, p::Int64; μ::Float64=1e-14)::Function

    @assert p in [-1, 0]
    m, n = size(A)

    # pre-allocate memory
    perturb_matrix = Matrix(μ * I, n, n)
    X = similar(perturb_matrix)
    X_inv = similar(perturb_matrix)
    X_tmp = similar(Matrix(0.0 * I, m, m))
    X_tmp_2 = similar(X_tmp)
    diag_X = similar(zeros(m))
    invXAt = similar(A')

    function f!(
        x::Union{Vector{Float64},Vector{Int64}};
        storage_g::Union{Vector{Float64},Nothing}=nothing,
        storage_h::Union{Matrix{Float64},Nothing}=nothing
    )::Float64

        X .= Symmetric(A' * Diagonal(x) * A .+ perturb_matrix)
        X_chol = cholesky(X)
        if !isposdef(X_chol)
            if !(storage_g === nothing) && !(storage_h === nothing)
                storage_g = fill(Inf, length(storage_g))
                storage_h = fill(Inf, size(storage_h))
            end

            return Inf
        end

        if p == 0
            fval = (-1.0 / m) * logdet(X_chol)
            if !(storage_g === nothing) && !(storage_h === nothing)
                invXAt = X_chol \ A'
                X_tmp .= A * invXAt
                diag_X .= diag(X_tmp)
                storage_g .= (-1.0 / m) .* diag_X
                storage_h .= (X_tmp .* X_tmp) / m
            end
        elseif p == -1
            X_inv .= inv(X_chol)
            tr_X_inv = tr(X_inv)
            fval = log(tr_X_inv)
            if !(storage_g === nothing) && !(storage_h === nothing)
                invXAt = X_chol \ A'
                X_tmp .= A * invXAt
                X_tmp_2 .= invXAt' * invXAt
                diag_X .= diag(X_tmp_2)
                storage_g .= (-1.0 / tr_X_inv) .* diag_X
                storage_h .= (2.0 / tr_X_inv) .* X_tmp_2 .* X_tmp .- (1.0 / tr_X_inv^2) .* (diag_X * diag_X')
            end
        end

        return fval
    end

    return f!
end