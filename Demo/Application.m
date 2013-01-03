#import "Application.h"
#import "Controller.h"
#import "FISoundEngine.h"

@interface Application ()
@property(strong) FISoundEngine *soundEngine;
@end

@implementation Application
@synthesize window;

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    _soundEngine = [FISoundEngine sharedEngine];

    [_controller setSitarSound:[_soundEngine soundNamed:@"sitar.wav" error:NULL]];
    [_controller setGunSound:[_soundEngine soundNamed:@"shot.wav" maxPolyphony:4 error:NULL]];

    [window setRootViewController:_controller];
    [window makeKeyAndVisible];
}

@end
