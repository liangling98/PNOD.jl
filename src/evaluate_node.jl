"""
Solve the continuous relaxation at the current node.

'tree': tree structure for the BnB method used in Bonobo.
'node': an PNODNODE structure.
'tol': optimality tolerance. (default = 1e-3) 
"""
function Bonobo.evaluate_node!(tree::Bonobo.BnBTree{<:PNODNODE}, node::PNODNODE; tol::Float64=1e-3)::Tuple{Float64,Float64}

    time_ref = Dates.now()
    iter_count = 0

    # Get a feasible starting point 
    N = tree.root.N
    w = copy(node.w)
    w = alternating_projection(w, node.lower_bounds, node.upper_bounds, 1.0)
    if w === nothing
        return NaN, NaN
    end

    n = length(w)
    gradient = similar(w)
    hessian = Array{Float64}(undef, n, n)
    fval = tree.root.f!(w; storage_g=gradient, storage_h=hessian)

    # return back to the maximization problem, hence: -gradient
    jdx, g_jdx = find_ext_grad(w, -gradient, node.upper_bounds, "l", "maximum")
    kdx, g_kdx = find_ext_grad(w, -gradient, node.lower_bounds, "g", "minimum")

    if jdx == -1 || kdx == -1
        return NaN, NaN
    end

    tol_qp = tol^2/5
    max_iter_qp = 10000000
    iter_qp = 0
    while g_jdx / g_kdx - 1 > tol && iter_count < 10000
        # solve the projected Newton subproblem
        w, iter_qp = qp_solve(
            hessian,
            gradient - hessian * w,
            node.lower_bounds,
            node.upper_bounds,
            w,
            tol_qp,
            max_iter_qp
        )
        if iter_qp == 0
            tol_qp /= 5.0
        end

        # update f, gradient and hessian 
        fval = tree.root.f!(w; storage_g=gradient, storage_h=hessian)

        # return back to the maximization problem, hence: -gradient
        jdx, g_jdx = find_ext_grad(w, -gradient, node.upper_bounds, "l", "maximum")
        kdx, g_kdx = find_ext_grad(w, -gradient, node.lower_bounds, "g", "minimum")

        if jdx == -1 || kdx == -1
            return NaN, NaN
        end

        iter_count += 1

        is_feasible = check_feasibility(w, node)
        if !is_feasible
            @show node.upper_bounds - w
            @show w - node.lower_bounds
            @show sum(w)
            return NaN, NaN
        end
        # @assert is_feasible
    end

    time = float(Dates.value(Dates.now() - time_ref))
    node.time = time
    node.iteration_count = iter_count
    x = N .* w
    node.w = w
    node.solution = x
    obj_value = tree.root.f!(x)

    if isapprox(sum(isapprox.(x, round.(x); atol=1e-6, rtol=5e-2)), tree.root.nvars) &&
        check_feasibility(round.(x), node.lower_bounds * N, node.upper_bounds * N, N)
        println(" [Integer solution found!]")
        node.solution = round.(x)
        primal = tree.root.f!(node.solution)
        return obj_value, primal
    end

    return obj_value, NaN
end