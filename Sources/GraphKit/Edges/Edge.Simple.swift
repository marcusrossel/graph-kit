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
   public final class Simple: Edge {
      
      /// Creates an between given vertices.
      public init(vertices: (Vertex, Vertex)) {
         super.init(vertices.0, vertices.1)
      }
   }
}

// Protocol conformances.
extension Edge.Simple: SimpleEdge, ExpressibleByArrayLiteral {
   
   /// A simple edge can only be initialized from exaclty two vertices.
   /// If this condition is not met, the initializer causes a crash.
   public convenience init(arrayLiteral elements: Vertex...) {
      assert(elements.count == 2, "An `Edge.Simple` must be initialized from exactly two vertices.")
      
      // Forced unwrapping is used as `elements` is known to contain two
      // elements.
      self.init(vertices: (elements.first!, elements.last!))
   }
}
