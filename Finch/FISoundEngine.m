#import "FISoundEngine.h"

@interface FISoundEngine ()
@property(assign) ALCdevice *device;
@property(assign) ALCcontext *context;
@property(assign) BOOL isRunning;
@end

@implementation FISoundEngine
@synthesize device, context, logger, isRunning;

#pragma mark Initialization

- (id) init
{
    self = [super init];
    [self setLogger:FILoggerNull];
    return self;
}

- (void) dealloc
{
    [self closeAudioDevice];
    [logger release];
    [super dealloc];
}

#pragma mark OpenAL Device Management

- (BOOL) openAudioDevice
{
    logger(@"Opening OpenAL audio device.");

    device = alcOpenDevice(NULL);
    if (!device) {
        logger(@"Could not open default OpenAL device.");
        return NO;
    }
    
    context = alcCreateContext(device, 0);
    if (!context) {
        logger(@"Failed to create OpenAL context for default device.");
        return NO;
    }
    
    const BOOL success = alcMakeContextCurrent(context);
    if (!success) {
        logger(@"Failed to set current OpenAL context.");
        return NO;
    }
    
    [self setIsRunning:YES];
    return YES;
}

- (void) closeAudioDevice
{
    logger(@"Closing OpenAL audio device.");
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);
    [self setIsRunning:NO];
}

#pragma mark Audio Session Convenience

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName
{
    NSError *error = nil; BOOL success = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];

    success = [session setCategory:categoryName error:&error];
    if (!success) {
        logger(@"Failed to set audio session category: %@", error);
        return NO;
    }

    success = [session setActive:YES error:&error];
    if (!success) {
        logger(@"Failed to activate audio session: %@", error);
        return NO;
    }

    return YES;
}

- (void) deactivateAudioSession
{
    NSError *error = nil;
    BOOL success = [[AVAudioSession sharedInstance] setActive:NO error:&error];
    if (!success) {
        logger(@"Failed to deactivate audio session: %@", error);
    }
}

@end