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


@interface HRSResponderChainTests : XCTestCase

@end


@implementation HRSResponderChainTests

- (void)testVisibleViewControllerToApplication
{
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:nil];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	UIViewController *visibleViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
	
	XCTAssertNotNil(visibleViewController.nextResponder, @"Pre condition unfulfilled: The next responder should not be nil as we are trying to test a visible view controller.");
	
	id applicationMock = OCMPartialMock([UIApplication sharedApplication]);
	[[applicationMock expect] presentError:error completionHandler:completionHandler];
	
	[visibleViewController presentError:error completionHandler:completionHandler];
	
	[applicationMock verify];
	[applicationMock stopMocking];
}

- (void)testInvisibleViewControllerToApplication
{
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:nil];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	UIViewController *invisibleViewController = [UIViewController new];
	
	XCTAssertNil(invisibleViewController.nextResponder, @"Pre condition unfulfilled: The next responder should be nil as we are trying to test an invisible view controller.");
	
	id applicationMock = OCMPartialMock([UIApplication sharedApplication]);
	[[applicationMock expect] presentError:error completionHandler:completionHandler];
	
	[invisibleViewController presentError:error completionHandler:completionHandler];
	
	[applicationMock verify];
	[applicationMock stopMocking];
}

- (void)testVisibleViewControllerToApplicationWithViewController
{
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:nil];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	UIViewController *visibleViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
	
	XCTAssertNotNil(visibleViewController.nextResponder, @"Pre condition unfulfilled: The next responder should not be nil as we are trying to test a visible view controller.");
	
	id applicationMock = OCMPartialMock([UIApplication sharedApplication]);
	[[applicationMock expect] presentError:error onViewController:visibleViewController completionHandler:completionHandler];
	
	[visibleViewController presentError:error onViewController:visibleViewController completionHandler:completionHandler];
	
	[applicationMock verify];
	[applicationMock stopMocking];
}

- (void)testInvisibleViewControllerToApplicationWithViewController
{
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:nil];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	UIViewController *invisibleViewController = [UIViewController new];
	
	XCTAssertNil(invisibleViewController.nextResponder, @"Pre condition unfulfilled: The next responder should be nil as we are trying to test an invisible view controller.");
	
	id presenterMock = OCMClassMock([HRSErrorPresenter class]);
	[[presenterMock reject] presenterWithError:error completionHandler:OCMOCK_ANY];
	[[presenterMock reject] alloc];
	
	id applicationMock = OCMPartialMock([UIApplication sharedApplication]);
	[[applicationMock expect] presentError:error onViewController:invisibleViewController completionHandler:completionHandler];
	
	[invisibleViewController presentError:error onViewController:invisibleViewController completionHandler:completionHandler];
	
	[applicationMock verify];
	[applicationMock stopMocking];
	
	[presenterMock verify];
	[presenterMock stopMocking];
}

- (void)testApplicationToAppDelegate
{
	NSError *error = [NSError errorWithDomain:@"com.hrs.tests" code:1 userInfo:nil];
	void(^completionHandler)(BOOL didRecover) = ^void(BOOL didRecover) {
		// empty
	};
	
	UIApplication *application = [UIApplication sharedApplication];
	
	XCTAssertTrue([application.delegate isKindOfClass:[UIResponder class]], @"Pre condition unfulfilled: The application delegate needs to inherit from UIResponder.");
	
	id delegateMock = OCMPartialMock(application.delegate);
	[[delegateMock expect] presentError:error completionHandler:completionHandler];
	
	[application presentError:error completionHandler:completionHandler];
	
	[delegateMock verify];
	[delegateMock stopMocking];
}

@end
