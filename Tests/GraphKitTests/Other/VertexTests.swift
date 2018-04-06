//
//  VertexTests.swift
//  GraphKitTests
//
//  Created by Marcus Rossel on 04.04.18.
//

import XCTest

final class VertexTests: XCTestCase {
   
   // MARK: - VertexProtocol
   
   func testVertexProtocol() {
      let v: TestVertex = .a
      
      XCTAssertEqual(v.value, .a)
   }
   
   // MARK: - GraphKitVertex
   
   func testInitialization() {
      let v0 = Vertex(value: 0)
      let v1 = Vertex("1")
      
      XCTAssertEqual(v0.value, 0)
      XCTAssertEqual(v1.value, "1")
   }
   
   func testEquality() {
      let v0A = Vertex(0)
      let v0B = Vertex(0)
      let v1 = Vertex(1)
      
      XCTAssertEqual(v0A, v0A)
      XCTAssertNotEqual(v0A, v0B)
      XCTAssertNotEqual(v0A, v1)
   }
   
   // MARK: - Package Support
   
   static var allTests = [
      ("testInitialization", testInitialization),
      ("testEquality", testEquality),
      ("testVertexProtocol", testVertexProtocol),
   ]
}
