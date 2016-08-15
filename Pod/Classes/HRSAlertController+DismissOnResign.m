#import "HRSAlertController+DismissOnResign.h"

#import <objc/runtime.h>


@interface HRSAlertViewDismissOnResignObserverWatcher : NSObject

+ (instancetype)watcherWithObserver:(id)observer;

@property (nonatomic, strong, readwrite) id observer;

@end


static const void *ResignActiveObserver = (void *)&ResignActiveObserver;


@implementation HRSAlertController (DismissOnResign)

@dynamic HRS_dismissOnApplicationResignActive;

- (void)setHRS_dismissOnApplicationResignActive:(BOOL)dismissOnApplicationResignActive
{
    HRSAlertViewDismissOnResignObserverWatcher *watcher = objc_getAssociatedObject(self, ResignActiveObserver);

    if (dismissOnApplicationResignActive) {
        if (watcher.observer != nil) {
            return;
        }
        __weak typeof(self) weakSelf = self;
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            typeof(weakSelf) self = weakSelf;
            self.alertDelegate = nil;
            [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
        }];
        objc_setAssociatedObject(self, ResignActiveObserver, [HRSAlertViewDismissOnResignObserverWatcher watcherWithObserver:observer], OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, ResignActiveObserver, nil, OBJC_ASSOCIATION_RETAIN); // will remove the observer
    }
}


@end


@implementation HRSAlertViewDismissOnResignObserverWatcher

+ (instancetype)watcherWithObserver:(id)observer
{
    return [[self alloc] initWithObserver:observer];
}


- (instancetype)initWithObserver:(id)observer
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _observer = observer;
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}


@end
