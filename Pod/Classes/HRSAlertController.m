#import "HRSAlertController.h"


@implementation HRSAlertController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.alertDelegate respondsToSelector:@selector(alertControllerDidLayoutSubviews:)]) {
        [self.alertDelegate alertControllerDidLayoutSubviews:self];
    }
}

- (BOOL)shouldAutorotate
{
    if ([self.alertDelegate respondsToSelector:@selector(alertControllerShouldAutorotate:)]) {
        return [self.alertDelegate alertControllerShouldAutorotate:self];
    }
    return [super shouldAutorotate];
}


@end
