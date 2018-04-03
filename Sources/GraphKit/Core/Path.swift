//
//  Path.swift
//  GraphKit
//
//  Created by Marcus Rossel on 23.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

extension Graph {
   
   /// A sequence of adjacent edges in a graph.
   public struct Path: Equatable {
      
      /// The sequence of edges representing the path.
      public private(set) var edges: [Edge]
      
      public var isEmpty: Bool { return edges.isEmpty }
      
      public var length: Int { return edges.count }
   }
}

// MARK: - Extensions

/*
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
*/

// MARK: - Conformances

extension Graph.Path: Sequence {
   
   /// The iterator used by a `Graph.Path` to generate its sequence.
   public typealias Iterator = Array<Edge>.Iterator
   
   /// Creates the path's iterator.
   public func makeIterator() -> Iterator { return edges.makeIterator() }
}

extension Graph.Path: Collection {
   
   /// The type used by a `Graph.Path` to index it as a collection.
   public typealias Index = Array<Edge>.Index
   
   /// The path's start index.
   public var startIndex: Index { return edges.startIndex }
   
   /// The path's end index.
   public var endIndex: Index { return edges.endIndex }
   
   /// Returns the element at a given index.
   public subscript(position: Index) -> Iterator.Element {
      return edges[position]
   }
   
   /// Returns the index after a given index.
   public func index(after index: Index) -> Index {
      return edges.index(after: index)
   }
}
