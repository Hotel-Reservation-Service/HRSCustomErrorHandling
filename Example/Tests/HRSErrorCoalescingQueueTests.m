//
//  HRSErrorCoalescingQueueTests.m
//  HRSCustomErrorHandling
//
//  Created by Michael Ochs on 21/03/15.
//  Copyright (c) 2015 Michael Ochs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HRSErrorCoalescingQueue.h"


@interface HRSErrorCoalescingQueue (Internal)

@property (nonatomic, assign, readwrite, getter=isPresenting) BOOL presenting;
@property (nonatomic, strong, readonly) NSMutableArray *queue;

- (void)enqueueItem:(id)item;
- (id)dequeueItem;
- (NSArray *)dequeueItemsEqualToItem:(id)item;

@end


@interface HRSErrorCoalescingQueueTests : XCTestCase

@property (nonatomic, strong, readwrite) HRSErrorCoalescingQueue *sut;

@end


@implementation HRSErrorCoalescingQueueTests

- (void)setUp {
    [super setUp];
    
    self.sut = [HRSErrorCoalescingQueue new];
}

- (void)tearDown {
    self.sut = nil;
    
    [super tearDown];
}

- (void)testSinglePushAndPop {
    XCTAssertNil(self.sut.dequeueItem, @"Pre condition not met. Queue was not empty.");
    
    self.sut.presenting = YES; // lock queue
    
    NSError *error = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error completionHandler:NULL];
    
    id item = [self.sut dequeueItem];
    XCTAssertEqual([item valueForKey:@"error"], error, @"Error from first item should be equal to the one just added as was empty before.");
}

- (void)testMultipleEqualPushAndPop {
    XCTAssertNil(self.sut.dequeueItem, @"Pre condition not met. Queue was not empty.");
    
    self.sut.presenting = YES; // lock queue
    
    NSError *error1 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error1 completionHandler:NULL];
    
    NSError *error2 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error2 completionHandler:NULL];
    
    NSError *error3 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error3 completionHandler:NULL];
    
    NSError *error4 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error4 completionHandler:NULL];
    
    id item = [self.sut dequeueItem];
    NSArray *equalErrors = [self.sut dequeueItemsEqualToItem:item];
    
    XCTAssertEqual(equalErrors.count, 3, @"There should be three equal errors.");
    XCTAssertEqual([equalErrors[0] valueForKey:@"error"], error2, @"Item at index 0 should contain error 2");
    XCTAssertEqual([equalErrors[1] valueForKey:@"error"], error3, @"Item at index 1 should contain error 3");
    XCTAssertEqual([equalErrors[2] valueForKey:@"error"], error4, @"Item at index 2 should contain error 4");
}

- (void)testMultipleEqualUnequalPushAndPop {
    XCTAssertNil(self.sut.dequeueItem, @"Pre condition not met. Queue was not empty.");
    
    self.sut.presenting = YES; // lock queue
    
    NSError *error1 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error1 completionHandler:NULL];
    
    NSError *error2 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error2 completionHandler:NULL];
    
    NSError *error3 = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    [self.sut addError:error3 completionHandler:NULL];
    
    NSError *error4 = [NSError errorWithDomain:@"OtherTest" code:1 userInfo:nil];
    [self.sut addError:error4 completionHandler:NULL];
    
    id item = [self.sut dequeueItem];
    NSArray *equalErrors = [self.sut dequeueItemsEqualToItem:item];
    
    XCTAssertEqual(equalErrors.count, 2, @"There should be two equal errors.");
    XCTAssertEqual([equalErrors[0] valueForKey:@"error"], error2, @"Item at index 0 should contain error 2");
    XCTAssertEqual([equalErrors[1] valueForKey:@"error"], error3, @"Item at index 1 should contain error 3");
    
    id lastItem = [self.sut dequeueItem];
    XCTAssertEqual([lastItem valueForKey:@"error"], error4, @"Remaining item should contain error 4");
    
    XCTAssertNil([self.sut dequeueItem], @"After popping all added error items, queue should be empty again.");
}

@end
