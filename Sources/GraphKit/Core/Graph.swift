//
//  Graph.swift
//  Graph
//
//  Created by Marcus Rossel on 20.08.17.
//  Copyright © 2017 Marcus Rossel. All rights reserved.
//

/// A type representing a network of vertices connected by edges.
///
/// `Graph` is generic (except for constraints) over the types of its vertices
/// and edges.
/// The `VertexProtocol`, `EdgeProtocol` and their sub-protocols provide the
/// interface for adding types to be used with `Graph`.
public struct Graph<Edge: EdgeProtocol> {
   
   // MARK: - Type Declarations
   
   /// The type of vertex used by the graph.
   public typealias Vertex = Edge.Vertex
   
   /// The type of value stored in the graph's vertices.
   public typealias Value = Vertex.Value
   
   /// A sequence type used by `Graph` to expose its vertices.
   ///
   /// This allows for faster access of certain properties.
   public typealias Vertices = Dictionary<Vertex, Set<Table.Index>>.Keys
   
   /// A sequence type used by `Graph` to expose its edges.
   ///
   /// This allows for faster access of certain properties.
   public typealias Edges = Dictionary<Edge, Table.Index>.Keys
   
   // MARK: - Properties
   
   // A custom type managing all of the vertices and edges in the graph.
   internal var table: Table
   
   /// A sequence of all of the vertices in the graph.
   public var vertices: Vertices { return table.vertexTable.keys }
   
   /// A sequence of all of the edges in the graph.
   public var edges: Edges { return table.edgeIndexMap.keys }
   
   /// Indicates whether or not the graph contains any vertices or edges.
   ///
   /// An absence of vertices automatically implies an absence of edges.
   public var isEmpty: Bool { return vertices.count == 0 }
   
   // MARK: - Initializers
   
   /// Creates an instance with no vertices or edges.
   public init() { self.init(vertices: []) }
   
   /// Creates an instance containing given vertices.
   public init<S>(vertices: S) where S: Sequence, S.Element == Vertex {
      table = Table(vertices: vertices)
   }
}

// MARK: - Vertex Methods

extension Graph {
   /// Returns the unique vertex in the graph satisfying a given condition.
   /// If such a vertex doesn't exist `nil` is returned.
   public func uniqueVertex(where condition: (Vertex) -> Bool) -> Vertex? {
      var uniqueVertex: Vertex?
      
      // Goes through all vertices in the graph, checking if any satisfy the
      // condition.
      for vertex in vertices {
         if condition(vertex) {
            // If a satisfying vertex was already found, there are multiple
            // vertices satistying the condition and `nil` is returned.
            guard uniqueVertex == nil else { return nil }
            uniqueVertex = vertex
         }
      }
      
      return uniqueVertex
   }
   
   /// Returns all of the vertices in the graph that satisfy a given condition.
   public func vertices(where condition: (Vertex) -> Bool) -> Set<Vertex> {
      return Set(vertices.filter(condition))
   }
   
   /// Returns the vertices adjacent to a given vertex.
   internal func adjacentVertices(for vertex: Vertex) -> [Vertex]? {
      // Checks if the vertex is safe.
      guard vertices.contains(vertex) else { return nil }
      
      return table.adjacentVertices(forSafe: vertex)
   }
   
   /// Inserts a given vertex into the graph.
   ///
   /// Returns a boolean indicating whether the vertex was inserted, or was
   /// already part of the graph.
   @discardableResult
   public mutating func insert(vertex: Vertex) -> Bool {
      // Checks if the vertex is safe to insert.
      guard !vertices.contains(vertex) else { return false }
      
      table.insert(safeVertex: vertex)
      return true
   }
   
   /// Inserts a given vertex into the graph.
   ///
   /// Returns the number of vertices that were actually inserted.
   @discardableResult
   public mutating func insert<S>(vertices: S) -> Int
   where S: Sequence, S.Element == Vertex {
      return successfulCalls(of: Graph.insert(vertex:), with: &self, on: vertices)
   }
   
   /// Removes a vertex from the graph.
   /// This also removes all of the edges incident to the vertex.
   ///
   /// Returns a boolean indicating whether a vertex was actually removed.
   @discardableResult
   public mutating func remove(vertex: Vertex) -> Bool {
      // Checks if the vertex is safe to remove.
      guard vertices.contains(vertex) else { return false }
      
      table.remove(safeVertex: vertex)
      return true
   }
   
