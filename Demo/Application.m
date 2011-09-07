#import "Application.h"
#import "Controller.h"

@implementation Application
@synthesize window, controller;

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [window setRootViewController:controller];
    [window makeKeyAndVisible];
}

- (void) dealloc
{
    [controller release];
    [window release];
    [super dealloc];
}

@end
