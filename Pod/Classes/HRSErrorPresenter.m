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

#import "HRSErrorPresenter.h"

#import <objc/runtime.h>

#import "HRSErrorLocalizationHelper.h"
#import "HRSErrorPresenterDelegate.h"
#import "HRSErrorRecoveryAttempter.h"


@interface HRSErrorPresenter ()

@property (nonatomic, strong, readwrite) HRSErrorPresenterDelegate *presenterDelegate;

@end


@implementation HRSErrorPresenter

@dynamic delegate; // prevent warning

+ (instancetype)presenterWithError:(NSError *)error completionHandler:(void (^)(BOOL))completionHandler
{
	return [[self alloc] initWithError:error completionHandler:completionHandler];
}

- (instancetype)initWithError:(NSError *)error completionHandler:(void (^)(BOOL))completionHandler
{
	HRSErrorPresenterDelegate *delegate = [HRSErrorPresenterDelegate delegateWithError:error completionHandler:completionHandler];
	
    
    self = [HRSErrorPresenter alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
	
    NSArray *recoveryOptions = error.localizedRecoveryOptions;
    if (recoveryOptions.count == 0) { // the error does not have recovery options... try to be intelligent...
        id recoveryAttempter = error.recoveryAttempter;
        if (recoveryAttempter && [recoveryAttempter isKindOfClass:[HRSErrorRecoveryAttempter class]]) {
            // the recovery attempter belongs to the HRSCustomErrorHandling
            // framework. Let's use its recovery options!
            recoveryOptions = ((HRSErrorRecoveryAttempter *)recoveryAttempter).localizedRecoveryOptions;
        }
    }
    if (recoveryOptions.count == 0) {
        // Still no recovery options found. Fall back to a default ok localization
        recoveryOptions = @[ [HRSErrorLocalizationHelper okLocalization] ];
    }
    
	for (NSString *title in [recoveryOptions reverseObjectEnumerator]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completionHandler) {
                completionHandler(YES);
            }
        }];
        [self addAction:action];
	}
	
    self.presenterDelegate = delegate; //TODO: throw out?!
	
	return self;
}


@end
