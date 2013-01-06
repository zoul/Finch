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
    if (!_soundContext) {
        return nil;
    }

    [self setSoundBundle:[NSBundle bundleForClass:[self class]]];
    [_soundContext setCurrent:YES];

    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark Interruption Handling

// TODO: Resume may fail here, and in that case
// we would like to keep _suspended at YES.
- (void) setSuspended: (BOOL) newValue
{
    if (newValue != _suspended) {
        _suspended = newValue;
        if (_suspended) {
            [_soundContext setCurrent:NO];
            [_soundContext setSuspended:YES];
        } else {
            [_soundContext setCurrent:YES];
            [_soundContext setSuspended:NO];
        }
    }
}

@end