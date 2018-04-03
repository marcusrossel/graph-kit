//
//  Vertex.swift
//  GraphKit
//
//  Created by Marcus Rossel on 18.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Protocols

/// A protocol for types that can be used as vertices within a `Graph`.
///
/// Having a value type, with "normal" equality semantics, conform to the
/// protocol will result in a graph that only supports vertices of different
/// `value`s.
/// Having a reference type, with identity for equality semantics, conform to
/// the protocol will result in a graph that supports multiple vertices with
/// equal values.
///
/// By default any type can conform to the protocol, by being its own `Value`
/// and its `value` being `self`.
public protocol VertexProtocol: Hashable {
   
   /// The type of value stored within the vertex.
   associatedtype Value
   
   /// The content/data/value stored within the vertex.
   var value: Value { get }
}

// Default implementation.
extension VertexProtocol {
   
   /// By default any type can be a vertex, and is therefore its own value.
   public var value: Self { return self }
}

/// A sub-protocol of `VertexProtocol` for vertices, that can be initialized
/// from their `value` alone.
///
/// Conforming to this protocol enables the use of more ergonomic methods on
/// `Graph`.
public protocol InitializableVertex: VertexProtocol {
   
   /// Creates an instance with the given value.
   init(value: Value)
}

// MARK: - Type

/// A vertex type for which each instance is unique.
///
/// `Vertex`s have identity, so that they are distinguishable even when they
/// have the same `value`.
public final class Vertex<Value> {
   
   /// The content/data/value stored within the vertex.
   public var value: Value
   
   /// Creates an instance with the given value.
   public convenience init(_ value: Value) { self.init(value: value) }
   
   // Needed for `VertexProtocol` conformance.
   /// Creates an instance with the given value.
   public init(value: Value) { self.value = value }
}

// Protocol conformances.
extension Vertex: InitializableVertex, IdentitySemantic, CustomStringConvertible {
   
   // `CustomStringConvertible` conformance.
   public var description: String {
      let id = String(Int(bitPattern: ObjectIdentifier(self)), radix: 16)
      return "<value: \(value), id: \(id)>"
   }
}
