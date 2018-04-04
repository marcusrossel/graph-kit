//
//  Directed Graph.swift
//  GraphKit
//
//  Created by Marcus Rossel on 16.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A `Graph` that uses `Edge.Directed`s
public typealias DirectedGraph<Vertex> = Graph<Edge.Directed<Vertex>>
where Vertex: VertexProtocol

extension Graph where Edge: DirectedEdge {
   
   /// Returns the edges originating from the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func edges(originatingFrom vertex: Vertex) -> [Edge]? {
      return edges(incidentTo: vertex)?.filter { edge in edge.start == vertex }
   }
   
   /// Returns the edges ending in the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func edges(endingIn vertex: Vertex) -> [Edge]? {
      return edges(incidentTo: vertex)?.filter { edge in edge.end == vertex }
   }
   
   /// Returns the number of edges ending in the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func indegree(of vertex: Vertex) -> Int? {
      return edges(endingIn: vertex)?.count
   }
   
   /// Returns the number of edges originating from the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func outdegree(of vertex: Vertex) -> Int? {
      return edges(originatingFrom: vertex)?.count
   }
   
   /// Returns a graph representing the search-tree attained from performing a
   /// breadth first search starting at a given vertex.
   ///
   /// Optionally a transition condition can be passed, which is used to
   /// determine if a transition from a specific vertex using a specific edge is
   /// valid.
   ///
   /// If the given vertex is not part of the graph, `nil` is returned.
   public func breadthFirstSearch(
      from start: Vertex,
      transitioningBetween transitionCondition: ((Vertex, Edge) -> Bool)? = nil
   ) -> SimpleGraph<GraphKitVertex<(Vertex, Int)>>? {
      // Defines the standard transition condition for directed edges.
      var condition: (Vertex, Edge) -> Bool = { vertex, edge in
         edge.start == vertex
      }
      
      // Adds the transition condition if one has been passed.
      if let transitionCondition = transitionCondition {
         condition = { vertex, edge in
            condition(vertex, edge) && transitionCondition(vertex, edge)
         }
      }
      
      return breadthFirstSearch(from: start, transitioningBetween: condition)
   }
}
