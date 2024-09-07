"""
Returns the list of indices corresponding to the integral variables.
"""
function Bonobo.get_branching_indices(root::IPOD)
    return root.integer_vars
end