"""
Node structure for Bonobo.BnBTreee, it has to be an Bonobo.AbstractNode.

'std': required field.
'lower_bounds': lower bound.
'upper_bounds': upper bound.
'solution': the solution Vector
'w': the weight vector sums up to 1.0 (solution/N where N is the experimental budget). 
'time': time taken for evaluating this node. 
'iteration_count': number of iterations taken for evaluating this node. 
"""
mutable struct PNODNODE <: Bonobo.AbstractNode
    std::Bonobo.BnBNodeInfo
    lower_bounds::Vector{Float64}
    upper_bounds::Vector{Float64}
    solution::Vector{Float64}
    w::Vector{Float64}
    time::Float64
    iteration_count::Int64
end