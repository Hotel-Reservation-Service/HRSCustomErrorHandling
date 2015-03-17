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

#import "HRSErrorRecoveryAttempter.h"

#import <objc/message.h>


@interface HRSErrorRecoveryAttempter ()

@property (nonatomic, strong, readwrite) NSMutableArray *recoveryOptions;
@property (nonatomic, strong, readwrite) NSMutableArray *recoveryAttempts;

@end


@implementation HRSErrorRecoveryAttempter

- (instancetype)init
{
	self = [super init];
	if (self) {
		_recoveryOptions = [NSMutableArray new];
		_recoveryAttempts = [NSMutableArray new];
	}
	return self;
}

- (void)addRecoveryOptionWithTitle:(NSString *)title recoveryAttempt:(BOOL(^)())recoveryBlock
{
	NSParameterAssert(title);
	NSParameterAssert(recoveryBlock);
	if (title == nil || recoveryBlock == NULL) {
		return;
	}
	
	[self.recoveryOptions addObject:title];
	[self.recoveryAttempts addObject:[recoveryBlock copy]];
}



#pragma mark - Convenience options

- (NSString *)_localizedTitleFromKey:(NSString *)key
{
	NSBundle *uiKitBundle = [NSBundle bundleForClass:[UIResponder class]];
	return [uiKitBundle localizedStringForKey:key value:key table:nil];
}

- (void)addOkayRecoveryOption
{
	NSString *title = [self _localizedTitleFromKey:@"OK"];
	[self addRecoveryOptionWithTitle:title recoveryAttempt:^BOOL{
		return NO;
	}];
}

- (void)addCancelRecoveryOption
{
	NSString *title = [self _localizedTitleFromKey:@"Cancel"];
	[self addRecoveryOptionWithTitle:title recoveryAttempt:^BOOL{
		return NO;
	}];
}

- (NSArray *)localizedRecoveryOptions
{
	return [self.recoveryOptions copy];
}



#pragma mark - NSErrorRecoveryAttempting

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
	BOOL(^recoveryBlock)() = self.recoveryAttempts[recoveryOptionIndex];
	return recoveryBlock();
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo
{
	// method signature:
	// - (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo;
	BOOL didRecover = [self attemptRecoveryFromError:error optionIndex:recoveryOptionIndex];
	((void (*)(id delegate, SEL selector, BOOL didRecover, void *contextInfo))objc_msgSend)(delegate, didRecoverSelector, didRecover, contextInfo);
}

@end
