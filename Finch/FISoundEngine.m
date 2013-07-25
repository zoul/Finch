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
    _soundsCalledToLoad = [NSMutableSet setWithCapacity:1];
    
    _lastTidyTime = 0;

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

- (void) playSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices {
    [self playSoundNamed:soundName maxPolyphony:voices withCacheDuration:DEFAULT_SOUND_CACHE_DURATION];
}

- (void) playSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices withCacheDuration: (float)cacheDuration
{
    if (!soundName)
        return;
    @synchronized( [FISoundEngine class] ) {
        if ([self.sounds objectForKey:soundName]) {
            FISound * sound = ((FISound*)[self.sounds objectForKey:soundName]);
            if (cacheDuration < 0.0)
                cacheDuration = 0.0;
            [sound setCacheDuration:cacheDuration];
            
            [sound play];            
        }
        else {
            //if we've already made a call to load this sound, don't do it again.
            if ([self.soundsCalledToLoad containsObject:soundName]) {
                return;
            }
            [self.soundsCalledToLoad addObject:soundName];
            
            NSOperationQueue *opQueue = [FISoundEngine sharedOperationQueue];
            FISampleBufferConstructor *bufferConstructor = [[FISampleBufferConstructor alloc] initWithSoundNamed:soundName maxPolyphony:voices withCacheDuration:cacheDuration andShouldPlay:YES];
            
            [bufferConstructor setQueuePriority:NSOperationQueuePriorityVeryLow];
            
            // start the construction operation, will load and play sound in queue.
            [opQueue addOperation:bufferConstructor];
        }
        
        [self tidyBuffers];
     }
}

- (void) loadSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices withCacheDuration: (float)cacheDuration
{
    if (!soundName)
        return;
    @synchronized( [FISoundEngine class] ) {
        if ([self.sounds objectForKey:soundName]) {
            FISound * sound = ((FISound*)[self.sounds objectForKey:soundName]);
            if (cacheDuration < 0.0)
                cacheDuration = 0.0;
            [sound setCacheDuration:cacheDuration];
        }
        else {
            //if we've already made a call to load this sound, don't do it again.
            if ([self.soundsCalledToLoad containsObject:soundName]) {
                return;
            }
            [self.soundsCalledToLoad addObject:soundName];
            
            NSOperationQueue *opQueue = [FISoundEngine sharedOperationQueue];
            FISampleBufferConstructor *bufferConstructor = [[FISampleBufferConstructor alloc] initWithSoundNamed:soundName maxPolyphony:voices withCacheDuration:cacheDuration andShouldPlay:NO];
            
            [bufferConstructor setQueuePriority:NSOperationQueuePriorityVeryLow];
            
            // start the construction operation, will load and play sound in queue.
            [opQueue addOperation:bufferConstructor];
        }
        
        [self tidyBuffers];
    }
}

+ (NSOperationQueue*) sharedOperationQueue {
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
#pragma mark Sound Management

- (void) tidyBuffers {
     NSTimeInterval currentTime = [[NSDate date ] timeIntervalSince1970];
    //only tidy memory every so often
    if (self.lastTidyTime < (currentTime - TIDY_SOUND_BUFFERS_INTERVAL)) {
        self.lastTidyTime = currentTime;
        
        NSMutableArray *deadSounds = [NSMutableArray arrayWithCapacity:0];
        for (NSString *soundKey in [self.sounds allKeys]) {
            FISound *sound = self.sounds[soundKey];
            NSTimeInterval soundDuration = sound.duration;
            if ((sound.lastPlayTime + soundDuration + sound.cacheDuration) < currentTime) {
                [sound stop];
                [deadSounds addObject:soundKey];
            }
        }
        //actually remove the sounds from the list, cleaning up sources and buffers.
        for (NSString *soundKey in deadSounds) {
            [self.sounds removeObjectForKey:soundKey];
            [self.soundsCalledToLoad removeObject:soundKey];
        }
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