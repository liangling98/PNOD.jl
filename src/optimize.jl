"""
Customized optimize function.

'tree': Bonobo tree structure.
'callback': callback function.
"""
function Bonobo.optimize!(tree::Bonobo.BnBTree{<:PNODNODE}; callback::Function=(args...; kwargs...) -> ())::Nothing

    while !Bonobo.terminated(tree)
        node = Bonobo.get_next_node(tree, tree.options.traverse_strategy)
        lb, ub = Bonobo.evaluate_node!(tree, node)

        # if the problem was infeasible we simply close the node and continue
        if isnan(lb) && isnan(ub)
            Bonobo.close_node!(tree, node)
            callback(tree, node; node_infeasible=true)
            continue
        end

        Bonobo.set_node_bound!(tree.sense, node, lb, ub)

        # if the evaluated lower bound is worse than the best incumbent -> close and continue
        if node.lb >= tree.incumbent
            Bonobo.close_node!(tree, node)
            callback(tree, node; worse_than_incumbent=true)
            continue
        end

        tree.node_queue[node.id] = (node.lb, node.id)
        _, prio = peek(tree.node_queue)
        @assert tree.lb <= prio[1]
        tree.lb = prio[1]

        if Bonobo.update_best_solution!(tree, node)
            Bonobo.bound!(tree, node.id)
            if isapprox(tree.incumbent, tree.lb; atol=tree.options.atol, rtol=tree.options.rtol)
                tree.root.stage = 1
                callback(tree, node)
                break
            end
        end

        Bonobo.close_node!(tree, node)
        Bonobo.branch!(tree, node)
        callback(tree, node)
    end
    Bonobo.sort_solutions!(tree.solutions, tree.sense)

    return nothing
end