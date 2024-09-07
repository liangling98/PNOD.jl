"""
Creates the information for the children nodes.

'tree': tree structure for the BnB method used in Bonobo.
'node': an PNODNODE structure.
'vidx': the index of the variable to branch.
"""
function Bonobo.get_branching_nodes_info(tree::Bonobo.BnBTree{<:PNODNODE}, node::PNODNODE, vidx::Int64)::Tuple
    @assert node.lower_bounds[vidx] ≤ node.upper_bounds[vidx]
    x = Bonobo.get_relaxed_values(tree, node)
    w = node.w
    N = tree.root.N
    frac_val = x[vidx]

    # left child 
    left_bounds = copy(node.upper_bounds)
    left_bounds[vidx] = floor(frac_val) / N
    left_solution = copy(node.solution)
    left_solution[vidx] = floor(frac_val)
    left_w = copy(node.w)
    left_w[vidx] = floor(frac_val) / N

    node_info_left = (
        lower_bounds=node.lower_bounds,
        upper_bounds=left_bounds,
        solution=left_solution,
        w=left_w,
        time=0.0,
        iteration_count=0
    )

    # right child 
    right_bounds = copy(node.lower_bounds)
    right_bounds[vidx] = ceil(frac_val) / N
    right_solution = copy(node.solution)
    right_solution[vidx] = ceil(frac_val)
    right_w = copy(node.w)
    right_w[vidx] = ceil(frac_val) / N

    node_info_right = (
        lower_bounds=right_bounds,
        upper_bounds=node.upper_bounds,
        solution=right_solution,
        w=right_w,
        time=0.0,
        iteration_count=0
    )

    return node_info_left, node_info_right
end