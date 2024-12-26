using ComputationalGraphs
using Documenter

DocMeta.setdocmeta!(
    ComputationalGraphs, :DocTestSetup, :(using ComputationalGraphs); recursive=true
)

makedocs(;
    modules=[ComputationalGraphs],
    authors="Hiroshi Shinaoka <h.shinaoka@gmail.com> and contributors",
    sitename="ComputationalGraphs.jl",
    format=Documenter.HTML(;
        canonical="https://github.com/tensor4all/ComputationalGraphs.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/tensor4all/ComputationalGraphs.jl.git", devbranch="main")
