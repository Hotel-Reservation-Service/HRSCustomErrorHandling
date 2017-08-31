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

@interface HRSErrorPresenter : UIAlertView

/**
 @warning You should not set a custom delegate to a `HRSErrorPresenter`.
 */
@property(nonatomic,assign) id delegate __unavailable;

/**
 Creates a new `HRSErrorPresenter` object (a `UIAlertView`) that is fully
 configured with the passed-in error and linked with the given completion
 handler.

 @note This does not automatically present the alert view. You still need to
       call `show` on the returned object.
 
 @param error             The error that should be presented.
 @param completionHandler The completion handler that should be called after
                          error recovery.
 
 @return The fully configured presenter object, ready to be shown to the user.
 */
+ (instancetype)presenterWithError:(NSError *)error completionHandler:(void (^ _Nullable)(BOOL))completionHandler;

/**
 Initializes a `HRSErrorPresenter` object (a `UIAlertView`) that is fully
 configured with the passed-in error and linked with the given completion
 handler.
 
 @note This does not automatically present the alert view. You still need to
       call `show` on the returned object.
 
 @param error             The error that should be presented.
 @param completionHandler The completion handler that should be called after
				          error recovery.
 
 @return The fully configured presenter object, ready to be shown to the user.
 */
- (instancetype)initWithError:(NSError *)error completionHandler:(void (^ _Nullable)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_END
