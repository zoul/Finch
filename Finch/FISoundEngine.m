#import "FISoundEngine.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

@interface FISoundEngine ()
@property(strong) FISoundDevice *soundDevice;
@property(strong) FISoundContext *soundContext;
@end

@implementation FISoundEngine

#pragma mark Initialization

- (id) init
{
    self = [super init];
    _soundDevice = [FISoundDevice defaultSoundDevice];
    _soundContext = [FISoundContext contextForDevice:_soundDevice error:NULL];
    if (_soundContext) {
        [self setSoundBundle:[NSBundle bundleForClass:[self class]]];
        [_soundContext setActive:YES];
        return self;
    } else {
        return nil;
    }
}

+ (id) sharedEngine
{
    static dispatch_once_t once;
    static FISoundEngine *sharedEngine = nil;
    dispatch_once(&once, ^{
        sharedEngine = [[self alloc] init];
    });
    return sharedEngine;
}

#pragma mark Sound Loading

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error
{
    return [[FISound alloc]
        initWithPath:[_soundBundle pathForResource:soundName ofType:nil]
        maxPolyphony:voices error:error];
}

- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error
{
    return [self soundNamed:soundName maxPolyphony:1 error:error];
}

@end