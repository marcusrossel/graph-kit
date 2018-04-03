//
//  Queue.swift
//  GraphKit
//
//  Created by Marcus Rossel on 03.04.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A simple (FIFO) queue data type used internally in GraphKit.
internal struct Queue<Element> {
   
   // The underlying storage.
   private var storage: [Element]
   
   /// Returns a boolean value indicating whether the queue is empty or not.
   public var isEmpty: Bool { return storage.isEmpty }
   
   /// Adds a given element to the end of the queue.
   public mutating func enqueue(_ element: Element) { storage.append(element) }
   
   /// Removes and returns the element at the start of the queue.
   ///
   /// The queue must be non-empty, or else a runtime error occurs.
   public mutating func dequeue() -> Element { return storage.remove(at: 0) }
   
   /// Creates an instance containing no elements.
   public init() { storage = [] }
}

extension Queue: ExpressibleByArrayLiteral {
   
   /// Creates a queue from a given array literal.
   init(arrayLiteral elements: Element...) { storage = elements }
}