   /// Removes a given sequence of vertices from the graph.
   ///
   /// Returns the number of vertices that were actually removed.
   @discardableResult
   public mutating func remove<S>(vertices: S) -> Int
   where S: Sequence, S.Element == Vertex {
      return successfulCalls(of: Graph.remove(vertex:), with: &self, on: vertices)
   }
   
   /// Removes all of the vertices satisfying a given condition.
   /// This also removes all of the edges incident to those vertices.
   ///
   /// Returns the numbers of vertices and edges that were removed.
   @discardableResult
   public mutating func removeVertices(where condition: (Vertex) -> Bool) -> (vertices: Int, edges: Int) {
      // Gets all of the vertices satisfying the given condition.
      let satisfyingVertices = vertices.filter(condition)
      
      // Removes the vertices, and gets the number of edges that were removed as
      // a result.
      //#warning("Duplicate A.")
      let numberOfRemovedEdges = satisfyingVertices.reduce(0) { sum, vertex in
         return sum + table.remove(safeVertex: vertex)
      }
      
      return (satisfyingVertices.count, numberOfRemovedEdges)
   }
}

// MARK: - Edge Methods

extension Graph {
   
   /// Inserts an edge into the graph.
   ///
   /// Returns a boolean indicating whether the edge was inserted, or was
   /// already part of the graph.
   @discardableResult
   public mutating func insert(edge: Edge) -> Bool {
      // Checks if the edge is safe to insert.
      guard
         vertices.contains(edge.vertices.0) &&
         vertices.contains(edge.vertices.1) &&
         !edges.contains(edge)
      else { return false }
      
      table.insert(safeEdge: edge)
      return true
   }
   
   /// Inserts a sequence of edges into the graph.
   ///
   /// Returns the number of edges that were actually inserted.
   @discardableResult
   public mutating func insert<S>(edges: S) -> Int
   where S: Sequence, S.Element == Edge {
      return successfulCalls(of: Graph.insert(edge:), with: &self, on: edges)
   }
   
   //#warning("Implement!")
   public mutating func connect(vertices: (Vertex, Vertex), by edgeGenerator: (Vertex, Vertex) -> Edge) {
      
   }
   
   /// Removes a given edge from the graph.
   ///
   /// Returns a boolean indicating whether or not an edge was actually removed.
   @discardableResult
   public mutating func remove(edge: Edge) -> Bool {
      // Checks if the edge is safe to remove.
      guard edges.contains(edge) else { return false }
      
      table.remove(safeEdge: edge)
      return true
   }
   
   /// Removes a given sequence of edges from the graph.
   ///
   /// Returns the number of edges that were actually removed.
   @discardableResult
   public mutating func remove<S>(edges: S) -> Int
   where S: Sequence, S.Element == Edge {
      return successfulCalls(of: Graph.remove(edge:), with: &self, on: edges)
   }
   
   /// Removes all of the edges that satisfy a given condition.
   ///
   /// Returns the number of edges that were removed.
   @discardableResult
   public mutating func removeEdges(where condition: (Edge) -> Bool) -> Int {
      // Gets all of the edges satisfying the given condition.
      let satisfyingEdges = edges.filter(condition)
      
      // Removes all of the satisfying edges.
      //#warning("Create a method in `Table` to optimize for this.")
      satisfyingEdges.forEach { edge in table.remove(safeEdge: edge) }
      
      return satisfyingEdges.count
   }
}

// MARK: - Vertex/Edge Methods

extension Graph {
   
   /// Returns the number of edges connected to the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func degree(of vertex: Vertex) -> Int? {
      guard vertices.contains(vertex) else { return nil }
      return table.degree(ofSafe: vertex)
   }
   
   /// Returns the edges connected to the vertex in the graph.
   /// If the vertex is not part of the graph `nil` is returned.
   public func edges(for vertex: Vertex) -> [Edge]? {
      guard vertices.contains(vertex) else { return nil }
      return table.edges(forSafe: vertex)
   }
   
   /// Removes all vertices and edges from the graph.
   public mutating func removeAll(keepingCapacity: Bool = false) {
      table.removeAll(keepingCapacity: keepingCapacity)
   }
}
