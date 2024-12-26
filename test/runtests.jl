using Distributed

nworkers_ = 2
if nworkers() < nworkers_
    addprocs(nworkers_ - nworkers())
end

@everywhere import ComputationalGraphs as CG
using Test

include("test_computationalgraph.jl")
