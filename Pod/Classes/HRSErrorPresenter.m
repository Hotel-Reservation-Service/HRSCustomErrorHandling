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
#import "HRSErrorPresenterDelegate.h"


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
	
	self = [super initWithTitle:[error localizedFailureReason] message:[error localizedRecoverySuggestion] delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
	
	for (NSString *title in [[error localizedRecoveryOptions] reverseObjectEnumerator]) {
		[self addButtonWithTitle:title];
	}
	
	self.presenterDelegate = delegate;
	
	return self;
}


@end
