#import "Application.h"
#import "Controller.h"

@implementation Application
@synthesize window, controller;

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
