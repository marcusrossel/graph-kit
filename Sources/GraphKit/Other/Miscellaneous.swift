//
//  Miscellaneous.swift
//  GraphKit
//
//  Created by Marcus Rossel on 15.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Type/ Protocol Definitions

/// A protocol for classes whose semantics for equality are bound to their
/// identity.
///
/// The protocol provides default implementations for `==` and `hashValue`,
/// following those semantics.
public protocol IdentitySemantic: AnyObject { }

// Default implementations.
extension IdentitySemantic {
   
   /// Identity semantic types are considered equal iff they are identical.
   public static func ==(left: Self, right: Self) -> Bool {
      return left === right
   }
   
   /// As equalty is determined by identity, an identity semantic type's hash
   /// value is also determined by its identity.
   public var hashValue: Int { return ObjectIdentifier(self).hashValue }
}

/// A typealias currently needed to work around namespacing issues.
public typealias GraphKitVertex = Vertex

/// A typealias currently needed to work around namespacing issues.
public typealias GraphKitEdge = Edge

// MARK: - Methods

/// Turns a mutating method on a given `Type` into a non-mutating version.
internal func nonMutating<Type, Input, Output>(
   _ unboundMethod: @escaping (inout Type) -> (Input) -> Output,
   for instance: Type
) -> (Input) -> Type {
   // Creates a copy of the instance.
   var copy = instance
   
   // Binds the unbound mutating method to the given copy.
   let boundMethod = unboundMethod(&copy)
   
   // Creates a new method, that returns the result of mutating the copy for a
   // given input.
   return { (input: Input) -> Type in
      let _ = boundMethod(input)
      return copy
   }
}

/// A convenience method for making multiple calls to a mutating method that
/// reports on success or failure.
///
/// Returns the number of calls that returned `true`.
internal func successfulCalls<Type, S: Sequence>(
   of unboundMethod: (inout Type) -> (S.Element) -> Bool,
   with instance: inout Type, on sequence: S
) -> Int {
   let boundMethod = unboundMethod(&instance)
   
   return sequence.reduce(0) { successCounter, element in
      return successCounter + (boundMethod(element) ? 1 : 0)
   }
}
