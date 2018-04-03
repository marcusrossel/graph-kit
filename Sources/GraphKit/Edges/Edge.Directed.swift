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
   public final class Directed: Edge {
      
      /// The edge's start-vertex.
      public private(set) var start: Vertex {
         get { return vertices.0 }
         set { vertices.0 = newValue }
      }
      
      /// The edge's end-vertex.
      public private(set) var end: Vertex {
         get { return vertices.1 }
         set { vertices.1 = newValue }
      }
      
      /// Creates an instance with the given vertices.
      public init(start: Vertex, end: Vertex) {
         super.init(start, end)
         self.start = start
         self.end = end
      }
      
      /// Changes the direction of the edge, by making its `start` its `end` and
      /// vice versa.
      public func reverse() { (start, end) = (end, start) }
      
      // MARK: - Overridable Extensions
      
      public override var description: String {
         return "〚\(start)-->\(end)〛"
      }
   }
}

// Protocol conformances.
extension Edge.Directed: DirectedEdge, ExpressibleByArrayLiteral {
   
   /// A directed edge can only be initialized from exaclty two vertices.
   /// If this condition is not met, the initializer causes a crash.
   public convenience init(arrayLiteral elements: Vertex...) {
      assert(elements.count == 2, "An `Edge.Directed` must be initialized from exactly two vertices.")
      
      // Forced unwrapping is used as `elements` is known to contain two
      // elements.
      self.init(start: elements.first!, end: elements.last!)
   }
}

