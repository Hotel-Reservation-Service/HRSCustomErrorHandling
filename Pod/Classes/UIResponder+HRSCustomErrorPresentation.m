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

#import "UIResponder+HRSCustomErrorPresentation.h"

#import "HRSErrorPresenter.h"


@implementation UIResponder (HRSCustomErrorPresentation)

- (void)presentError:(NSError *)error completionHandler:(void (^)(BOOL didRecover))completionHandler
{
	error = [self willPresentError:error];
	
	if (error == nil) {
		return;
	}
	
	UIApplication *application = [UIApplication sharedApplication];
	BOOL responderDelegateUnavailable = ![application.delegate isKindOfClass:[UIResponder class]];
	
	if (application.delegate == self ||
		(application == self && responderDelegateUnavailable)) {
		// this is the default implementation of the app delegate or the
		// application itself, if its delegate does not inherit from UIResponder.
		[[HRSErrorPresenter presenterWithError:error completionHandler:completionHandler] show];
		
	} else {
		UIResponder *nextResponder = ([self nextResponder] ?: [UIApplication sharedApplication]);
		[nextResponder presentError:error completionHandler:completionHandler];
	}
}

- (NSError *)willPresentError:(NSError *)error
{
	return error;
}

@end
