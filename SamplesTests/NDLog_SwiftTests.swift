//
//  NDLog_SwiftTests.swift
//  NDLog_SwiftTests
//
//  Created by Nguyen Duc Hiep on 6/25/20.
//  Copyright © 2020 Nguyen Duc Hiep. All rights reserved.
//

import XCTest

@testable import NDLog

protocol MockClosureResult {
  init()
}

extension Bool: MockClosureResult {}
extension String: MockClosureResult {}

class MockClosure<T: MockClosureResult> {
  var callCount = 0
  var result = T()

  func reset(result: T = T()) {
    callCount = 0
    self.result = result
  }

  var closure: (() -> T) {
    return { [weak self] in
      guard let strongSelf = self else { return T() }
      strongSelf.callCount += 1
      return strongSelf.result
    }
  }
}

// swiftlint:disable:next type_name
class NDLog_SwiftTests: XCTestCase {
  let condition = MockClosure<Bool>()
  let message = MockClosure<String>()
  let tag = MockClosure<String>()

  override func setUp() {
    super.setUp()
    condition.reset()
    message.reset()
    tag.reset()
  }

  func test_Config() throws {
    XCTAssertTrue(nd_configureLog(paras: [.level: NDLogLevel.warning]))
    XCTAssertEqual(NDLogLevel.warning, definedLogLevel())
  }

  func test_Config_invalid() throws {
    if _isDebugAssertConfiguration() {
    } else {
      XCTAssertFalse(nd_configureLog(paras: [.level: "Error"]))
      XCTAssertEqual(NDLogLevel.error, definedLogLevel())
    }
  }

  func test_Assert_failure() throws {
    nd_assert(condition.closure(), message.closure(), tag: tag.closure())
    XCTAssert(condition.callCount == 1)
    XCTAssert(message.callCount == 1)
    XCTAssert(tag.callCount == 1)
  }

  func test_Assert_true() throws {
    condition.reset(result: true)
    nd_assert(condition.closure(), message.closure())
    XCTAssert(message.callCount == 0)
    XCTAssert(tag.callCount == 0)
  }

  func test_LogError() throws {
    nd_log(error: "Error message.")
  }

  func test_LogWarning() throws {
    nd_log(warning: "Warning message.")
  }

  func test_LogInfo() throws {
    nd_log(info: "Info message.")
  }

  func test_LogDebug() throws {
    nd_log(info: "Debug message.")
  }

  func test_LogVerbose() throws {
    nd_log(verbose: "Verbose message.")
  }

  func test_LogTagError() {
    nd_log(error: "Error message.", tag: "#tag")
  }

  func test_Assert() {
    nd_assert(true, "Assert message.", tag: "#tag")
    nd_assert(false, "Assert message.", tag: "#tag")
  }

  func test_AssertionFailure() {
    nd_assertionFailure("Assertion failure message.", tag: "#tag")
  }

  func test_DAssert() {
    nd_dassert(true, "DAssert message.", tag: "#tag")
    nd_dassert(false, "DAssert message.", tag: "#tag")
  }

  func test_DAssertionFailure() {
    nd_dassertionFailure("DAssertion failure message.", tag: "#tag")
  }

  func test_FatalError() {
    nd_fatalError("Fatal error message.", tag: "#tag")
  }
}
