#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window;

- (UIWindow*) buildMainWindow
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    UIWindow *win = [[UIWindow alloc] initWithFrame:screenFrame];
    [win setBackgroundColor:[UIColor whiteColor]];

    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Running Tests…"];
    [label sizeToFit];

    [win addSubview:label];
    [label setCenter:CGPointMake(screenFrame.size.width/2, 100)];

    return win;
}

- (BOOL) application: (UIApplication*) application didFinishLaunchingWithOptions: (NSDictionary*) launchOptions
{
    [self setWindow:[self buildMainWindow]];
    [window makeKeyAndVisible];
    return YES;
}

@end
