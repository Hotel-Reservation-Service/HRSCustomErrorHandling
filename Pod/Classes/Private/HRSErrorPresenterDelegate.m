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

#import "HRSErrorPresenterDelegate.h"


@interface HRSErrorPresenterDelegate ()

@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, copy, readwrite) void(^completionHandler)(BOOL);

@end


@implementation HRSErrorPresenterDelegate

+ (instancetype)delegateWithError:(NSError *)error completionHandler:(void(^)(BOOL))completionHandler
{
	return [[self alloc] initWithError:error completionHandler:completionHandler];
}

- (instancetype)initWithError:(NSError *)error completionHandler:(void(^)(BOOL))completionHandler
{
	self = [super init];
	if (self) {
		_error = error;
		_completionHandler = completionHandler;
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	id recoveryAttempter = [self.error recoveryAttempter];
	// alert view button indexes are ordered oposite to the error options index!
	NSInteger optionIndex = alertView.numberOfButtons - buttonIndex - 1;
	BOOL didRecover = [recoveryAttempter attemptRecoveryFromError:self.error optionIndex:optionIndex];
	if (self.completionHandler) {
		self.completionHandler(didRecover);
	}
}

@end
