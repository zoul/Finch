#import "Application.h"
#import "Controller.h"
#import "FISoundEngine.h"
#import "FIFactory.h"

@interface Application ()
@property(strong) FIFactory *soundFactory;
@property(strong) FISoundEngine *soundEngine;
@end

@implementation Application
@synthesize window, controller, soundFactory, soundEngine;

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    soundFactory = [[FIFactory alloc] init];
    [soundFactory setLogger:FILoggerNSLog];

    [self setSoundEngine:[soundFactory buildSoundEngine]];
    [soundEngine activateAudioSessionWithCategory:AVAudioSessionCategoryPlayback];
    [soundEngine openAudioDevice];

    [controller setSitarSound:[soundFactory loadSoundNamed:@"sitar.wav"]];
    [controller setGunSound:[soundFactory loadSoundNamed:@"shot.wav" maxPolyphony:4]];

    [window setRootViewController:controller];
    [window makeKeyAndVisible];
}

@end
