//
//  Edge.Weighted.swift
//  GraphKit
//
//  Created by Marcus Rossel on 25.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Protocol

/// An `EdgeProtocol` sub-protocol for weighted edges.
public protocol WeightedEdge: EdgeProtocol {
   
   /// The type of weight used by the edge.
   associatedtype Weight: Hashable
   
   /// The edge's weight.
   var weight: Weight { get }
}

// MARK: - Type

extension Edge {

   /// A weighted undirected subclass of `Edge`.
   public struct Weighted<Vertex, Weight>: WeightedEdge
   where Vertex: VertexProtocol, Weight: Hashable {
      
      /// The edge's vertices.
      public var vertices: (Vertex, Vertex)
      
      /// The edge's weight.
      public private(set) var weight: Weight
      
      /// Creates an instance with the given vertices.
      public init(_ first: Vertex, _ second: Vertex, weight: Weight) {
         vertices = (first, second)
         self.weight = weight
      }
   }
}

extension Edge.Weighted: Equatable, Hashable {
   
   // `Edge.Weighted`s are considered equal iff they contain the same vertices
   // and weight.
   public static func == (lhs: Edge.Weighted<Vertex, Weight>, rhs: Edge.Weighted<Vertex, Weight>) -> Bool {
      return lhs.weight == rhs.weight &&
             (lhs.vertices == rhs.vertices ||
             lhs.vertices == (rhs.vertices.1, rhs.vertices.0))
   }
   
   public var hashValue: Int {
      //#warning("Ad hoc hash function.")
      return vertices.0.hashValue ^ vertices.1.hashValue
   }
}

extension Edge.Weighted: CustomStringConvertible {
   
   /// A string description of the edge.
   public var description: String {
      return "〚\(vertices.0)--[\(weight)]--\(vertices.1)〛"
   }
}
