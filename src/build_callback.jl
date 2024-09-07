"""
Build callback function 

'time_ref': reference time slot.
'verbose': whether to print info.
'print_iter': print every so many iterations.
"""
function build_callback(time_ref::DateTime; verbose::Bool=true, print_iter::Int64=1)::Function

    iter = 1

    function callback(tree::Bonobo.BnBTree{<:PNODNODE}, node::PNODNODE; node_infeasible::Bool=false, worse_than_incumbent::Bool=false)::Nothing
        time = float(Dates.value(Dates.now() - time_ref))

        if verbose && (mod(iter, print_iter) == 0 || Bonobo.terminated(tree) || node.id == 1)
            @printf(
                " %10d| %10d| %10d| %6.5e %6.5e %2.1e %2.1e| %2.1e %2.1e| %3d",
                iter,
                node.id,
                tree.num_nodes,
                tree.lb,
                tree.incumbent,
                abs(tree.lb - tree.incumbent),
                abs(tree.lb - tree.incumbent) / min(abs(tree.lb), abs(tree.incumbent)),
                time / 1e3,
                node.time / 1e3,
                node.iteration_count
            )
            println()

            if node_infeasible
                println(" [Node not feasible!]")
            elseif worse_than_incumbent
                println(" [Node cut because it is worse than the incumbent!]")
            end
        end

        iter += 1

        # break if time limit is met 
        if tree.root.time_limit < Inf
            if time / 1000.0 ≥ tree.root.time_limit
                if tree.root.stage == -1
                    tree.root.stage = 2
                end
            end
        end

        return nothing
    end

    return callback
end