//
//  Edge.Simple.swift
//  GraphKit
//
//  Created by Marcus Rossel on 15.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Protocol

/// A sub-protocol of `EdgeProtocol` for simple edges.
public protocol SimpleEdge: EdgeProtocol {
   
   /// An initializer that creates a simple edge from its vertices alone.
   init(vertices: (Vertex, Vertex))
}

// MARK: - Type

extension Edge {
   
   /// An unweighted undirected edge, that can be used within a `Graph`.
   public struct Simple<Vertex>: SimpleEdge where Vertex: VertexProtocol {
      
      /// The edge's vertices.
      public private(set) var vertices: (Vertex, Vertex)
      
      /// Creates an edge between given vertices.
      public init(vertices: (Vertex, Vertex)) { self.vertices = vertices }
   }
}

// MARK: - Conformances

extension Edge.Simple: Equatable, Hashable {
   
   // `Edge.Simple`s are considered equal iff they contain the same vertices.
   public static func == (lhs: Edge.Simple<Vertex>, rhs: Edge.Simple<Vertex>) -> Bool {
      return lhs.vertices == rhs.vertices ||
         lhs.vertices == (rhs.vertices.1, rhs.vertices.0)
   }
   
   public var hashValue: Int {
      //#warning("Ad hoc hash function.")
      return vertices.0.hashValue ^ vertices.1.hashValue
   }
}

extension Edge.Simple: CustomStringConvertible {
   
   /// A string description of the edge.
   public var description: String {
      return "〚\(vertices.0)--\(vertices.1)〛"
   }
}

extension Edge.Simple: ExpressibleByArrayLiteral
where Vertex: InitializableVertex {
   
   /// The type of element used when initializing an `Edge.Simple` from an array
   /// literal.
   public typealias ArrayLiteralElement = Vertex.Value
   
   /// A simple edge can only be initialized from exactly two values.
   /// If this condition is not met, the initializer causes a crash.
   public init(arrayLiteral elements: Vertex.Value...) {
      precondition(
         elements.count == 2,
         "An `Edge.Simple` must be initialized from exactly two values."
      )
      
      // Creates vertices from the given values.
      // Forced unwrapping is used as `elements` is known to contain two
      // elements.
      let first = Vertex(value: elements.first!)
      let second = Vertex(value: elements.last!)
      
      self.init(vertices: (first, second))
   }
}
