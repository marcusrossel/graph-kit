//
//  Constrained Extensions.swift
//  GraphKit
//
//  Created by Marcus Rossel on 15.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Graph.Vertex: InitializableVertex

extension Graph where Graph.Vertex: InitializableVertex {
   
   /// Adds a vertex with a given value to the graph.
   ///
   /// Returns a boolean indicating whether the vertex was inserted, or was
   /// already part of the graph.
   @discardableResult
   public mutating func addVertex(withValue value: Value) -> Bool {
      // Creates a vertex from the value and tries to insert it.
      return insert(vertex: Vertex(value: value))
   }
   
   /// Creates an instance containing vertices created from given values.
   public init<S>(fromValues values: S) where S: Sequence, S.Element == Value {
      // Creates vertices from the given values, which are then passed to
      // `init(vertices:)`.
      let correspondingVertices = Set(values.map(Vertex.init(value:)))
      self.init(vertices: correspondingVertices)
   }
}

// MARK: - Graph.Value: Equatable

extension Graph where Graph.Value: Equatable {
   
   /// Returns the unique vertex in the graph with a given value.
   /// If such a vertex doesn't exist `nil` is returned.
   public func uniqueVertex(withValue value: Value) -> Vertex? {
      return uniqueVertex { $0.value == value }
   }
   
   /// Returns all of the vertices in the graph with given values.
   /// If any value has no corresponding vertex in the graph, `nil` is returned.
   public func vertices<S>(withValues values: S) -> Set<Vertex>?
   where S: Sequence, S.Element == Value {
      var verticesWithValues: Set<Vertex> = []
      
      for value in values {
         let verticesWithValue = vertices.filter { $0.value == value }
         
         // Checks if any vertex was found for the given value, and aborts the
         // procedure if not.
         guard !verticesWithValue.isEmpty else { return nil }
         verticesWithValues.formUnion(verticesWithValue)
      }
      
      return verticesWithValues
   }
   
   /// Removes all of the vertices with given values.
   /// This also removes all of the edges incident to those vertices.
   ///
   /// Returns the numbers of vertices and edges that were removed.
   /// If any value has no corresponding vertex in the graph, no edge is removed
   /// and `nil` is returned.
   @discardableResult
   public mutating func removeVertices<S>(withValues values: S) -> (vertices: Int, edges: Int)?
   where S: Sequence, S.Element == Value {
      // Gets the relevant vertices.
      guard let verticesWithValues = vertices(withValues: values) else { return nil }
      
      // Removes the vertices, and gets the number of edges that were removed as
      // a result.
      //#warning("Duplicate A.")
      //#warning("Create a method in `Table` to optimize for this.")
      let numberOfRemovedEdges = verticesWithValues.reduce(0) { sum, vertex in
         return sum + table.remove(safeVertex: vertex)
      }
      
      return (vertices.count, numberOfRemovedEdges)
   }
   
   /// Removes edges between all of the vertices with given values.
   ///
   /// Returns the number of edges that were removed.
   /// If any value has no corresponding vertex in the graph, no edge is removed
   /// and `nil` is returned.
   @discardableResult
   public mutating func removeEdgesBetweenVertices<S>(withValues values: S) -> Int?
   where S: Sequence, S.Element == Value {
      // Gets the relevant vertices.
      guard let verticesWithValues = vertices(withValues: values) else {
         return nil
      }
      
      //#warning("Brute force.")
      // Gets all of the edges to be removed.
      let relevantEdges = Set(verticesWithValues.flatMap(table.edges(forSafe:)))
      // Removes the relevant edges.
      relevantEdges.forEach { edge in table.remove(safeEdge: edge) }
      
      // Returns the number of edges that were removed.
      return relevantEdges.count
   }
}
