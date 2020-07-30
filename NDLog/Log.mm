//
//  NDLog.m
//  NDLog
//
//  Created by Nguyen Duc Hiep on 3/24/20.
//  Copyright © 2020 Nguyen Duc Hiep. All rights reserved.
//

#import <NDLog/NDLog.h>

#define NDLogInternalMessage(...) NSLog(__VA_ARGS__)
#define NDLogInternalCAssert(condition, format, ...)            \
  do {                                                          \
    if (!(condition)) {                                         \
      NDDefineAssertDescription(description, condition, format, \
                                ##__VA_ARGS__);                 \
      NDLogInternalMessage(@"%@", description);                 \
      NSCAssert(NO, description);                               \
    }                                                           \
  } while (0)

namespace {
NDLogLevel NDLogDefinedLevel = NDLogLevelError;
}

BOOL NDLogConfigureWithParas(NSDictionary<NDLogParameterKey, id>* paras) {
  id level = paras[kNDLogLevel];
  if (level) {
    NDLogInternalCAssert([level isKindOfClass:NSNumber.class],
                         @"Invalid config level value: %@.", level);
    if ([level isKindOfClass:NSNumber.class]) {
      NDLogDefinedLevel = (NDLogLevel)[level unsignedIntegerValue];
    }
  }

  return YES;
}

BOOL NDLogConfigureWithName(NSString* name) {
  auto paras = [[NSDictionary alloc]
      initWithContentsOfURL:[NSBundle.mainBundle URLForResource:name ?: @"NDLog"
                                                  withExtension:@"plist"]];
  NDLogInternalCAssert(paras, @"Error reading log config with name: %@.", name);
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
