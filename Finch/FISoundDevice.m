#import "FISoundDevice.h"

@implementation FISoundDevice

#pragma mark Initialization

- (id) initWithName: (NSString*) deviceName
{
    self = [super init];
    _handle = alcOpenDevice([deviceName cStringUsingEncoding:NSUTF8StringEncoding]);
    return (_handle ? self : nil);
}

- (void) dealloc
{
    if (_handle) {
        alcCloseDevice(_handle);
        _handle = 0;
    }
}

#pragma mark Convenience Initializers

+ (id) deviceNamed: (NSString*) deviceName
{
    return [[self alloc] initWithName:deviceName];
}

// TODO: We should cache the device instances using the device name,
// but at the same time we should make it possible for the device to
// get deallocated. The current implementation keeps the default device
// alive forever.
+ (id) defaultSoundDevice
{
    static dispatch_once_t once;
    static FISoundDevice *defaultDevice = nil;
    dispatch_once(&once, ^{
        defaultDevice = [self deviceNamed:nil];
    });
    return defaultDevice;
}

@end
