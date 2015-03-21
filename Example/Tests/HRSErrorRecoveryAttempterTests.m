//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//

#import <XCTest/XCTest.h>


@interface HRSErrorRecoveryAttempterTests : XCTestCase

@end


@implementation HRSErrorRecoveryAttempterTests

- (void)testSynchronousRecoveryBlockInvocation
{
	__block BOOL blockInvoked = NO;
	BOOL(^recoveryBlock)(void) = ^BOOL{
		blockInvoked = YES;
		return YES;
	};
	
	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addRecoveryOptionWithTitle:@"Test" recoveryAttempt:recoveryBlock];
	
	[attempter attemptRecoveryFromError:nil optionIndex:0];
	
	XCTAssertTrue(blockInvoked, @"Recovery block should have been invoked.");
}

- (void)testSynchronousRecoveryAttemptSuccessful
{
	BOOL(^recoveryBlock)(void) = ^BOOL{
		return YES;
	};
	
	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addRecoveryOptionWithTitle:@"Test" recoveryAttempt:recoveryBlock];
	
	BOOL successful = [attempter attemptRecoveryFromError:nil optionIndex:0];
	
	XCTAssertTrue(successful, @"Recovery should have been successful.");
}

- (void)testSynchronousRecoveryAttemptUnsuccessful
{
	BOOL(^recoveryBlock)(void) = ^BOOL{
		return NO;
	};
	
	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addRecoveryOptionWithTitle:@"Test" recoveryAttempt:recoveryBlock];
	
	BOOL successful = [attempter attemptRecoveryFromError:nil optionIndex:0];
	
	XCTAssertFalse(successful, @"Recovery should not have been successful.");
}

- (void)_testAsynchronousRecoveryAttemptSuccessful_didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo
{
	XCTAssertTrue(didRecover, @"Did recover not of expected value.");
}

- (void)testAsynchronousRecoveryAttemptSuccessful
{
	BOOL(^recoveryBlock)(void) = ^BOOL{
		return YES;
	};
	
	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addRecoveryOptionWithTitle:@"Test" recoveryAttempt:recoveryBlock];
	
	[attempter attemptRecoveryFromError:nil optionIndex:0 delegate:self didRecoverSelector:@selector(_testAsynchronousRecoveryAttemptSuccessful_didPresentErrorWithRecovery:contextInfo:) contextInfo:NULL];
}

- (void)_testAsynchronousRecoveryAttemptUnsuccessful_didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo
{
	XCTAssertFalse(didRecover, @"Did recover not of expected value.");
}

- (void)testAsynchronousRecoveryAttemptUnsuccessful
{
	BOOL(^recoveryBlock)(void) = ^BOOL{
		return NO;
	};
	
	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addRecoveryOptionWithTitle:@"Test" recoveryAttempt:recoveryBlock];
	
	[attempter attemptRecoveryFromError:nil optionIndex:0 delegate:self didRecoverSelector:@selector(_testAsynchronousRecoveryAttemptUnsuccessful_didPresentErrorWithRecovery:contextInfo:) contextInfo:NULL];
}

- (void)testEquality {
    BOOL(^recoveryBlock)(void) = ^BOOL{
        return NO;
    };
    BOOL(^otherRecoveryBlock)(void) = ^BOOL{
        return YES;
    };
    
    HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
    [attempter addRecoveryOptionWithTitle:@"Foo" recoveryAttempt:recoveryBlock];
    
    HRSErrorRecoveryAttempter *equalAttempter = [HRSErrorRecoveryAttempter new];
    [equalAttempter addRecoveryOptionWithTitle:@"Foo" recoveryAttempt:otherRecoveryBlock];
    
    HRSErrorRecoveryAttempter *unequalAttempter = [HRSErrorRecoveryAttempter new];
    [unequalAttempter addRecoveryOptionWithTitle:@"Bar" recoveryAttempt:otherRecoveryBlock];
    
    HRSErrorRecoveryAttempter *advancedAttempter = [HRSErrorRecoveryAttempter new];
    [advancedAttempter addRecoveryOptionWithTitle:@"Foo" recoveryAttempt:otherRecoveryBlock];
    [advancedAttempter addRecoveryOptionWithTitle:@"Bar" recoveryAttempt:otherRecoveryBlock];
    
    XCTAssertTrue([attempter isEqual:equalAttempter], @"Both attempter should be equal according to the definition of isEqual:");
    XCTAssertFalse([attempter isEqual:unequalAttempter], @"Both attempter should not be equal according to the definition of isEqual:");
    XCTAssertFalse([attempter isEqual:advancedAttempter], @"Both attempter should not be equal according to the definition of isEqual:");
}

@end
