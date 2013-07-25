#import "FISound.h"

#define TIDY_SOUND_BUFFERS_INTERVAL             5.0
#define DEFAULT_SOUND_CACHE_DURATION                20.0

@interface FISoundEngine : NSObject

@property(strong) NSBundle *soundBundle;
@property(assign, nonatomic, getter = isSuspended) BOOL suspended;

@property(strong, nonatomic) NSMutableDictionary *sounds;
@property(strong, nonatomic) NSMutableSet *soundsCalledToLoad;

@property (nonatomic) NSTimeInterval lastTidyTime;

+ (id) sharedEngine;

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error;
- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error;

- (void) playSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices;

- (void) playSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices withCacheDuration: (float)cacheDuration;

- (void) loadSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices withCacheDuration: (float)cacheDuration;

- (void) tidyBuffers;

@end