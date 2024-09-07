"""
Branching 
"""
function Bonobo.branch!(tree::Bonobo.BnBTree{<:PNODNODE}, node::PNODNODE)
    variable_idx = Bonobo.get_branching_variable(tree, tree.options.branch_strategy, node)
    variable_idx == -1 && return

    tree.root.branch_count[variable_idx] += 1
    nodes_info = Bonobo.get_branching_nodes_info(tree, node, variable_idx)
    for node_info in nodes_info
        Bonobo.add_node!(tree, node, node_info)
    end
end