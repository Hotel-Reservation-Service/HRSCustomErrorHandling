#import <UIKit/UIKit.h>

@class HRSAlertController;

@protocol HRSAlertControllerDelegate <NSObject>

- (void)alertControllerDidLayoutSubviews:(HRSAlertController*)alertController;
- (BOOL)alertControllerShouldAutorotate:(HRSAlertController*)alertController;
- (void)alertControllerDidDisappear:(HRSAlertController*)alertController;

@end

@interface HRSAlertController : UIAlertController

@property (nonatomic, strong, readwrite) id<HRSAlertControllerDelegate>alertDelegate;
@property (nonatomic, weak, readwrite) UIWindow *dedicatedWindow;

@end
