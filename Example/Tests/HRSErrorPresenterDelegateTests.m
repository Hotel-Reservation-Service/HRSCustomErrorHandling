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

#import <HRSCustomErrorHandling/HRSErrorPresenterDelegate.h>


@interface HRSErrorPresenterDelegateTests : XCTestCase

@end


@implementation HRSErrorPresenterDelegateTests

- (void)testDismissCallsErrorRecovery
{
	id recoveryAttempter = OCMClassMock([HRSErrorRecoveryAttempter class]);
	
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:@{ NSRecoveryAttempterErrorKey: recoveryAttempter }];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	
	HRSErrorPresenterDelegate *sut = [HRSErrorPresenterDelegate delegateWithError:error completionHandler:completionHandler];
	
	[[recoveryAttempter expect] attemptRecoveryFromError:error optionIndex:0];
	
	id alertViewMock = OCMClassMock([UIAlertView class]);
	[[[alertViewMock stub] andReturnValue:OCMOCK_VALUE(1)] numberOfButtons];
	
	[sut alertView:alertViewMock clickedButtonAtIndex:0]; // should be any value, but this is currently not supported by OCMock.
	
	[alertViewMock stopMocking];
	
	[recoveryAttempter verify];
	[recoveryAttempter stopMocking];
}

/**
 *  Button index should be in reverse order as the recovery attempts as the
 *  first button is the left most but the first recovery option should be the
 *  default (right most) option.
 */
- (void)testMapButtonIndexToRecoveryOption
{
	id recoveryAttempter = OCMClassMock([HRSErrorRecoveryAttempter class]);
	
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:@{ NSRecoveryAttempterErrorKey: recoveryAttempter }];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	
	HRSErrorPresenterDelegate *sut = [HRSErrorPresenterDelegate delegateWithError:error completionHandler:completionHandler];
	
	id alertViewMock = OCMClassMock([UIAlertView class]);
	[[[alertViewMock stub] andReturnValue:OCMOCK_VALUE(3)] numberOfButtons];
	
	[[recoveryAttempter expect] attemptRecoveryFromError:error optionIndex:0];
	[sut alertView:alertViewMock clickedButtonAtIndex:2];
	[recoveryAttempter verify];
	
	[[recoveryAttempter expect] attemptRecoveryFromError:error optionIndex:1];
	[sut alertView:alertViewMock clickedButtonAtIndex:1];
	[recoveryAttempter verify];
	
	[[recoveryAttempter expect] attemptRecoveryFromError:error optionIndex:2];
	[sut alertView:alertViewMock clickedButtonAtIndex:0];
	[recoveryAttempter verify];
	
	[alertViewMock stopMocking];
	
	[recoveryAttempter stopMocking];
}

@end
