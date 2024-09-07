"""
Checks if the branch and bound can be stopped.
By default (in Bonobo) stops then the priority queue is empty. 

'tree': Bonobo tree structure.
"""
function Bonobo.terminated(tree::Bonobo.BnBTree{<:PNODNODE})::Bool
    # time limit reached
    if tree.root.stage == 2
        return true
    end
    
    # absolute gap reached
    absgap = abs(tree.incumbent - tree.lb)
    if absgap ≤ tree.root.abs_gap
        tree.root.stage = 1
        return true
    end

    # relative gap reached
    dual_gap = if signbit(tree.incumbent) != signbit(tree.lb)
        Inf
    elseif tree.incumbent == tree.lb
        0.0
    else
        absgap / min(abs(tree.incumbent), abs(tree.lb))
    end
    if dual_gap ≤ tree.root.rel_gap
        tree.root.stage = 1
        return true
    end

    # tree empty
    if isempty(tree.nodes)
        tree.root.stage = 0
        return true
    end

    return false
end