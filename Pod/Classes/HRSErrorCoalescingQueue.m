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

#import "HRSErrorCoalescingQueue.h"

#import "HRSErrorCoalescingQueueItem.h"
#import "HRSErrorPresenter.h"


@interface HRSErrorCoalescingQueue ()

@property (nonatomic, assign, readwrite, getter=isPresenting) BOOL presenting;
@property (nonatomic, strong, readonly) NSMutableArray *queue;

@end


@implementation HRSErrorCoalescingQueue

+ (instancetype)defaultQueue {
    static HRSErrorCoalescingQueue *defaultQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultQueue = [self new];
    });
    return defaultQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = [NSMutableArray new];
    }
    return self;
}



#pragma mark - queue

- (void)enqueueItem:(HRSErrorCoalescingQueueItem *)item {
    [self.queue addObject:item];
}

- (HRSErrorCoalescingQueueItem *)dequeueItem {
    if (self.queue.count == 0) {
        return nil;
    }
    
    HRSErrorCoalescingQueueItem *nextItem = [self.queue firstObject];
    [self.queue removeObjectAtIndex:0];
    return nextItem;
}

- (NSArray *)dequeueItemsEqualToItem:(HRSErrorCoalescingQueueItem *)item {
    __block NSRange itemRange = NSMakeRange(0, 0);
    [self.queue enumerateObjectsUsingBlock:^(HRSErrorCoalescingQueueItem *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:item]) {
            itemRange.length++;
        } else {
            *stop = YES;
        }
    }];
    
    NSArray *nextItems = [self.queue subarrayWithRange:itemRange];
    [self.queue removeObjectsInRange:itemRange];
    return nextItems;
}



#pragma mark - error handling

- (void)presentErrorIfPossible {
    if (self.isPresenting) {
        return;
    }
    
    HRSErrorCoalescingQueueItem *item = [self dequeueItem];
    if (item == nil) {
        return;
    }
    
    self.presenting = YES;
    
    [self presentError:item.error completionHandler:^(BOOL didRecover) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (item.completionHandler) {
                item.completionHandler(didRecover);
            }
            
            NSArray *equalItems = [self dequeueItemsEqualToItem:item];
            for (HRSErrorCoalescingQueueItem *item in equalItems) {
                if (item.completionHandler) {
                    item.completionHandler(didRecover);
                }
            }
            
            self.presenting = NO;
            
            [self presentErrorIfPossible];
        });
    }];
}

- (void)addError:(NSError *)error completionHandler:(void(^)(BOOL didRecover))completionHandler {
    HRSErrorCoalescingQueueItem *item = [HRSErrorCoalescingQueueItem itemWithError:error completionHandler:completionHandler];
    [self enqueueItem:item];
    [self presentErrorIfPossible];
}

- (void)presentError:(NSError *)error completionHandler:(void(^)(BOOL didRecover))completionHandler {
    HRSErrorPresenter *presenter = [HRSErrorPresenter presenterWithError:error completionHandler:completionHandler];
    [presenter show];
}

@end
