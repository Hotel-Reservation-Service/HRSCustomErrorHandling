#import <UIKit/UIKit.h>
#import "HRSAlertController.h"

@interface HRSAlertController (DismissOnResign)

/**
 *  Automatically dismisses the alert controller if the application is resigned active.
 */
@property (nonatomic, assign, readwrite) BOOL HRS_dismissOnApplicationResignActive;

@end
