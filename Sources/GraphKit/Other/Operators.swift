//
//  Operators.swift
//  GraphKit
//
//  Created by Marcus Rossel on 26.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// Returns the result of forming the union of two graphs.
public func +<Edge>(left: Graph<Edge>, right: Graph<Edge>) -> Graph<Edge> {
   return left.union(with: right)
}

/// Returns the result of removing an edge from a graph.
public func -<Edge>(graph: Graph<Edge>, edge: Edge) -> Graph<Edge> {
   return graph.removing(edge: edge)
}

/// Returns the result of removing a sequence of edges from a graph.
public func -<Edge, S>(graph: Graph<Edge>, edges: S) -> Graph<Edge>
where S: Sequence, S.Element == Edge {
   return graph.removing(edges: edges)
}

/// Returns the result of removing a vertex from a graph.
public func -<Edge, Vertex>(graph: Graph<Edge>, vertex: Vertex) -> Graph<Edge>
where Edge.Vertex == Vertex {
   return graph.removing(vertex: vertex)
}

/// Returns the result of removing a sequence of vertices from a graph.
public func -<Edge, Vertex, S>(graph: Graph<Edge>, vertices: S) -> Graph<Edge>
where Edge.Vertex == Vertex, S: Sequence, S.Element == Vertex {
   return graph.removing(vertices: vertices)
}
