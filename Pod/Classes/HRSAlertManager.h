#import <Foundation/Foundation.h>
#import "HRSAlertController.h"
@class HRSErrorPresenter;
@class HRSAlertController;
@class UIAlertAction;

@interface HRSAlertManager : NSObject

+ (nullable instancetype)sharedInstance;

/**
 *  present on a specific view controller
 */
- (nonnull HRSAlertController*)presentError:(nonnull NSError *)error onViewController:(nonnull UIViewController *)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler;
- (nonnull HRSAlertController*)present:(nonnull HRSErrorPresenter *)presenter onViewController:(UIViewController*)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler;
- (nonnull HRSAlertController*)presentAlert:(nonnull NSString*)title message:(nonnull NSString*)message actions:(nonnull NSArray<UIAlertAction*>*)actions onViewController:(UIViewController*)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate;

/**
 *  present as a dedicated view controller inside a dedicated window on top of the current window
 */
- (nonnull HRSAlertController*)presentError:(nonnull NSError *)error delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler;

- (nonnull HRSAlertController*)presentOKAlert:(nonnull NSString*)title message:(nonnull NSString*)message actions:(nonnull NSArray<UIAlertAction*>*)actions delegate:(nullable id<HRSAlertControllerDelegate>)delegate;
- (nonnull HRSAlertController*)presentCancelAlert:(nonnull NSString*)title message:(nonnull NSString*)message actions:(nonnull NSArray<UIAlertAction*>*)actions delegate:(nullable id<HRSAlertControllerDelegate>)delegate;




/**
 *  Convencience
 */
- (void)dismissCurrentAlertAnimated:(BOOL)animated;
- (void)dismissAllAlerts;

@end
