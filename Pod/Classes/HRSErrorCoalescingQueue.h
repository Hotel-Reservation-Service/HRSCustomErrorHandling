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

/**
 The error coalescing queue gathers all errors that are added to itself and then
 usees the HRSErrorPresenter to present the errors, one at a time, ensuring that
 one error is not displayed over another.
 
 When an error is dismissed, the queue iterates over the errors in the queue. As
 long as the next error is considered equal, it drops this error and calls the
 associated completion handler with the result of the error being dismissed.
 
 This lookup stops as soon as the queue finds the first error that is not
 considered equal. This error is then presented as the next error.
 
 An error is considered equal if the error domain, the error code, and the
 recovery attempter - if there is any - is equal.
 */
@interface HRSErrorCoalescingQueue : NSObject

/**
 The default queue used by the default error presentation logic.
 
 When you do not make any changes to error processing inside your app, all
 errors will be added to this queue.
 
 @return The default queue
 */
+ (instancetype)defaultQueue;

/**
 Adds the given error to the receiver as the last error to be presented.
 
 If the queue is currently empty, it immediately presents the error, bypassing
 the queue.
 
 @param error             The error to be added to the queue
 @param completionHandler The completion handler that should be called after
                          error recovery.
 */
- (void)addError:(NSError *)error completionHandler:(void(^)(BOOL didRecover))completionHandler;

@end
