"""
Returns the solution vector of the relaxed node problem.

'tree': tree structure for the BnB method used in Bonobo.
'node': an PNODNODE structure.
"""
function Bonobo.get_relaxed_values(tree::Bonobo.BnBTree{<:PNODNODE}, node::PNODNODE)::Vector{Float64}
    return node.solution
end