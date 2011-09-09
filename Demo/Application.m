#import "Application.h"
#import "Controller.h"
#import "FIFactory.h"

@interface Application ()
@property(retain) FIFactory *soundFactory;
@property(retain) FISoundEngine *soundEngine;
@end

@implementation Application
@synthesize window, controller, soundFactory, soundEngine;

- (void) openAudioSession
{
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSAssert(error == nil, @"Failed to set audio session category.");
    [session setActive:YES error:&error];
    NSAssert(error == nil, @"Failed to activate audio session.");
}

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [self openAudioSession];
    
    soundFactory = [[FIFactory alloc] init];
    [self setSoundEngine:[soundFactory buildSoundEngine]];
    [controller setSitarSound:[soundFactory buildSoundNamed:@"sitar.wav"]];
    [controller setGunSound:[soundFactory buildSoundNamed:@"shot.wav" rounds:4]];
    
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
