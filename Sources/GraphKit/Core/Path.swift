//
//  Path.swift
//  GraphKit
//
//  Created by Marcus Rossel on 23.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

extension Graph {
   
   /// A sequence of edges adjacent edges in a graph.
   public struct Path {
      
      /// The sequence of edges representing the path.
      public private(set) var edges: [Edge]
      
      public var isEmpty: Bool { return edges.isEmpty }
      
      public var length: Int { return edges.count }
   }
}

extension Graph.Path where Edge: SimpleEdge {
   
   public var isClosed: Bool {
      /*#warning("Complete")*/return true
   }
   
   init<S>(_ sequence: S) where S: Sequence, S.Element == Edge {
      /*#warning("Complete")*/edges = []
   }
   
   public func add(edge: Edge) { }
   
}

extension Graph.Path where Edge: WeightedEdge {
   
   public var isClosed: Bool {
      /*#warning("Complete")*/return true
   }
   
   init<S>(_ sequence: S) where S: Sequence, S.Element == Edge {
      /*#warning("Complete")*/edges = []
   }
   
   public func add(edge: Edge) { }
   
}

extension Graph.Path where Edge: DirectedEdge {
   
   public var isClosed: Bool {
      /*#warning("Complete")*/return true
   }
   
   init<S>(_ sequence: S) where S: Sequence, S.Element == Edge {
      /*#warning("Complete")*/edges = []
   }
   
   public func add(edge: Edge) { }
   
}
