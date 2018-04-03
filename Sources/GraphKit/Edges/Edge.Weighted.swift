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

// MARK: - Class

extension Edge {

   /// A weighted undirected subclass of `Edge`.
   public final class Weighted<Weight>: Edge where Weight: Hashable {
      
      /// The edge's weight.
      public private(set) var weight: Weight
      
      /// Creates an instance with the given vertices.
      public init(_ first: Vertex, _ second: Vertex, weight: Weight) {
         self.weight = weight
         super.init(first, second)
      }
      
      // MARK: - Overridable Extensions
      
      public override var description: String {
         return "〚\(vertices.0)--[\(weight)]--\(vertices.1)〛"
      }
   }
}

// Protocol conformances.
extension Edge.Weighted: WeightedEdge { }
