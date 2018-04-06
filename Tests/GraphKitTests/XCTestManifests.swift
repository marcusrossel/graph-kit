import XCTest
@testable import GraphKit

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
   return [
      testCase(TableTests.allTests),
      testCase(VertexTests.allTests),
   ]
}
#endif
