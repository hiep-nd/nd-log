//
//  NDLogObjCTests.m
//  NDLogObjCTests
//
//  Created by Nguyen Duc Hiep on 3/24/20.
//  Copyright © 2020 Neodata Co., Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <NDLog/NDLog.h>

@interface NDLogObjCTests : XCTestCase

@end

@implementation NDLogObjCTests

- (void)test_Config {
  XCTAssertTrue(NDLogConfigureWithParas(@{kNDLogLevel : @(NDLogLevelError)}));
}

- (void)test_Config_invalid {
#ifdef DEBUG
  XCTAssertThrows(NDLogConfigureWithParas(@{kNDLogLevel : @"Error"}));
#else
  XCTAssertFalse(NDLogConfigureWithParas(@{kNDLogConfigLevel : @"Error"}));
  XCTAssertEqual(NDLogLevelError, NDLogGetDefinedLevel());
#endif
}

- (void)test_Assert {
#ifdef DEBUG
  XCTAssertNoThrow((^{
    NDAssert(YES, @"");
  })());
  XCTAssertThrows((^{
    NDAssert(NO, @"");
  })());
#else
  XCTAssertNoThrow((^{
    NDAssert(YES, @"");
  })());
  XCTAssertNoThrow((^{
    NDAssert(NO, @"");
  })());
#endif
}

- (void)test_CAssert {
#ifdef DEBUG
  XCTAssertNoThrow((^{
    NDCAssert(YES, @"");
  })());
  XCTAssertThrows((^{
    NDCAssert(NO, @"");
  })());
#else
  XCTAssertNoThrow((^{
    NDCAssert(YES, @"");
  })());
  XCTAssertNoThrow((^{
    NDCAssert(NO, @"");
  })());
#endif
}

- (void)test_LogError {
  NDLogError(@"Error message");
  NDLogError(@"Error message with 1 para: '%@'", @"para 0");
  NDLogError(@"Error message with 2 paras: '%@', '%@'", @"para 0", @"para 1");
}

- (void)test_LogWarning {
  NDLogWarning(@"Warning message");
  NDLogWarning(@"Warning message with 1 para: '%@'", @"para 0");
  NDLogWarning(@"Warning message with 2 paras: '%@', '%@'", @"para 0",
               @"para 1");
}

- (void)test_LogInfo {
  NDLogInfo(@"Info message");
  NDLogInfo(@"Info message with 1 para: '%@'", @"para 0");
  NDLogInfo(@"Info message with 2 paras: '%@', '%@'", @"para 0", @"para 1");
}

- (void)test_LogDebug {
  NDLogDebug(@"Debug message");
  NDLogDebug(@"Debug message with 1 para: '%@'", @"para 0");
  NDLogDebug(@"Debug message with 2 paras: '%@', '%@'", @"para 0", @"para 1");
}

- (void)test_LogVerbose {
  NDLogVerbose(@"Verbose message");
  NDLogVerbose(@"Verbose message with 1 para: '%@'", @"para 0");
  NDLogVerbose(@"Verbose message with 2 paras: '%@', '%@'", @"para 0",
               @"para 1");
}

- (void)test_LogTagError {
  NDLogTagError(@"mylog", @"Verbose message");
  NDLogTagError(@"mylog", @"Verbose message with 1 para: '%@'", @"para 0");
  NDLogTagError(@"mylog", @"Verbose message with 2 paras: '%@', '%@'",
                @"para 0", @"para 1");
}

- (void)test_dassert {
  NDDAssert(false, @"Debug break message");
  NDDAssert(true, @"Debug break message");
  NDDAssertionFailure(@"Debug break message");
}

@end
