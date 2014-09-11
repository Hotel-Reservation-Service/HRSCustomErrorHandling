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

@interface HRSErrorRecoveryAttempter : NSObject

/**
 Add a recovery option to the attempter that is used for presentation and error
 recovery.
 
 The recovery options are stored in the order they are added to the recovery
 attempter. The first option that is added should be the default option. The
 default option shout *not* be a destructive operation.
 
 @warning Make sure to add at least one recovery block that returns `NO`,
          such as a cancel recovery option, to make sure the user can break the
          error presentation cycle in the case your error recovery was not
          successful even though it should have been.
 
 @param title         A localized title to be shown on a button to represent
                      the functionality of the recovery block.
 @param recoveryBlock The block that will be executed if the user selects
                      this recovery option.
 */
- (void)addRecoveryOptionWithTitle:(NSString *)title recoveryAttempt:(BOOL(^)())recoveryBlock;

/**
 A convenience method to adds a recovery option that does no recovery and is
 represented on a button as 'OK'.
 
 The text is localized in all languages supported by UIKit.
 */
- (void)addOkayRecoveryOption;

/**
 A convenience method to adds a recovery option that does no recovery and is
 represented on a button as 'Cancel'.
 
 The text is localized in all languages supported by UIKit.
 */
- (void)addCancelRecoveryOption;

/**
 The localized recovery option titles that have been added to the attempter.
 
 This method is ment to provide a convenience way to add the localized
 recovery options to a `NSError` as the `NSLocalizedRecoveryOptionsErrorKey`.
 
 @return The array with all localized recovery option titles. The first title
         is the default recovery option.
 */
- (NSArray *)localizedRecoveryOptions;

@end
