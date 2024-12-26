"""
A simple computational graph implementation
"""
struct ComputationalGraph{K,N}
    graph::NamedDiGraph{K}
    computefunc::Dict{K,Function} # Node to a computable function
    #dependencies::Dict{K,Vector{K}} # Node to dependency node 
    nodevalue::Dict{K,Union{Nothing,N}} # Node to an assigned value
    intermediate_nodes::Set{K} # intermediate nodes, which can be unassigned once all nodes that depend on it are computed
    disabled_nodes::Set{K} # unassigned intermediate nodes

    function ComputationalGraph{K,N}(name::K...) where {K,N}
        return new(
            NamedDiGraph{K}(),
            Dict{K,Function}(),
            Dict{K,Union{Nothing,N}}(),
            Set{K}(),
            Set{K}(),
        )
    end
end

"""
Add a node to the computational graph.
"""
function add_node!(
    obj::ComputationalGraph{K,N},
    node::K,
    nodevalue::Union{N,Nothing}=nothing;
    is_intermediate=false,
) where {K,N}
    add_vertex!(obj.graph, node)
    obj.nodevalue[node] = nodevalue
    if is_intermediate
        push!(obj.intermediate_nodes, node)
    end
end

"""
Find all nodes reachable from a starting node in a directed graph using depth-first search.

# Arguments
- `g::NamedDiGraph`: The directed graph to search
- `start_node::Int`: The node ID to start searching from

# Returns
- `Vector{Int}`: IDs of all nodes reachable from the start node
"""
function reachable_nodes(g::NamedDiGraph, start_node::K)::Vector{K} where {K}
    visited = Set{K}()
    stack = [start_node]
    push!(visited, start_node)

    while !isempty(stack)
        v = pop!(stack)
        for w in outneighbors(g, v)
            if !(w ∈ visited)
                push!(visited, w)
                push!(stack, w)
            end
        end
    end

    return collect(visited)
end

"""
Update the value of a node and invalidate all dependent nodes.

# Arguments
- `obj::ComputationalGraph`: The computational graph
- `name::K`: Name of the node to update 
- `nodevalue::N`: New value to assign to the node
"""
function update_node_value!(obj::ComputationalGraph{K,N}, node::K, nodevalue::N) where {K,N}
    obj.nodevalue[node] = nodevalue

    # Invalidate all nodes that depend on the updated node
    for node_ in reachable_nodes(obj.graph, node)
        if node_ == node
            continue
        end
        obj.nodevalue[node_] = nothing
    end
end

"""
Add a dependency to a node in the computational graph.
"""
function add_dependency!(
    obj::ComputationalGraph{K,N},
    node::K;
    computefunc::Function=x -> nothing,
    dependencies=K[],
) where {K,N}
    obj.computefunc[node] = computefunc
    for src in dependencies
        add_edge!(obj.graph, src, node)
    end
end

"""
Return if a node is computable, i.e., all its dependencies have been computed.
"""
function is_computable(obj::ComputationalGraph{K,N}, node::K)::Bool where {K,N}
    #if !(node ∈ keys(obj.dependencies))
    #return true
    #end
    if length(inneighbors(obj.graph, node)) == 0
        return true
    end
    return all(is_computed(obj, node_) for node_ in inneighbors(obj.graph, node))
end

"""
Return if a node is computed, i.e., it has a value assigned.
"""
function is_computed(obj::ComputationalGraph{K,N}, node::K)::Bool where {K,N}
    return obj.nodevalue[node] !== nothing
end

"""
Get the computable nodes in the computational graph.
Ignore nodes that are already computed or assigned a value.
"""
function get_computable_nodes(obj::ComputationalGraph{K,N})::Vector{K} where {K,N}
    return [
        v for v in vertices(obj.graph) if
        is_computable(obj, v) && !is_computed(obj, v) && v ∉ obj.disabled_nodes
    ]
end

"""
Compute the value of a node in the computational graph.
"""
function compute_node!(obj::ComputationalGraph{K,N}, node::K)::N where {K,N}
    if !is_computable(obj, node)
        error("Node is not computable")
    end
    dependencies = inneighbors(obj.graph, node)
    args = Dict(depnode => obj.nodevalue[depnode] for depnode in dependencies)
    obj.nodevalue[node] = obj.computefunc[node](args)
    return obj.nodevalue[node]
end

"""
Compute all computable nodes in the computational graph at the time of calling.
Returns the number of computed nodes.

You can call this function multiple times, and it will only compute nodes that are computable at the time of calling.
"""
function compute_computable_nodes!(obj::ComputationalGraph{K,N})::Int where {K,N}
    computable_nodes = get_computable_nodes(obj)
    for node in computable_nodes
        compute_node!(obj, node)
    end
    return length(computable_nodes)
end

"""
Prepare minimal data (dependencies' values + computefunc) for a node.
"""
function compute_node_data(
    obj::ComputationalGraph{K,N}, node::K
)::Tuple{Dict{K,N},Function} where {K,N}
    # Check if node is computable
    if !is_computable(obj, node)
        error("Node $node is not computable")
    end
    # Get dependency nodes
    dependencies = inneighbors(obj.graph, node)
    # Collect values of dependency nodes (Dict{depnode => value})
    args = Dict(depnode => obj.nodevalue[depnode] for depnode in dependencies)
    # Get function to execute
    func = obj.computefunc[node]
    # Return tuple of (dependency node values, function)
    return (args, func)
end

function _compute_node_remote(args::Dict{K,N}, func::Function) where {K,N}
    # Small function to execute on worker nodes
    return func(args)
end

"""
Like compute_computable_nodes!, but computes nodes in parallel using distributed workers.
Returns the number of computed nodes.
"""
function compute_computable_nodes_pmap!(obj::ComputationalGraph{K,N})::Int where {K,N}
    computable_nodes = get_computable_nodes(obj)

    @show length(computable_nodes)
    # Create (args, func) and pmap them
    # Only (args, func) are transferred to workers
    results = pmap(node -> begin
        (args, f) = compute_node_data(obj, node)   # Generate minimal data locally
        _compute_node_remote(args, f)               # Execute on worker
    end, computable_nodes)

    # Update obj.nodevalue[node] with results returned from workers
    for (i, node) in enumerate(computable_nodes)
        obj.nodevalue[node] = results[i]
    end

    return length(results)
end

"""
Unassigned all unneseccary intermediate nodes from the computational graph.
Return the number of unassigned nodes.
"""
function unassign_intermediate_nodes!(obj::ComputationalGraph{K,N})::Int where {K,N}
    count = 0
    for node in obj.intermediate_nodes
        if all((is_computed(obj, dstnode) for dstnode in outneighbors(obj.graph, node)))
            obj.nodevalue[node] = nothing
            push!(obj.disabled_nodes, node)
            count += 1
        end
    end
    return count
end

"""
Compute all nodes in the computational graph.
Return the number of nodes computed.
"""
function compute_all_nodes!(
    obj::ComputationalGraph{K,N}; callgc=true, distributed=false
)::Int where {K,N}
    count = 0
    while true
        computed_count = if distributed
            compute_computable_nodes_pmap!(obj)
        else
            compute_computable_nodes!(obj)
        end
        unassign_intermediate_nodes!(obj)
        if callgc
            GC.gc()
        end
        if computed_count == 0
            break
        end
        count += computed_count
    end
    return count
end
