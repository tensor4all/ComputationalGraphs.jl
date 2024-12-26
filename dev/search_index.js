var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ComputationalGraphs","category":"page"},{"location":"#ComputationalGraphs","page":"Home","title":"ComputationalGraphs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ComputationalGraphs.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ComputationalGraphs]","category":"page"},{"location":"#ComputationalGraphs.ComputationalGraph","page":"Home","title":"ComputationalGraphs.ComputationalGraph","text":"A simple computational graph implementation\n\n\n\n\n\n","category":"type"},{"location":"#ComputationalGraphs.add_dependency!-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}} where {K, N}","page":"Home","title":"ComputationalGraphs.add_dependency!","text":"Add a dependency to a node in the computational graph.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.add_node!-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K, Union{Nothing, N}}} where {K, N}","page":"Home","title":"ComputationalGraphs.add_node!","text":"Add a node to the computational graph.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.compute_all_nodes!-Union{Tuple{ComputationalGraphs.ComputationalGraph{K, N}}, Tuple{N}, Tuple{K}} where {K, N}","page":"Home","title":"ComputationalGraphs.compute_all_nodes!","text":"Compute all nodes in the computational graph. Return the number of calls of computecomputablenodes!.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.compute_computable_nodes!-Union{Tuple{ComputationalGraphs.ComputationalGraph{K, N}}, Tuple{N}, Tuple{K}} where {K, N}","page":"Home","title":"ComputationalGraphs.compute_computable_nodes!","text":"Compute all computable nodes in the computational graph at the time of calling. Returns the number of computed nodes.\n\nYou can call this function multiple times, and it will only compute nodes that are computable at the time of calling.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.compute_computable_nodes_pmap!-Union{Tuple{ComputationalGraphs.ComputationalGraph{K, N}}, Tuple{N}, Tuple{K}} where {K, N}","page":"Home","title":"ComputationalGraphs.compute_computable_nodes_pmap!","text":"Like computecomputablenodes!, but computes nodes in parallel using distributed workers. Returns the number of computed nodes.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.compute_node!-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}} where {K, N}","page":"Home","title":"ComputationalGraphs.compute_node!","text":"Compute the value of a node in the computational graph.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.compute_node_data-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}} where {K, N}","page":"Home","title":"ComputationalGraphs.compute_node_data","text":"Prepare minimal data (dependencies' values + computefunc) for a node.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.get_computable_nodes-Union{Tuple{ComputationalGraphs.ComputationalGraph{K, N}}, Tuple{N}, Tuple{K}} where {K, N}","page":"Home","title":"ComputationalGraphs.get_computable_nodes","text":"Get the computable nodes in the computational graph. Ignore nodes that are already computed or assigned a value.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.is_computable-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}} where {K, N}","page":"Home","title":"ComputationalGraphs.is_computable","text":"Return if a node is computable, i.e., all its dependencies have been computed.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.is_computed-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K}} where {K, N}","page":"Home","title":"ComputationalGraphs.is_computed","text":"Return if a node is computed, i.e., it has a value assigned.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.reachable_nodes-Union{Tuple{K}, Tuple{NamedGraphs.NamedDiGraph, K}} where K","page":"Home","title":"ComputationalGraphs.reachable_nodes","text":"Find all nodes reachable from a starting node in a directed graph using depth-first search.\n\nArguments\n\ng::NamedDiGraph: The directed graph to search\nstart_node::Int: The node ID to start searching from\n\nReturns\n\nVector{Int}: IDs of all nodes reachable from the start node\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.unassign_intermediate_nodes!-Union{Tuple{ComputationalGraphs.ComputationalGraph{K, N}}, Tuple{N}, Tuple{K}} where {K, N}","page":"Home","title":"ComputationalGraphs.unassign_intermediate_nodes!","text":"Unassigned all unneseccary intermediate nodes from the computational graph. Return the number of unassigned nodes.\n\n\n\n\n\n","category":"method"},{"location":"#ComputationalGraphs.update_node_value!-Union{Tuple{N}, Tuple{K}, Tuple{ComputationalGraphs.ComputationalGraph{K, N}, K, N}} where {K, N}","page":"Home","title":"ComputationalGraphs.update_node_value!","text":"Update the value of a node and invalidate all dependent nodes.\n\nArguments\n\nobj::ComputationalGraph: The computational graph\nname::K: Name of the node to update \nnodevalue::N: New value to assign to the node\n\n\n\n\n\n","category":"method"}]
}
