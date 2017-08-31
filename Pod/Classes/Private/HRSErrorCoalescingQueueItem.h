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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRSErrorCoalescingQueueItem : NSObject

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, copy, readonly) void(^_Nullable completionHandler)(BOOL didRecover);

+ (instancetype)itemWithError:(NSError *)error completionHandler:(void(^_Nullable)(BOOL didRecover))completionHandler;

@end

NS_ASSUME_NONNULL_END
