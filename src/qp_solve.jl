"""Vertex Exchange Method

Solve a strongly convex quadratic programming problem: min_x 0.5*<x, Qx> + <c,x>  s.t.  sum(x) = 1.0, l <= x <= u.

'Q': Matrix Q, must be symmetric postive definite. 
'c': linear term in the objective function.
'l': lower bound vector.
'u': upper bound vector.
'x0': initial point.
'tol': termination tolerance.
'max_iter': maximal number of iterations.
"""
function qp_solve(Q::Matrix{Float64}, c::Vector{Float64}, l::Vector{Float64}, u::Vector{Float64}, x0::Vector{Float64}, tol::Float64, max_iter::Int64)::Tuple{Vector{Float64},Int64}

    normQ = norm(Q)
    x = copy(x0)

    # x0 is already feasible at the beginning of evaluating the current node, there is no need to project
    g = c + Q * x

    idx_s, g_s = find_ext_grad(x, g, l, "g", "maximum")
    idx_t, g_t = find_ext_grad(x, g, u, "l", "minimum")
    iter = 0
    while abs(g_s - g_t) > tol * max(1.0, normQ) && iter < max_iter
        # compute step size
        eta_max = min(x[idx_s] - l[idx_s], u[idx_t] - x[idx_t])
        eta_g = (g_s - g_t) / (Q[idx_s, idx_s] + Q[idx_t, idx_t] - 2.0 * Q[idx_s, idx_t])
        eta = min(eta_max, eta_g)

        # update x 
        x[idx_s] -= eta
        x[idx_t] += eta

        # update gradient 
        g .+= eta .* (Q[:, idx_t] .- Q[:, idx_s])

        # update the indices, extreme values and iteration count
        idx_s, g_s = find_ext_grad(x, g, l, "g", "maximum")
        idx_t, g_t = find_ext_grad(x, g, u, "l", "minimum")
        iter += 1
    end

    return x, iter
end