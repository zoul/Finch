#import "FISoundContext.h"
#import "FISoundDevice.h"
#import "FIError.h"

@implementation FISoundContext

#pragma mark Initialization

- (id) initWithDevice: (FISoundDevice*) device error: (NSError**) error
{
    self = [super init];

    if (!device) {
        return nil;
    }

    alClearError();
    _device = device;
    _handle = alcCreateContext([device handle], 0);
    FI_INIT_ERROR_IF_NULL(error);
    if (!_handle) {
        *error = [FIError errorWithMessage:@"Can’t create OpenAL context"
            code:FIErrorCannotCreateContext OpenALCode:alGetError()];
        return nil;
    }

    return self;
}

+ (id) contextForDevice: (FISoundDevice*) device error: (NSError**) error
{
    return [(FISoundContext*) [self alloc] initWithDevice:device error:error];
}

- (void) dealloc
{
    if (_handle) {
        if ([self isActive]) {
            [self setActive:NO];
        }
        alcDestroyContext(_handle);
        _handle = 0;
    }
}

#pragma mark Switching

- (BOOL) isActive
{
    return (alcGetCurrentContext() == _handle);
}

- (void) setActive: (BOOL) flag
{
    alcMakeContextCurrent(flag ? _handle : NULL);
}

@end
