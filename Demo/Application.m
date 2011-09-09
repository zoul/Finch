#import "Application.h"
#import "Controller.h"
#import "FISoundEngine.h"
#import "FIFactory.h"

@interface Application ()
@property(retain) FIFactory *soundFactory;
@property(retain) FISoundEngine *soundEngine;
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

    [controller setSitarSound:[soundFactory buildSoundNamed:@"sitar.wav"]];
    [controller setGunSound:[soundFactory buildSoundNamed:@"shot.wav" maxPolyphony:4]];

    [window setRootViewController:controller];
    [window makeKeyAndVisible];
}

- (void) dealloc
{
    [soundFactory release];
    [soundEngine release];
    [controller release];
    [window release];
    [super dealloc];
}

@end
