#import "FISoundEngine.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

#import "FISampleBufferConstructor.h"

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
    
    _sounds = [NSMutableDictionary dictionaryWithCapacity:1];

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
    if ([self.sounds objectForKey:soundName]) {
        return (FISound*)[self.sounds objectForKey:soundName];
    }
    
    FISound *sound = [[FISound alloc]
                      initWithPath:[_soundBundle pathForResource:soundName ofType:nil] andName:soundName
                      maxPolyphony:voices error:error];
    if (sound)
        [self.sounds setObject:sound forKey:soundName];
    
    return sound;
}

- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error
{
    return [self soundNamed:soundName maxPolyphony:1 error:error];
}

- (void) playSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices
{
    if ([self.sounds objectForKey:soundName]) {
        [((FISound*)[self.sounds objectForKey:soundName]) play];
    }
    else {
        NSOperationQueue *opQueue = [FISoundEngine sharedOperationQueue];
        FISampleBufferConstructor *bufferConstructor = [[FISampleBufferConstructor alloc] initWithSoundNamed:soundName maxPolyphony:voices];

        [bufferConstructor setQueuePriority:NSOperationQueuePriorityVeryLow];
        
        // start the construction operation, will load and play sound in queue.
        [opQueue addOperation:bufferConstructor];
    }
}

+(NSOperationQueue *)sharedOperationQueue {
    @synchronized( [FISoundEngine class] ) {
        static NSOperationQueue *sharedQueue = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedQueue = [[NSOperationQueue alloc] init];
            [sharedQueue setName:@"FISampleBufferConstructor"];
            [sharedQueue setMaxConcurrentOperationCount:1]; // try to minimize lag while we construct these
        });
        return sharedQueue;
    }
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