#import "HRSAlertManager.h"
#import "HRSErrorPresenter.h"
#import "HRSAlertController.h"

typedef void (^CompletionHandlerWrapper)(BOOL);

@interface HRSAlertManager ()<HRSAlertControllerDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray<HRSAlertController*> *alertQueue;

@end

@implementation HRSAlertManager

+ (instancetype)sharedInstance
{
    static HRSAlertManager *_sharedAlertManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAlertManager = [HRSAlertManager new];
        _sharedAlertManager.alertQueue = [NSMutableArray new];
    });

    return _sharedAlertManager;
}

#pragma mark - Dedicated ViewController Presentation

- (nonnull HRSAlertController*)presentError:(nonnull NSError *)error onViewController:(nonnull UIViewController *)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler

{
    HRSErrorPresenter *presenter = [HRSErrorPresenter presenterWithError:error completionHandler:completionHandler];
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    [viewController presentViewController:presenter animated:YES completion:^{
        if (completionHandler) {
            //TODO: remove from queue
            completionHandler(YES);
        }
    }];
    [self.alertQueue addObject:presenter];
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

    [self.alertQueue addObject:alertController];
    return alertController;
}

- (nonnull HRSAlertController*)present:(nonnull HRSErrorPresenter *)presenter onViewController:(UIViewController*)viewController delegate:(nullable id<HRSAlertControllerDelegate>)delegate completion:(void (^)(BOOL))completionHandler
{
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    [viewController presentViewController:presenter animated:YES completion:NULL];
    [self.alertQueue addObject:presenter];
    return presenter;
}

#pragma mark - Stand Alone Presentation

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
    [self.alertQueue addObject:presenter];
    return presenter;
}


- (nonnull HRSAlertController*)presentAlert:(nonnull NSString*)title message:(nonnull NSString*)message actions:(nonnull NSArray<UIAlertAction*>*)actions delegate:(nullable id<HRSAlertControllerDelegate>)delegate
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
    };
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: title,
                               NSLocalizedRecoverySuggestionErrorKey: message,
                               };
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:userInfo]; // good idea?
    
    HRSErrorPresenter *presenter = [HRSErrorPresenter presenterWithError:error completionHandler:completionHandlerWrapper];
    if (delegate) {
        presenter.alertDelegate = delegate;
    }
    for (UIAlertAction *action in actions) {
        [presenter addAction:action];
    }
    [transparentVC presentViewController:presenter animated:YES completion:NULL];
    return presenter;
}

#pragma mark - Convencience

- (void)dismissCurrentAlertAnimated:(BOOL)animated
{
    HRSAlertController *topAlert = self.alertQueue.firstObject;
    if (topAlert == nil) {
        return;
    }
    
    [topAlert.presentingViewController dismissViewControllerAnimated:animated completion:NULL];
}

- (void)dismissAllAlerts
{
    for (HRSAlertController *alert in self.alertQueue){
        [alert.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
    }
}


@end
