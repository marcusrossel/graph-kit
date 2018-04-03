//
//  Edge.swift
//  GraphKit
//
//  Created by Marcus Rossel on 13.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Protocol

/// A protocol for types that can be used as edges within a `Graph`.
///
/// Having a value type, with "normal" equality semantics, conform to the
/// protocol will result in a graph that does not support multiple equal edges
/// between two vertices.
/// Having a reference type, with identity for equality semantics, conform to
/// the protocol will result in a graph that supports multiple equal edges
/// between two vertices.
public protocol EdgeProtocol: Hashable {
   
   /// The type of vertex used by the edge.
   associatedtype Vertex: VertexProtocol
   
   /// The edge's vertices.
   var vertices: (Vertex, Vertex) { get }
}

// Default implementations.
extension EdgeProtocol {
   
   /// Indicates whether the given vertex is one of the edge's endpoints.
   public func isIncident(to vertex: Vertex) -> Bool {
      return vertices.0 == vertex || vertices.1 == vertex
   }
   
   /// Indicates whether either of the edge's vertices satisfies a given
   /// condition.
   public func isIncidentToVertex(where condition: (Vertex) -> Bool) -> Bool {
      return condition(vertices.0) || condition(vertices.1)
   }
   
   /// Indicates whether this edge is connected to a given edge by at least one
   /// vertex.
   public func isAdjacent(to edge: Self) -> Bool {
      return edge.isIncident(to: vertices.0) || edge.isIncident(to: vertices.1)
   }
}

// MARK: - Type

/// An edge that can be used within a `Graph`.
///
/// `Edge`s have identity semantics, so that a graph can contain multiple
/// between the same vertices.
public class Edge<Value> {
   
   /// The vertex type used by `Edge`.
   public typealias Vertex = GraphKitVertex<Value>
   
   /// The edge's vertices.
   public internal(set) var vertices: (Vertex, Vertex)
   
   /// Creates an instance with the given vertices.
   internal init(_ first: Vertex, _ second: Vertex) {
      vertices = (first, second)
   }
   
   // MARK: - Overridable Extensions
   
   // `CustomStringConvertible` conformance.
   public var description: String {
      return "〚\(vertices.0)--\(vertices.1)〛"
   }
}

// Protocol conformances.
extension Edge: EdgeProtocol, IdentitySemantic, CustomStringConvertible { }

// Additional methods when the vertex' value is equatable.
extension Edge where Value: Equatable {
   
   /// Indicates whether either of the edge's vertices contains a given value.
   public func isIncidentToVertex(withValue value: Value) -> Bool {
      return vertices.0.value == value || vertices.1.value == value
   }
}
