# PNOD.jl

[![Build Status](https://github.com/liangling98/PNOD.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/liangling98/PNOD.jl/actions/workflows/CI.yml?query=branch%3Amain)

A Julia package on the Projected-Newton-Based framework for Exact Experimental Designs. 

## Important note.

- Codes based on [Bonobo.jl](https://github.com/Wikunia/Bonobo.jl/tree/main) and part of [OptimalDesignWithBoscia](https://github.com/ZIB-IOL/OptimalDesignWithBoscia). 
- The package is still under development. Thus it will invariably be buggy. We would appreciate your feedback and bugs’ report.
- This is a research package. It is not intended nor designed to be a general purpose software at the moment.


## Reproducibility
To reproduce the numerical results of PNOD in the paper (works on Unix systems, not sure for Windows):

- Set up a valid [Github account](https://docs.github.com/en/get-started) on your machine
- [Install Julia Programming Language](https://julialang.org/install/)
- Clone this Repo by typing the follow in your terminal:
```git
git clone https://github.com/liangling98/PNOD.jl.git
```
- Direct to the `PNOD.jl` folder and type `julia` in your terminal to enter Julia REPL:
```
cd PNOD.jl
julia
```
- Press ']' to enter Pkg mode then type the following one by one to activate the env and install all required packages:
```julia
activate .
instantiate
```
- Quit the Pkg mode by pressing 'delete' and run the experiment in REPL via:
```julia
include("run_exp.jl")
```
If you want to get all the results, try:
```julia
for criterion in ["A", "D"]
    for type in ["IND", "COR"]
        for k in [10]
            for m in [50, 60, 80, 100, 120]
                ...
```