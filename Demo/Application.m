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
    NSError *error = nil; BOOL success = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    success = [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSAssert1(success, @"Failed to set audio session category: %@", error);
    success = [session setActive:YES error:&error];
    NSAssert1(success, @"Failed to activate audio session: %@", error);
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
