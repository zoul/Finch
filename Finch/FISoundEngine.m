#import "FISoundEngine.h"

@interface FISoundEngine ()
@property(assign) ALCdevice *device;
@property(assign) ALCcontext *context;
@property(assign) BOOL isRunning;
@property(assign) BOOL isSuspended;
@end

@implementation FISoundEngine
@synthesize device, context, logger, isRunning, isSuspended, audioSession;

#pragma mark Initialization

- (id) init
{
    self = [super init];
    [self setLogger:FILoggerNull];
    [self setAudioSession:[AVAudioSession sharedInstance]];
    return self;
}

- (void) dealloc
{
    [self closeAudioDevice];
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
    [self setIsSuspended:NO];
    return YES;
}

- (void) closeAudioDevice
{
    logger(@"Closing OpenAL audio device.");
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);
    [self setIsRunning:NO];
    [self setIsSuspended:NO];
}

- (void) suspendAudioDevice
{
    if (!self.isRunning) {
        logger(@"Can't suspend closed audio device.");
        return;
    }

    logger(@"Suspendng OpenAL audio device.");
    alcMakeContextCurrent(NULL);
    alcSuspendContext(context);
    [self setIsSuspended:YES];
}

- (void) resumeAudioDevice
{
    if (!self.isRunning) {
        logger(@"Can't resume closed audio device.");
        return;
    }

    if (!self.isSuspended) {
        logger(@"Can't resume not suspended audio device.");
        return;
    }

    logger(@"Resuming OpenAL audio device.");
    alcMakeContextCurrent(context);
    alcProcessContext(context);
    [self setIsSuspended:NO];
}

#pragma mark Audio Session Convenience

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName
{
    NSError *error = nil; BOOL success = YES;

    logger(@"Activating audio session “%@”.", categoryName);
    success = [audioSession setCategory:categoryName error:&error];
    if (!success) {
        logger(@"Failed to set audio session category: %@", error);
        return NO;
    }

    success = [audioSession setActive:YES error:&error];
    if (!success) {
        logger(@"Failed to activate audio session: %@", error);
        return NO;
    }

    return YES;
}

- (void) deactivateAudioSession
{
    NSError *error = nil;
    BOOL success = [audioSession setActive:NO error:&error];
    if (!success) {
        logger(@"Failed to deactivate audio session: %@", error);
    }
}

@end