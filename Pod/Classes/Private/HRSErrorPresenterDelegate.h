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

@interface HRSErrorPresenterDelegate : NSObject <UIAlertViewDelegate>

/**
 Creates a presenter delegate to work closely together with the
 `HRSErrorPresenter`.
 
 @note You should not create such an object on your own, instead, this object
       is presented for you when creating an `HRSErrorPresenter`.
 
 @param error             The error the corresponding `HRSErrorPresenter` will
                          show.
 @param completionHandler The completion handler that should be invoked after
                          error recovery completed.
 
 @return The delegate to be used by the `HRSErrorPresenter` instance.
 */
+ (instancetype)delegateWithError:(NSError *)error completionHandler:(void(^ _Nullable)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_END
