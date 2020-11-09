//
//  NDLog.m
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/24/20.
//  Copyright © 2020 Nguyen Duc Hiep. All rights reserved.
//

#import <NDLog/NDLog.h>

#define _NDLogInternalMessage(...) NSLog(__VA_ARGS__)
#define _NDLogInternalCAssert(condition, format, ...)            \
  do {                                                           \
    if (!(condition)) {                                          \
      _NDDefineAssertDescription(description, condition, format, \
                                 ##__VA_ARGS__);                 \
      _NDLogInternalMessage(@"%@", description);                 \
      NSCAssert(NO, description);                                \
    }                                                            \
  } while (0)

namespace {
NDLogLevel NDLogDefinedLevel = NDLogLevelError;
}

BOOL NDLogConfigureWithParas(NSDictionary<NDLogParameterKey, id>* paras) {
  BOOL success = YES;
  id level = paras[kNDLogLevel];
  if (level) {
    if (![level isKindOfClass:NSNumber.class]) {
      _NDLogInternalCAssert([level isKindOfClass:NSNumber.class],
                            @"Invalid config level value: %@.", level);
      success = NO;
    } else {
      NDLogDefinedLevel = (NDLogLevel)[level unsignedIntegerValue];
    }
  }

  return success;
}

BOOL NDLogConfigureWithName(NSString* name) {
  auto paras = [[NSDictionary alloc]
      initWithContentsOfURL:[NSBundle.mainBundle URLForResource:name ?: @"NDLog"
                                                  withExtension:@"plist"]];
  _NDLogInternalCAssert(paras, @"Error reading log config with name: %@.",
                        name);
  if (!paras) {
    return NO;
  }

  return NDLogConfigureWithParas(paras);
}

NDLogLevel NDLogGetDefinedLevel() {
  return NDLogDefinedLevel;
}

NSString* const kNDLogLevel = @"Level";

void NDLogMessage(NDLogSeverity severity,
                  NSString* msg,
                  const char* file,
                  const char* function,
                  NSUInteger line,
                  id tag) {
  if (tag) {
    NSLog(@"%s(%s:%lu): %@ %@", function, file, (unsigned long)line, msg, tag);
  } else {
    NSLog(@"%s(%s:%lu): %@", function, file, (unsigned long)line, msg);
  }
}
