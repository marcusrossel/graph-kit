//
//  Non-Mutating Methods.swift
//  GraphKit
//
//  Created by Marcus Rossel on 26.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Graph

extension Graph {
   
   /// Returns the result of inserting a given vertex into the graph.
   public func inserting(vertex: Vertex) -> Graph {
      return nonMutating(Graph.insert(vertex:), for: self)(vertex)
   }
   
   /// Returns the result of inserting a given sequence vertices into the graph.
   public func inserting<S>(vertices: S) -> Graph
   where S: Sequence, S.Element == Vertex {
         return nonMutating(Graph.insert(vertices:), for: self)(vertices)
   }
   
   /// Returns the result of removing a vertex from the graph.
   /// This also removes all of the edges incident to the vertex.
   public func removing(vertex: Vertex) -> Graph {
      return nonMutating(Graph.remove(vertex:), for: self)(vertex)
   }
   
   /// Returns the result of removing a given sequence of vertices from the
   /// graph.
   public func removing<S>(vertices: S) -> Graph
   where S: Sequence, S.Element == Vertex {
      return nonMutating(Graph.remove(vertices:), for: self)(vertices)
   }
   
   /// Returns the result of removing all of the vertices satisfying a given
   /// condition. This also removes all of the edges incident to those vertices.
   public func removingVertices(where condition: (Vertex) -> Bool) -> Graph {
      return nonMutating(Graph.removeVertices(where:), for: self)(condition)
   }
   
   /// Returns the result of inserting a given edge into the graph.
   public func inserting(edge: Edge) -> Graph {
      return nonMutating(Graph.insert(edge:), for: self)(edge)
   }
   
   /// Returns the result of inserting a sequence of edges into the graph.
   public func inserting<S>(edges: S) -> Graph
   where S: Sequence, S.Element == Edge {
      return nonMutating(Graph.insert(edges:), for: self)(edges)
   }
   
   /// Returns the result of removing a given edge from the graph.
   public func removing(edge: Edge) -> Graph {
      return nonMutating(Graph.remove(edge:), for: self)(edge)
   }
   
   /// Returns the result of removing a given sequence of edges from the graph.
   public func removing<S>(edges: S) -> Graph
   where S: Sequence, S.Element == Edge {
      return nonMutating(Graph.remove(edges:), for: self)(edges)
   }
   
   /// Returns the result of removing all of the edges that satisfy a given
   /// condition.
   public func removingEdges(where condition: (Edge) -> Bool) -> Graph {
      return nonMutating(Graph.removeEdges(where:), for: self)(condition)
   }
}

// MARK: - Set Algebra

extension Graph {

   /// Returns the union of the graph with another given graph.
   public func union(with graph: Graph) -> Graph {
      return nonMutating(Graph.formUnion(with:), for: self)(graph)
   }
   
   /// Returns the intersection of the graph with another given graph.
   public func intersection(with graph: Graph) -> Graph {
      return nonMutating(Graph.formIntersection(with:), for: self)(graph)
   }
   
   /// Returns the symmetric difference of the graph with another given graph.
   public func symmetricDifference(with graph: Graph) -> Graph {
      return nonMutating(Graph.formSymmetricDifference(with:), for: self)(graph)
   }
   
   /// Returns a new graph containing the elements of this graph that do not
   /// occur in the given graph.
   public func subtracting(_ graph: Graph) -> Graph {
      return nonMutating(Graph.subtract(_:), for: self)(graph)
   }
}
