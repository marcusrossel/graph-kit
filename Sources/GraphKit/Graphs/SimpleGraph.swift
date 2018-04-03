//
//  SimpleGraph.swift
//  GraphKit
//
//  Created by Marcus Rossel on 23.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A `Graph` that uses `Edge.Simple`s
public typealias SimpleGraph<Value> = Graph<Edge<Value>.Simple>

extension Graph where Edge: SimpleEdge {
   
   /// Returns a graph representing the search-tree attained from performing a
   /// breadth first search starting at a given vertex.
   ///
   /// If the given vertex is not part of the graph, `nil` is returned.
   public func breadthFirstSearch(from start: Vertex) -> SimpleGraph<(Vertex, Int)>? {
      // Checks if the given vertex is even part of the graph.
      guard vertices.contains(start) else { return nil }
      
      // A container keeping track of the vertices that have been visited.
      // The start vertex is implicitly visited.
      var visited: Set<Vertex> = [start]
      
      // A lookup table for a vertex' distance from the start vertex.
      // The start vertex' distance is implicitly 0.
      var distances: [Vertex: Int] = [start: 0]
      
      // Initializes the search tree with the start vertex as its "root".
      var searchTree: SimpleGraph<(Vertex, Int)> = [(start, 0)]
      
      // Initializes the queue with the start vertex.
      var queue: Queue<Vertex> = [start]
      
      // Begins the breadth first search.
      while !queue.isEmpty {
         // Gets the next vertex to be processed.
         let currentVertex = queue.dequeue()
         
         // Gets the vertex' distance.
         // Forced unwrapping is used as any `currentVertex` must have
         // already been visited, and therefore have a set distance.
         let currentDistance = distances[currentVertex]!
         
         for adjacentVertex in adjacentVertices(for: currentVertex)! {
            // If the adjacent vertex has not yet been visited, relevant
            // attributes need to be set.
            if !visited.contains(adjacentVertex) {
               // Marks the adjacent vertex as visited.
               visited.insert(adjacentVertex)

               // Gets the distance of the adjacent vertex.
               let adjacentDistance = currentDistance + 1
               
               // Sets the adjacent vertex' distance.
               distances[adjacentVertex] = adjacentDistance
               
               // Creates an edge between parent `currentVertex` and child
               // `adjacentVertex`.
               let searchTreeConnection: GraphKitEdge<(Vertex, Int)>.Simple = [
                  GraphKitVertex((currentVertex, currentDistance)),
                  GraphKitVertex((adjacentVertex, adjacentDistance))
               ]
               
               // Adds the adjacent vertex to the search tree.
               searchTree.addVertex(withValue: (adjacentVertex, adjacentDistance))
               
               // Connects parent and child in the search tree.
               searchTree.insert(edge: searchTreeConnection)
               
               // Adds the adjacent edge to the queue.
               queue.enqueue(adjacentVertex)
            }
         }
      }
      
      return searchTree
   }
   
   /// Returns a graph representing the search-tree attained from performing a
   /// depth first search starting at a given vertex.
   ///
   /// If the given vertex is not part of the graph, `nil` is returned.
   public func depthFirstSearch(from start: Vertex) -> SimpleGraph<(Vertex, Int)>? {
      guard vertices.contains(start) else { return nil }
      
      return nil
   }
   
}
