//
//  NDLog.h
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/24/20.
//  Copyright © 2020 Nguyen Duc Hiep. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* NDLogParameterKey NS_TYPED_EXTENSIBLE_ENUM;

FOUNDATION_EXPORT
BOOL NDLogConfigureWithParas(NSDictionary<NDLogParameterKey, id>* paras)
    NS_REFINED_FOR_SWIFT;

/// Level
/// Default value is NDLogError
extern NDLogParameterKey const kNDLogLevel;

FOUNDATION_EXPORT
/// Config log with plist name.
/// @param name The name, if nil the default value 'NDLog' will be used.
BOOL NDLogConfigureWithName(NSString* _Nullable name) NS_REFINED_FOR_SWIFT;

typedef NS_OPTIONS(NSUInteger, NDLogSeverity) {
  NDLogSeverityError = 1 << 0,
  NDLogSeverityWarning = 1 << 1,
  NDLogSeverityInfo = 1 << 2,
  NDLogSeverityDebug = 1 << 3,
  NDLogSeverityVerbose = 1 << 4,
};

typedef NS_ENUM(NSUInteger, NDLogLevel) {
  NDLogLevelOff = 0,
  NDLogLevelError = (NDLogSeverityError),
  NDLogLevelWarning = (NDLogLevelError | NDLogSeverityWarning),
  NDLogLevelInfo = (NDLogLevelWarning | NDLogSeverityInfo),
  NDLogLevelDebug = (NDLogLevelInfo | NDLogSeverityDebug),
  NDLogLevelVerbose = (NDLogLevelDebug | NDLogSeverityVerbose),
  NDLogLevelAll = NSUIntegerMax
};

FOUNDATION_EXPORT
NDLogLevel NDLogGetDefinedLevel(void) NS_SWIFT_NAME(definedLogLevel());

#define NDLogIfAllowed(serverity, file, function, line, tag, format, ...)   \
  do {                                                                      \
    if (NDLogGetDefinedLevel() & serverity)                                 \
      NDLogMessage(serverity,                                               \
                   [NSString stringWithFormat:format, ##__VA_ARGS__], file, \
                   function, line, tag);                                    \
  } while (0)

#define NDLogTagError(tag, format, ...)                                       \
  NDLogIfAllowed(NDLogSeverityError, __FILE__, __PRETTY_FUNCTION__, __LINE__, \
                 tag, format, ##__VA_ARGS__)
#define NDLogTagWarning(tag, format, ...)                             \
  NDLogIfAllowed(NDLogSeverityWarning, __FILE__, __PRETTY_FUNCTION__, \
                 __LINE__, tag, format, ##__VA_ARGS__)
#define NDLogTagInfo(tag, format, ...)                                       \
  NDLogIfAllowed(NDLogSeverityInfo, __FILE__, __PRETTY_FUNCTION__, __LINE__, \
                 tag, format, ##__VA_ARGS__)
#define NDLogTagDebug(tag, format, ...)                                       \
  NDLogIfAllowed(NDLogSeverityDebug, __FILE__, __PRETTY_FUNCTION__, __LINE__, \
                 tag, format, ##__VA_ARGS__)
#define NDLogTagVerbose(tag, format, ...)                             \
  NDLogIfAllowed(NDLogSeverityVerbose, __FILE__, __PRETTY_FUNCTION__, \
                 __LINE__, tag, format, ##__VA_ARGS__)

#define NDLogError(format, ...) NDLogTagError(nil, format, ##__VA_ARGS__)
#define NDLogWarning(format, ...) NDLogTagWarning(nil, format, ##__VA_ARGS__)
#define NDLogInfo(format, ...) NDLogTagInfo(nil, format, ##__VA_ARGS__)
#define NDLogDebug(format, ...) NDLogTagDebug(nil, format, ##__VA_ARGS__)
#define NDLogVerbose(format, ...) NDLogTagVerbose(nil, format, ##__VA_ARGS__)

#define _NDDefineAssertDescription(variable, condition, format, ...)  \
  NSString* variable =                                                \
      [NSString stringWithFormat:@"'%s' not satisfied.", #condition]; \
  if (format.length > 0) {                                            \
    variable = [[variable stringByAppendingString:@" "]               \
        stringByAppendingFormat:format, ##__VA_ARGS__];               \
  };

#define _NDSystemAssert(systemAssert, condition, format, ...)    \
  do {                                                           \
    if (!(condition)) {                                          \
      _NDDefineAssertDescription(description, condition, format, \
                                 ##__VA_ARGS__);                 \
      NDLogError(@"%@", description);                            \
      systemAssert(NO, @"%@", description);                      \
    }                                                            \
  } while (0)

#define NDAssert(condition, format, ...) \
  _NDSystemAssert(NSAssert, condition, format, ##__VA_ARGS__)

#define NDCAssert(condition, format, ...) \
  _NDSystemAssert(NSCAssert, condition, format, ##__VA_ARGS__)

#define NDAssertionFailure(format, ...) NDAssert(NO, format, ##__VA_ARGS__)

#define NDCAssertionFailure(format, ...) NDCAssert(NO, format, ##__VA_ARGS__)

#if DEBUG
#define _NDBreak(...) \
  do {                \
    raise(SIGTRAP);   \
  } while (0)
#else
#define _NDBreak(...) \
  do {                \
  } while (0)
#endif

#define NDDAssert(condition, format, ...) \
  _NDSystemAssert(_NDBreak, condition, format, ##__VA_ARGS__)

#define NDDAssertionFailure(format, ...) NDDAssert(NO, format, ##__VA_ARGS__)

#define _NDAssertFatalError(condition, frm, ...)                     \
  do {                                                               \
    if (!(condition))                                                \
      [NSException raise:@"NDFatalError" format:frm, ##__VA_ARGS__]; \
  } while (0)

#define NDFatalError(format, ...) \
  _NDSystemAssert(_NDAssertFatalError, NO, format, ##__VA_ARGS__)

FOUNDATION_EXPORT void NDLogMessage(NDLogSeverity severity,
                                    NSString* msg,
                                    const char* file,
                                    const char* function,
                                    NSUInteger line,
                                    id _Nullable tag) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
