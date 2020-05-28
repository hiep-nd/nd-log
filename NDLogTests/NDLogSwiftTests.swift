//
//  NDLogSwiftTests.swift
//  NDLogSwiftTests
//
//  Created by Nguyen Duc Hiep on 5/28/20.
//  Copyright © 2020 Neodata Co., Ltd. All rights reserved.
//

import NDLog
import XCTest

class NDLogSwiftTests: XCTestCase {
  func test_Config() throws {
    XCTAssertTrue(nd_configure(paras: [.level: NDLogLevel.warning]))
    XCTAssertEqual(NDLogLevel.warning, definedLogLevel())
  }

  func test_Config_invalid() throws {
    if _isDebugAssertConfiguration() {
    } else {
      XCTAssertFalse(nd_configure(paras: [.level: "Error"]))
      XCTAssertEqual(NDLogLevel.error, definedLogLevel())
    }
  }

  func test_Assert() throws {
    nd_assert(true)
  }

  func test_LogError() throws {
    nd_log(error: "Error message")
  }

  func test_LogWarning() throws {
    nd_log(warning: "Warning message")
  }

  func test_LogInfo() throws {
    nd_log(info: "Info message")
  }

  func test_LogDebug() throws {
    nd_log(info: "Debug message")
  }

  func test_LogVerbose() throws {
    nd_log(verbose: "Verbose message")
  }

  func test_LogTagError() {
    nd_log(error: "Error message", tag: "mylog")
  }
}
