using Test
import ComputationalGraphs as CG

@testset "test_computationalgraph.jl" begin
    @testset "C <= A+B" begin
        cg = CG.ComputationalGraph{Any,Float64}()
        CG.add_node!(cg, "A", 1.0)
        CG.add_node!(cg, "B", 2.0)
        CG.add_node!(cg, "C")
        CG.add_dependency!(cg, "C"; dependencies=["A", "B"], computefunc=x -> x["A"] + x["B"])

        @test CG.is_computable(cg, "C") == true
        @test CG.get_computable_nodes(cg) == ["C"]
        @test CG.compute_node!(cg, "C") == 3.0

        CG.update_node_value!(cg, "A", 10.0)
        @test CG.is_computable(cg, "C") == true
        @test CG.is_computed(cg, "C") == false

        @test CG.compute_node!(cg, "C") == 12.0
    end

    @testset "C <= (A1 + A2) + (B1 + B2)" begin
        cg = CG.ComputationalGraph{Any,Float64}()
        CG.add_node!(cg, "A1", 1.0)
        CG.add_node!(cg, "A2", 2.0)
        CG.add_node!(cg, "B1", 1.0)
        CG.add_node!(cg, "B2", 2.0)
        CG.add_node!(cg, "A"; is_intermediate=true)
        CG.add_node!(cg, "B"; is_intermediate=true)
        CG.add_node!(cg, "C")

        CG.add_dependency!(cg, "A"; dependencies=["A1", "A2"], computefunc=x -> sum(values(x)))
        CG.add_dependency!(cg, "B"; dependencies=["B1", "B2"], computefunc=x -> sum(values(x)))
        CG.add_dependency!(cg, "C"; dependencies=["A", "B"], computefunc=x -> sum(values(x)))

        @test CG.is_computable(cg, "A") == true
        @test CG.is_computable(cg, "B") == true
        @test CG.is_computable(cg, "C") == false

        @test CG.compute_computable_nodes!(cg) == 2 # A and B are computed

        @test CG.is_computed(cg, "A") == true
        @test CG.is_computed(cg, "B") == true
        @test CG.is_computable(cg, "C") == true

        CG.compute_computable_nodes!(cg) # C can now be computed
        @test cg.nodevalue["C"] == 6.0 # A + B = 3 + 3 = 6

        # intermediate nodes, A and B, can be unassigned.
        @test CG.unassign_intermediate_nodes!(cg) == 2
        @test cg.nodevalue["A"] === nothing
        @test cg.nodevalue["B"] === nothing
    end


    @testset "C <= (A1 + A2) + (B1 + B2), compute_all_nodes!" begin
        cg = CG.ComputationalGraph{Any,Float64}()
        CG.add_node!(cg, "A1", 1.0)
        CG.add_node!(cg, "A2", 2.0)
        CG.add_node!(cg, "B1", 1.0)
        CG.add_node!(cg, "B2", 2.0)
        CG.add_node!(cg, "A"; is_intermediate=true)
        CG.add_node!(cg, "B"; is_intermediate=true)
        CG.add_node!(cg, "C")

        CG.add_dependency!(cg, "A"; dependencies=["A1", "A2"], computefunc=x -> sum(values(x)))
        CG.add_dependency!(cg, "B"; dependencies=["B1", "B2"], computefunc=x -> sum(values(x)))
        CG.add_dependency!(cg, "C"; dependencies=["A", "B"], computefunc=x -> sum(values(x)))

        @test CG.compute_all_nodes!(cg) == 2
        @test cg.nodevalue["C"] == 6.0 # A + B = 3 + 3 = 6
        @test cg.nodevalue["A"] === nothing
        @test cg.nodevalue["B"] === nothing
    end
end
;