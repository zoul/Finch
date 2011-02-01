#import "Finch.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface Finch ()
@property(assign) ALCdevice *device;
@property(assign) ALCcontext *context;
@end

@implementation Finch
@synthesize device, context;

- (id) init
{
    [super init];
    
    device = alcOpenDevice(NULL);
    if (!device) {
        NSLog(@"Finch: Could not open default OpenAL device.");
        return nil;
    }
    
    context = alcCreateContext(device, 0);
    if (!context) {
        NSLog(@"Finch: Failed to create OpenAL context for default device.");
        return nil;
    }
    
    BOOL success = alcMakeContextCurrent(context);
    if (!success) {
        NSLog(@"Finch: Failed to set current OpenAL context.");
        return nil;
    }
    
    return self;
}

- (void) dealloc
{
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);
    [super dealloc];
}

@end