#import "HRSAlertManager.h"
#import "HRSErrorPresenter.h"
#import "HRSAlertController.h"

typedef void (^CompletionHandlerWrapper)(BOOL);

@interface HRSAlertManager ()<HRSAlertControllerDelegate>

@end

@implementation HRSAlertManager

+ (instancetype)sharedInstance
{
    static HRSAlertManager *_sharedAlertManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAlertManager = [HRSAlertManager new];
    });

    return _sharedAlertManager;
}


- (nonnull HRSAlertController*)presentError:(nonnull NSError *)error onViewController:(nonnull UIViewController *)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler

{
    HRSErrorPresenter *presenter = [HRSErrorPresenter presenterWithError:error completionHandler:completionHandler];
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    [viewController presentViewController:presenter animated:YES completion:^{
        if (completionHandler) {
            completionHandler(YES);
        }
    }];
    return presenter;
}


- (nonnull HRSAlertController*)presentError:(nonnull NSError *)error delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler
{
    UIViewController *transparentVC = [UIViewController new];
    transparentVC.view.backgroundColor = [UIColor clearColor];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = transparentVC;
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelAlert + 1;
    [window makeKeyAndVisible];
    
    __weak typeof(self) weakself = self;
    __weak typeof(transparentVC) weakVC = transparentVC;
    CompletionHandlerWrapper completionHandlerWrapper = ^void(BOOL success) {
        typeof(weakself) self = weakself;
        typeof(weakVC) transparentVC = weakVC;
        if (self == nil) {
            return;
        }
        window.rootViewController = nil;
        if (completionHandler) {
            completionHandler(YES);
        }
    };
    
    HRSErrorPresenter *presenter = [HRSErrorPresenter presenterWithError:error completionHandler:completionHandlerWrapper];
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    
    [transparentVC presentViewController:presenter animated:YES completion:NULL];
    return presenter;
}


- (nonnull HRSAlertController*)presentAlert:(nonnull NSString*)title message:(nonnull NSString*)message actions:(nonnull NSArray<UIAlertAction*>*)actions onViewController:(UIViewController*)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate
{
    HRSAlertController *alertController = [HRSAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (delegate) {
        alertController.alertDelegate = delegate;
    }

    for (UIAlertAction *action in actions) {
        [alertController addAction:action];
    }

    [viewController presentViewController:alertController animated:YES completion:NULL];
    return alertController;
}

- (nonnull HRSAlertController*)present:(nonnull HRSErrorPresenter *)presenter onViewController:(UIViewController*)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler
{
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    [viewController presentViewController:presenter animated:YES completion:NULL];
    return presenter;
}



@end
