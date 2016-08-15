#import <UIKit/UIKit.h>

@class HRSAlertController;

@protocol HRSAlertControllerDelegate <NSObject>

- (void)alertControllerDidLayoutSubviews:(HRSAlertController*)alertController;
- (BOOL)alertControllerShouldAutorotate:(HRSAlertController*)alertController;

@end

@interface HRSAlertController : UIAlertController

@property (nonatomic, strong, readwrite) id<HRSAlertControllerDelegate>alertDelegate;

@end
