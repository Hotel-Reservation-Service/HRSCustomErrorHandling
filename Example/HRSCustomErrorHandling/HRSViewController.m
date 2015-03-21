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

#import "HRSViewController.h"

@interface HRSViewController ()

@property (nonatomic, weak, readwrite) IBOutlet UISwitch *allowOverwriteSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UITextField *pathTextField;
@property (nonatomic, weak, readwrite) IBOutlet UITextView *textView;

@end


@implementation HRSViewController

- (NSURL *)baseURL {
	// if baseURL returns nil, we use no base URL, thus we do not need to
	// handle a potential error here!
	NSURL *baseURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	return baseURL;
}

- (void)visualizeSuccess {
	self.view.backgroundColor = [UIColor greenColor];
	[UIView animateWithDuration:2.0 animations:^{
		self.view.backgroundColor = [UIColor whiteColor];
	}];
}

- (void)visualizeFailure {
	self.view.backgroundColor = [UIColor redColor];
	[UIView animateWithDuration:2.0 animations:^{
		self.view.backgroundColor = [UIColor whiteColor];
	}];
}

- (NSError *)willPresentError:(NSError *)anError {
	if ([anError.domain isEqualToString:NSCocoaErrorDomain] &&
		anError.code == NSFileWriteFileExistsError) {
		
		HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
		[attempter addCancelRecoveryOption];
		[attempter addRecoveryOptionWithTitle:@"Overwrite" recoveryAttempt:^BOOL{
			[self.allowOverwriteSwitch setOn:YES animated:YES];
			return YES;
		}];
		
		NSString *localizedFailureReason = @"File already exists.";
		NSString *localizedRecoverySuggestion = @"Do you want to overwrite the existing file? This action can not be undone!";
		
		NSDictionary *userInfo = @{
								   NSLocalizedFailureReasonErrorKey: localizedFailureReason,
								   NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestion,
								   NSLocalizedRecoveryOptionsErrorKey: attempter.localizedRecoveryOptions,
								   NSRecoveryAttempterErrorKey: attempter
								   };
		
		NSError *upgradedError = [NSError errorWithDomain:anError.domain code:anError.code userInfo:userInfo];
		return upgradedError;
	}
	return [super willPresentError:anError];
}

- (BOOL)saveContent:(NSString *)text toFile:(NSURL *)fileURL overwrite:(BOOL)overwrite error:(NSError **)error {
	NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
	
	NSDataWritingOptions options = (overwrite ? NSDataWritingAtomic : NSDataWritingWithoutOverwriting);
	
	return [data writeToURL:fileURL options:options error:error];
}

- (IBAction)saveFile:(id)sender {
	NSURL *baseURL = [self baseURL];
	NSURL *fileURL = [NSURL URLWithString:self.pathTextField.text relativeToURL:baseURL];
	
	NSError *saveError = nil;
	BOOL saved = [self saveContent:self.textView.text toFile:fileURL overwrite:self.allowOverwriteSwitch.isOn error:&saveError];
	if (saved) {
		[self visualizeSuccess];
	} else {
		[self presentError:saveError completionHandler:^(BOOL didRecover) {
			if (didRecover) {
				[self saveFile:sender];
			} else {
				[self visualizeFailure];
			}
		}];
	}
}

- (IBAction)saveMultipleTimes:(id)sender {
    for (int i = 0; i < 5; i++) {
        [self saveFile:sender];
    }
}

@end
