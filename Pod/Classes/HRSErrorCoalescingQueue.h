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
 
 # Subclassing
 
 You can subclass `HRSErrorCoalescingQueue` to manipulate the way an error is
 displayed or enqueued. To use a custom subclass of the error coalescing queue
 you also need to override the `presentError:completionHandler:` and/or
 `presentError:onViewController:completionHandler:` methods of `UIResponder`.
 
 To properly use your custom queue, override one or both of these methods in
 your last responder in the responder chain. This is your `UIApplicationDelegate`
 if it inherits from `UIResponder` or your `UIApplication` otherwise. In this
 class, you simply override the mentioned methods and call
 `addError:completionHandler:` on your own queue.
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
- (void)addError:(NSError *)error completionHandler:(void(^ _Nullable)(BOOL didRecover))completionHandler;

@end


@interface HRSErrorCoalescingQueue (Subclassing)

/**
 Presents the passed in error.

 You can override this method to perform custom error presentation. The queue
 calls this method when it is time to present another error. In your custom
 implementation you need to make sure to call the completion handler when you
 are done presenting the error, otherwise you will lock up the queue.

 @warning Do not call this method yourself, instead always use the
          `addError:completionHandler:` method. This method is only used for
          subclassing purpose.

 @param error             The error that should be presented
 @param completionHandler The completion handler to be called when the error
                          presentation ends. This completion handler can be
                          called on any thread.
 */
- (void)presentError:(NSError *)error completionHandler:(void(^ _Nullable)(BOOL didRecover))completionHandler;

@end

NS_ASSUME_NONNULL_END
