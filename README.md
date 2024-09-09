# PNOD.jl

[![Build Status](https://github.com/liangling98/PNOD.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/liangling98/PNOD.jl/actions/workflows/CI.yml?query=branch%3Amain)

A Julia package on the Projected-Newton-Based framework for Exact Experimental Designs. 

## Important note.

- Codes based on [Bonobo.jl](https://github.com/Wikunia/Bonobo.jl/tree/main) and part of [OptimalDesignWithBoscia](https://github.com/ZIB-IOL/OptimalDesignWithBoscia). 
- The package is still under development. Thus it will invariably be buggy. We would appreciate your feedback and bugs’ report.
- This is a research package. It is not intended nor designed to be a general purpose software at the moment.


## Reproducibility
To reproduce the numerical results in the paper, please just run in your terminal:

```julia
julia run_exp.jl > ./exp_results/log.txt
```

### Nodes evaluated per second


<img src="./exp_results/Aind.png" width="300" height="200" />
<img src="./exp_results/Acor.png" width="300" height="200" />
<img src="./exp_results/Dind.png" width="300" height="200" />
<img src="./exp_results/Dcor.png" width="300" height="200" />

### Total computational time

<img src="./exp_results/Aind_cpu.png" width="300" height="200" />
<img src="./exp_results/Acor_cpu.png" width="300" height="200" />
<img src="./exp_results/Dind_cpu.png" width="300" height="200" />
<img src="./exp_results/Dcor_cpu.png" width="300" height="200" />

### Number of instances "successfully solved"

<img src="./exp_results/solved.png" width="600" height="400" />