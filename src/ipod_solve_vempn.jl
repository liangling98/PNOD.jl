"""
Solves the integer programming optimal design problem.

'A': experimental matrix 
'ub': upperbound for generating initial point (greedy_incumbent)
'N': experimental budget
'criterion': "A" or "D"
'verbose': print level
'print_iter': print info every print_iter iterations 
'time_limit': time limit (default=1 hour)
'save_results': whether to save results as csv file 
"""
function ipod_solve_vempn(
    A::Matrix{Float64},
    ub::Vector{Float64},
    N::Float64,
    criterion::String;
    verbose::Bool=true,
    print_iter::Int64=1,
    time_limit::Float64=3.6e3,
    save_results::Bool=false
)::Union{Vector{Int64},Vector{Float64},Nothing}

    if verbose
        println("------------------------------------------------------------------------------------")
    end
    m, n = size(A)
    @assert N ≥ n

    # build the bnb tree 
    tree = build_bnbtree(A, ub, N, criterion; verbose=verbose, time_limit=time_limit)
    if verbose
        println("------------------------------------------------------------------------------------")
    end

    # set up time reference
    time_ref = Dates.now()

    # build callback function
    callback = build_callback(time_ref; verbose=verbose, print_iter=print_iter)

    # optimize!
    sol_data = @timed Bonobo.optimize!(tree; callback=callback)
    time = sol_data.time

    # post processing 
    sol_x = round.(Int, Bonobo.get_solution(tree)) # old: convert.
    dummy_solution = fill(-1.0, m)
    if tree.root.stage == 0
        @assert sum(sol_x .!= dummy_solution) == length(sol_x)
    end
    solution = tree.root.f!(sol_x)
    if verbose
        stage = tree.root.stage
        num_nodes = tree.num_nodes
        branch_count = tree.root.branch_count
        println("------------------------------------------------------------------------------------")
        @show time
        @show sol_x
        @show solution
        @show num_nodes
        @show stage
        @show branch_count
    end

    # check feasibility
    is_feasible = check_feasibility(sol_x, 0 .* ub, ub, N; tol=1e-4)
    if verbose
        @show is_feasible
        if !is_feasible
            @show m, sum(ub - sol_x .>= 0)
            @show m, sum(sol_x .>= 0)
            @show N, sum(sol_x)
        end
    end
    @assert is_feasible

    # Check the solving stage
    status = tree.root.stage in [0, 1] ? "optimal" : "TIME_LIMIT"
    dual_gap = tree.incumbent - tree.lb

    if verbose
        @show status
        @show dual_gap
        println("------------------------------------------------------------------------------------\n")
    end

    if save_results
        # write data into file
        df = DataFrame(
            Obj=solution,
            Cpu=time,
            Nodes=tree.num_nodes
        )
        file_name = "./exp_data/results.csv"

        if !isfile(file_name)
            CSV.write(file_name, df, append=true, writeheader=true)
        else
            CSV.write(file_name, df, append=true)
        end
    end

    return sol_x

end