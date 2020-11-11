//
//  NDLog.swift
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/27/20.
//  Copyright © 2020 Nguyen Duc Hiep. All rights reserved.
//

@discardableResult
public func nd_configureLog(paras: [NDLogParameterKey: Any]) -> Bool {
  return __NDLogConfigureWithParas(
    paras.reduce(into: [:]) {
      switch $1.key {
      case .level:
        $0[$1.key] =
          ($1.value is NDLogLevel)
          // swiftlint:disable:next force_cast
          ? ($1.value as! NDLogLevel).rawValue : $1.value
      default:
        $0[$1.key] = $1.value
      }
    })
}

@discardableResult
public func nd_configureLog(name: String = "NDLog") -> Bool {
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
    severity: .error,
    message: error(),
    function: function,
    file: file,
    line: line,
    tag: tag
  )
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
    severity: .warning,
    message: warning(),
    function: function,
    file: file,
    line: line,
    tag: tag
  )
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
    severity: .info,
    message: info(),
    function: function,
    file: file,
    line: line,
    tag: tag
  )
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
    severity: .debug,
    message: debug(),
    function: function,
    file: file,
    line: line,
    tag: tag
  )
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
    severity: .verbose,
    message: verbose(),
    function: function,
    file: file,
    line: line,
    tag: tag
  )
}

@inlinable
public func nd_log(
  severity: NDLogSeverity,
  message: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  if (definedLogLevel().rawValue & severity.rawValue) != 0 {
    __NDLogMessage(
      severity,
      message(),
      String(describing: file),
      String(describing: function),
      line,
      tag
    )
  }
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
  // swiftlint:disable:next trailing_closure
  _nd_assert(
    condition(),
    message(),
    function: function,
    file: file,
    line: line,
    tag: tag,
    // swiftlint:disable:next multiline_arguments
    failureHandlers: nd_log(error:function:file:line:tag:), { message, _, file, line, _ in
      Swift.assertionFailure(message(), file: file, line: line)
    }
  )
}

@inlinable
public func nd_assertionFailure(
  _ message: @autoclosure () -> String = String(),
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_assert(
    false, message(), function: function, file: file, line: line, tag: tag)
}

@inlinable
public func nd_dassert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = String(),
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  #if DEBUG
  // swiftlint:disable:next trailing_closure
  _nd_assert(
    condition(),
    message(),
    function: function,
    file: file,
    line: line,
    tag: tag,
    // swiftlint:disable:next multiline_arguments
    failureHandlers: nd_log(error:function:file:line:tag:), { _, _, _, _, _ in
      raise(SIGTRAP)
    }
  )
  #else
    _nd_assert(
      condition(),
      message(),
      function: function,
      file: file,
      line: line,
      tag: tag,
      failureHandlers: nd_log(error:function:file:line:tag:)
    )
  #endif
}

@inlinable
public func nd_dassertionFailure(
  _ message: @autoclosure () -> String = String(),
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  nd_dassert(
    false, message(), function: function, file: file, line: line, tag: tag)
}

@inlinable
public func nd_fatalError(
  _ message: @autoclosure () -> String = String(),
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil
) {
  // swiftlint:disable:next trailing_closure
  _nd_assert(
    false,
    message(),
    function: function,
    file: file,
    line: line,
    tag: tag,
    // swiftlint:disable:next multiline_arguments
    failureHandlers: nd_log(error:function:file:line:tag:), { error, _, file, line, _ in
      fatalError(error(), file: file, line: line)
    }
  )
}

@inlinable
// swiftlint:disable:next identifier_name
public func _nd_assert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String,
  function: StaticString = #function,
  file: StaticString = #file,
  line: UInt = #line,
  tag: Any? = nil,
  failureHandlers: (
    (
      () -> String, _ function: StaticString, _ file: StaticString,
      _ line: UInt, _ tag: Any?
    ) -> Void
  )...
) {
  if !condition() {
    var logMesg: String?
    func getLogMesg() -> String {
      if let logMesg = logMesg {
        return logMesg
      }
      let mesg = message()
      logMesg =
        !mesg.isEmpty
        ? "Failure assertion. \(mesg)" : "Failure assertion."
      // swiftlint:disable:next force_unwrapping
      return logMesg!
    }

    failureHandlers.forEach {
      $0(getLogMesg, function, file, line, tag)
    }
  }
}
