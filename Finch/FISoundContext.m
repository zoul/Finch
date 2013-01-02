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
    if (!_handle) {
        if (error) {
            *error = [FIError errorWithMessage:@"Can’t create OpenAL context"
                code:FISoundContextErrorCreate OpenALCode:alGetError()];
        }
        return nil;
    }

    return self;
}

- (void) dealloc
{
    if (_handle) {
        if ([self isCurrent]) {
            [self setCurrent:NO];
        }
        alcDestroyContext(_handle);
        _handle = 0;
    }
}

#pragma mark Switching

- (BOOL) isCurrent
{
    return (alcGetCurrentContext() == _handle);
}

- (void) setCurrent: (BOOL) flag
{
    alcMakeContextCurrent(flag ? _handle : NULL);
}

@end
