"""
Builds tree for BnB optimizer.

'A': data matrix stores all the exeperiments.
'ub': upper bound vector.
'N': experimental budget.
'criterion': "D" or "A".
'verbose': print infomation.
'time_limit': time limit, default 1 hour.
"""
function build_bnbtree(A::Matrix{Float64}, ub::Vector{Float64}, N::Float64, criterion::String; verbose::Bool=true, time_limit::Float64=3.6e3)::Bonobo.BnBTree
    @assert criterion in ["D", "A"]
    m, n = size(A)

    # build objective function
    p = criterion == "D" ? 0 : -1
    f! = build_objective(A, p)

    # create initial lower bounds 
    lb = zeros(m)

    # create initial point 
    x0 = greedy_incumbent(A, ub, N)

    # construct the root node 
    root = IPOD(f!, m, collect(1:m), 0 .* collect(1:m), N, time_limit)
    x0_int = round.(Int, x0)
    fx0 = f!(x0)
    if verbose
        @show x0_int
        @show fx0
    end

    # construct an example node for inferencing its type 
    example_node = PNODNODE(
        Bonobo.BnBNodeInfo(1, 0.0, 0.0),
        lb,
        ub,
        fill(-1.0, m),
        fill(-1.0, m),
        0.0,
        0
    )

    Node = typeof(example_node)
    Value = Vector{Float64}

    # construct the tree for the BnB method 
    tree = Bonobo.initialize(;
        traverse_strategy=Bonobo.BFS(),
        branch_strategy=Bonobo.MOST_INFEASIBLE(),
        Node=Node,
        Solution=Bonobo.DefaultSolution{Node,Value},
        root=root,
        sense=:Min
    )

    # set root node 
    Bonobo.set_root!(
        tree,
        (
            lower_bounds=lb / N,
            upper_bounds=ub / N,
            solution=x0,
            w=x0 / N,
            time=0.0,
            iteration_count=0
        )
    )

    # dummy solution: in case the process stops due to the time limit and no solution has been found yet
    dummy_solution = Bonobo.DefaultSolution(Inf, fill(-1.0, m), example_node)
    if isapprox(sum(isapprox.(x0, round.(x0))), tree.root.nvars)
        first_solution = Bonobo.DefaultSolution(fx0, x0, example_node)
        push!(tree.solutions, first_solution)
        tree.incumbent_solution = first_solution
        tree.incumbent = fx0
    else
        push!(tree.solutions, dummy_solution)
        tree.incumbent_solution = dummy_solution
    end

    return tree
end