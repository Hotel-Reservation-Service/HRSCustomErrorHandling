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

#import "HRSErrorCoalescingQueueItem.h"

@implementation HRSErrorCoalescingQueueItem

+ (instancetype)itemWithError:(NSError *)error completionHandler:(void(^)(BOOL didRecover))completionHandler {
    return [[self alloc] initWithError:error completionHandler:completionHandler];
}

- (instancetype)initWithError:(NSError *)error completionHandler:(void(^)(BOOL didRecover))completionHandler {
    self = [super init];
    if (self) {
        _error = error;
        _completionHandler = [completionHandler copy];
    }
    return self;
}



#pragma mark - equality

- (NSUInteger)hash {
    NSUInteger hash = self.error.domain.hash
                    ^ self.error.code << 2;
    if (self.error.recoveryAttempter && [self.error.recoveryAttempter conformsToProtocol:@protocol(NSObject)]) {
        id<NSObject> recoveryAttempter = self.error.recoveryAttempter;
        hash ^= recoveryAttempter.hash << 4;
    }
    return hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    
    HRSErrorCoalescingQueueItem *otherItem = object;
    BOOL isEqualError = [self.error.domain isEqualToString:otherItem.error.domain] && self.error.code == otherItem.error.code;
    
    BOOL isEqualRecoveryAttempter = NO;
    if (self.error.recoveryAttempter && [self.error.recoveryAttempter conformsToProtocol:@protocol(NSObject)]
        && otherItem.error.recoveryAttempter && [otherItem.error.recoveryAttempter conformsToProtocol:@protocol(NSObject)]) {
        id<NSObject> recoveryAttempter = self.error.recoveryAttempter;
        id<NSObject> otherRecoveryAttempter = otherItem.error.recoveryAttempter;
        isEqualRecoveryAttempter = [recoveryAttempter isEqual:otherRecoveryAttempter];
        
    } else {
        isEqualRecoveryAttempter = (self.error.recoveryAttempter == otherItem.error.recoveryAttempter);
    }
    
    return isEqualError && isEqualRecoveryAttempter;
}

@end
