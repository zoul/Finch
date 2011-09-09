#import "FISoundEngine.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface FISoundEngine ()
@property(assign) ALCdevice *device;
@property(assign) ALCcontext *context;
@end

@implementation FISoundEngine
@synthesize device, context, logger;

- (id) init
{
    [super init];
    [self setLogger:FILoggerNull];
    
    device = alcOpenDevice(NULL);
    if (!device) {
        NSLog(@"Finch: Could not open default OpenAL device.");
        [self release];
        return nil;
    }
    
    context = alcCreateContext(device, 0);
    if (!context) {
        NSLog(@"Finch: Failed to create OpenAL context for default device.");
        [self release];
        return nil;
    }
    
    const BOOL success = alcMakeContextCurrent(context);
    if (!success) {
        NSLog(@"Finch: Failed to set current OpenAL context.");
        [self release];
        return nil;
    }
    
    return self;
}

- (void) dealloc
{
    [logger release];
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);
    [super dealloc];
}

@end