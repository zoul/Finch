#import "Application.h"
#import "Controller.h"

@implementation Application
@synthesize window, controller;

#if TARGET_IPHONE_SIMULATOR
#error The demo has to be run on the device.
#endif

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [window addSubview:controller.view];
    [window makeKeyAndVisible];
}

- (void) dealloc
{
    [controller release];
    [window release];
    [super dealloc];
}

@end
