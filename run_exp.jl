using PNOD
using LinearAlgebra

time_limit = 3.6e3*2 

# pre compile 
A0, ub0, N0 = PNOD.build_data(1, 20, 2, false)
PNOD.ipod_solve_vempn(A0, ub0, N0, "D"; time_limit=time_limit, print_iter=10000)

# acutal experiments
for criterion in ["A"] #["A", "D"]
    for type in ["IND"] #["IND", "COR"]
        for k in [10]
            for m in [50] #[50, 60, 80, 100, 120]
                n = Int(floor(m / k))
                for seed in 1:5

                    # generate problem data 
                    corr = type == "IND" ? false : true
                    A, ub, N = PNOD.build_data(seed, m, n, corr)

                    @show criterion, corr
                    @show m, n, seed
                    @show N
                    @show time_limit

                    # run optimizer
                    x  = PNOD.ipod_solve_vempn(A, ub, N, criterion; time_limit=time_limit, print_iter=10000, save_results=false)

                    if criterion in ["A"]
                        @show obj = log(LinearAlgebra.tr(LinearAlgebra.inv(transpose(A) * diagm(x) * A)))
                    else
                        @show obj = -log(LinearAlgebra.det(transpose(A) * diagm(x) * A)) / m
                    end
                end
            end
        end
    end
end