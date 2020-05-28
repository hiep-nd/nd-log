//
//  NDLog.swift
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/27/20.
//  Copyright © 2020 Neodata Co., Ltd. All rights reserved.
//

public struct NDParameterKey: Hashable, Equatable, RawRepresentable {
  public init(_ rawValue: String) {
    self.init(rawValue: rawValue)
  }

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  public let rawValue: String
}

extension NDParameterKey {
  public static let level = NDParameterKey(kNDLogConfigLevel)
}

@discardableResult
public func nd_configure(paras: [NDParameterKey: Any]) -> Bool {
  return __NDLogConfigureWithParas(
    paras.reduce(
      into: [:],
      {
        switch $1.key {
        case .level:
          $0[$1.key.rawValue] = ($1.value is NDLogLevel)
            ? ($1.value as! NDLogLevel).rawValue : $1.value
        default:
          $0[$1.key.rawValue] = $1.value
        }
      }))
}

@discardableResult
public func nd_configure(name: String = "NDLog") -> Bool {
  return __NDLogConfigureWithName(name)
}

@inlinable
public func nd_log(
  error: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_log(
    message: error(), severity: .error, function: function, file: file,
    line: line, tag: tag)
}

@inlinable
public func nd_log(
  warning: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_log(
    message: warning(), severity: .warning, function: function, file: file,
    line: line, tag: tag)
}

@inlinable
public func nd_log(
  info: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_log(
    message: info(), severity: .info, function: function, file: file,
    line: line, tag: tag)
}

@inlinable
public func nd_log(
  debug: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_log(
    message: debug(), severity: .debug, function: function, file: file,
    line: line, tag: tag)
}

@inlinable
public func nd_log(
  verbose: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_log(
    message: verbose(), severity: .verbose, function: function, file: file,
    line: line, tag: tag)
}

@inlinable
public func nd_log(
  message: @autoclosure () -> String, severity: NDLogSeverity,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  __NDLogMessage(
    message(), severity, String(describing: file), String(describing: function),
    line, tag)
}

@inlinable
public func nd_assert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = String(),
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  let cond = condition()
  if !cond {
    let mesg = message()
    let logMesg = mesg.count > 0
      ? "Failure assertion. \(mesg)" : "Failure assertion."
    nd_log(error: logMesg, function: function, file: file, line: line, tag: tag)
    Swift.assertionFailure(logMesg, file: file, line: line)
  }
}
