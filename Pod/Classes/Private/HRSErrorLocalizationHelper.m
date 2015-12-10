#import "HRSErrorLocalizationHelper.h"

@implementation HRSErrorLocalizationHelper

+ (NSString *)localizedTitleFromKey:(NSString *)key
{
    NSBundle *uiKitBundle = [NSBundle bundleForClass:[UIResponder class]];
    return [uiKitBundle localizedStringForKey:key value:key table:nil];
}

+ (NSString *)okLocalization
{
    NSString *title = [self localizedTitleFromKey:@"OK"];
    return title;
}

+ (NSString *)cancelLocalization
{
    NSString *title = [self localizedTitleFromKey:@"Cancel"];
    return title;
}


@end
