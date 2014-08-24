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

#import "HRSAppDelegate.h"

@implementation HRSAppDelegate

- (NSError *)willPresentError:(NSError *)anError
{
	if (anError.recoveryAttempter == nil) {
		HRSErrorRecoveryAttempter *recoveryAttempter = [HRSErrorRecoveryAttempter new];
		[recoveryAttempter addRecoveryOptionWithTitle:@"Retry" recoveryAttempt:^{
			return YES;
		}];
		[recoveryAttempter addCancelRecoveryOption];
		
		NSDictionary *userInfo = @{
								   NSLocalizedFailureReasonErrorKey: @"Something went wrong",
								   NSLocalizedRecoverySuggestionErrorKey: @"The operation was not successfull. Please try again!",
								   NSLocalizedRecoveryOptionsErrorKey: [recoveryAttempter localizedRecoveryOptions],
								   NSRecoveryAttempterErrorKey: recoveryAttempter
								   };
		anError = [NSError errorWithDomain:anError.domain code:anError.code userInfo:userInfo];
	}
	return anError;
}

@end
