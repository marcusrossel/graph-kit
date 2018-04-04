//
//  Edge.Directed.swift
//  GraphKit
//
//  Created by Marcus Rossel on 16.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Protocol

/// A sub-protocol of `EdgeProtocol` for directed edges.
public protocol DirectedEdge: EdgeProtocol {
   
   /// The edge's start-vertex.
   var start: Vertex { get }
   
   /// The edge's end-vertex.
   var end: Vertex { get }
}

// Default implementations.
extension DirectedEdge {
   
   /// Indicates whether the edge's end vertex is the starting vertex of a given
   /// edge.
   public func isPredecessor(of edge: Self) -> Bool {
      return end == edge.start
   }
   
   /// Indicates whether the edge's starting vertex is the end vertex of a given
   /// edge.
   public func isSuccessor(of edge: Self) -> Bool {
      return start == edge.end
   }
}

// MARK: - Types

extension Edge {
   
   /// An unweighted directed subclass of `Edge`.
   public struct Directed<Vertex>: DirectedEdge, Equatable, Hashable
   where Vertex: VertexProtocol {
      
      /// The edge's start-vertex.
      public private(set) var start: Vertex
      
      /// The edge's end-vertex.
      public private(set) var end: Vertex
      
      /// The edge's vertices.
      public var vertices: (Vertex, Vertex) { return (start, end) }
      
      /// Creates an instance with the given vertices.
      public init(start: Vertex, end: Vertex) {
         (self.start, self.end) = (start, end)
      }
      
      /// Changes the direction of the edge, by making its `start` its `end` and
      /// vice versa.
      public mutating func invert() { (start, end) = (end, start) }
   }
}

// MARK: - Conformances

extension Edge.Directed: CustomStringConvertible {
   
   /// A string description of the edge.
   public var description: String {
      return "〚\(start)-->\(end)〛"
   }
}

extension Edge.Directed: ExpressibleByArrayLiteral
where Vertex: InitializableVertex {
   
   /// The type of element used when initializing an `Edge.Simple` from an array
   /// literal.
   public typealias ArrayLiteralElement = Vertex.Value
   
   /// A directed edge can only be initialized from exaclty two values.
   /// If this condition is not met, the initializer causes a crash.
   public init(arrayLiteral elements: Vertex.Value...) {
      precondition(
         elements.count == 2,
         "An `Edge.Directed` must be initialized from exactly two values."
      )
      
      // Creates vertices from the given values.
      // Forced unwrapping is used as `elements` is known to contain two
      // elements.
      let first = Vertex(value: elements.first!)
      let second = Vertex(value: elements.last!)
      
      self.init(start: first, end: second)
   }
}
