"""
Integer Nonlinear Programming Problem for Optimal Design 

'f': function computing objective value (A and D criteria), gradient (optional) and Hessian (optional).
'nvar': number of variables.
'integer_vars': vector of integer variables.
'N': experimental budget.
'time_limit': time limit for solving the problem.
'rel_gap': relative gap for termination.
'abs_gap': absolute gap for termination.
'stage': -1: solving, 0: BnB terminate with empty tree, 1: succeed, 2: time limit reached.
"""
mutable struct IPOD{F}
    f!::F
    nvars::Int64
    integer_vars::Vector{Int64}
    branch_count::Vector{Int64}
    N::Float64
    time_limit::Float64
    rel_gap::Float64
    abs_gap::Float64
    stage::Int64
end

IPOD(f!, n, int_vars, bc, N, time_limit) = IPOD(f!, n, int_vars, bc, N, time_limit, 1e-6, 1e-6, -1)