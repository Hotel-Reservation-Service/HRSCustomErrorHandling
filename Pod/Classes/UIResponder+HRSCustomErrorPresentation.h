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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HRSErrorCoalescingQueue;
@interface UIResponder (HRSCustomErrorPresentation)

/**
 Presents an error to the user.
 
 The default implementation of this method will call `willPresentError:` with
 the error that was passed to this method. The resulting error will then be
 forwarded up the responder chain. If there is no next responder, the error
 is forwarded to the current `UIApplication` instance.
 
 If the responder that receives this message is the application delegate or it
 is the application itself and the application delegate does not inherit from
 `UIResponder` the error is presented in a `UIAlertView` dialog.
 
 After the user dismisses the alert view, the error recovery for this option is
 automatically started. After the error recovery, the completion handler is
 called, reporting whether the recovery was successful or not.
 
 It is recommended to retry the action that lead to the error in the first place
 when the error recovery was successful.
 
 @note You can override this method in your application delegate to create your
       own custom error presentation UI. Make sure to let your delegate inherit
       from `UIResponder` for this hook to work.
 
 @param error             The error that should be presented to the user.
 @param completionHandler The completion handler that is called when the user
                          taps a button and the error recovery was completed.
			              didRecover Is true if the error recovery was
                          successful. You should retry the action that lead to
                          the error in this case.
 */
- (void)presentError:(NSError * _Nullable)error completionHandler:(void (^ _Nullable)(BOOL didRecover))completionHandler;

/**
 Presents an error that is related to a certain view controller to the user.
 
 The default implementation of this method will call `willPresentError:` with
 the error that was passed to this method. The resulting error will then be
 forwarded up the responder chain. If there is no next responder, the error
 is forwarded to the current `UIApplication` instance.
 
 If the responder that receives this message is the application delegate or it
 is the application itself and the application delegate does not inherit from
 `UIResponder` the error is presented in a `UIAlertView` dialog, as long as the
 passed in view controller is visible on screen.
 
 @warning If the passed in view controller is not visible on the screen, the
          error is suppressed and the `completionHandler` is called with the
          `didRecover` value set to NO. If you do not want this behaviour, you
          should use `presentError:completionHandler:` instead.
 
 After the error recovery, the completion handler is called, reporting whether
 the recovery was successful or not.
 
 It is recommended to retry the action that lead to the error in the first place
 when the error recovery was successful.
 
 @note You can override this method in your application delegate to create your
	   own custom error presentation UI. Make sure to let your delegate inherit
       from `UIResponder` for this hook to work. **The default implementation of
       this method does the same as `presentError:completionHandler:`**
 
 @param error             The error that should be presented to the user.
 @param viewController    The view controller the error should be presented on.
 @param completionHandler The completion handler that is called when the user
                          taps a button and the error recovery was completed.
						  didRecover Is true if the error recovery was
                          successful. You should retry the action that lead to
                          the error in this case.
 */
- (void)presentError:(NSError * _Nullable)error onViewController:(UIViewController *)viewController completionHandler:(void (^ _Nullable)(BOOL didRecover))completionHandler;

/**
 Called when the receiver is about to present or forward an error. The returned
 error is the error that is should actually be presented or forwarded.
 
 The default implementation of this method immediately returns the passed-in
 error.
 
 You can manipulate the passed-in error to change the presentation of the error
 in three ways:
 (1) return the error that was passed to the method to not change the error.
 (2) return nil to stop the error from being presented.
 (3) return a new error that will be presented instead.
     It is recommended to only touch the parameters of the error you really
     want to change and leave the rest as it is. E.g. when you want to change
     the localized text that is shown to the user, leave the error domain, the
     error code and all other keys from the `userInfo` dictionary as they are to
     give other responders in the chain a chance to identify the error.
 
 @param error The error the receiver wants to present or forward.
 
 @return The error you want the receiver to present or forward or nil if you
         do not want any error to be presented or forwarded.
 */
- (NSError * _Nullable)willPresentError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
