//
//  NDLog.h
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/24/20.
//  Copyright © 2020 Neodata Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Applies constraint as width by height in |constraintRatio| to view in
/// |view|.
FOUNDATION_EXPORT
BOOL NDLogConfigureWithParas(NSDictionary<NSString*, id>* paras)
    NS_REFINED_FOR_SWIFT;
// Default is NDLogError
extern NSString* const kNDLogConfigLevel;

FOUNDATION_EXPORT
BOOL NDLogConfigureWithName(NSString* name) NS_REFINED_FOR_SWIFT;

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

#define NDLogIfAllowed(serverity, file, function, line, tag, format, ...) \
  do {                                                                    \
    if (NDLogGetDefinedLevel() & serverity)                               \
      NDLogMessage([NSString stringWithFormat:format, ##__VA_ARGS__],     \
                   serverity, file, function, line, tag);                 \
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

#define NDDefineAssertDescription(variable, condition, format, ...)   \
  NSString* variable =                                                \
      [NSString stringWithFormat:@"'%s' not satisfied.", #condition]; \
  if (format.length > 0) {                                            \
    variable = [[variable stringByAppendingString:@" "]               \
        stringByAppendingFormat:format, ##__VA_ARGS__];               \
  };

#define NDSystemAssert(systemAssert, condition, format, ...)    \
  do {                                                          \
    if (!(condition)) {                                         \
      NDDefineAssertDescription(description, condition, format, \
                                ##__VA_ARGS__);                 \
      NDLogError(@"%@", description);                           \
      systemAssert(NO, @"%@", description);                     \
    }                                                           \
  } while (0)

#define NDAssert(condition, format, ...) \
  NDSystemAssert(NSAssert, condition, format, ##__VA_ARGS__)

#define NDCAssert(condition, format, ...) \
  NDSystemAssert(NSCAssert, condition, format, ##__VA_ARGS__)

#define NDAssertFailure(format, ...) NDAssert(NO, format, ##__VA_ARGS__)

#define NDCAssertFailure(format, ...) NDCAssert(NO, format, ##__VA_ARGS__)

FOUNDATION_EXPORT
void NDLogMessage(NSString* msg,
                  NDLogSeverity severity,
                  const char* file,
                  const char* function,
                  NSUInteger line,
                  id _Nullable tag)
    NS_SWIFT_UNAVAILABLE(
        "Use log(message:severity:file:function:line:tag) instead.");

FOUNDATION_EXPORT
void __NDLogMessage(NSString* msg,
                    NDLogSeverity severity,
                    NSString* file,
                    NSString* function,
                    NSUInteger line,
                    id _Nullable tag);

NS_ASSUME_NONNULL_END