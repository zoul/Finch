#import "FILogger.h"

@class FISoundEngine, FISound;

@interface FIFactory : NSObject

@property(strong) NSBundle *soundBundle;
@property(copy) FILogger logger;

- (FISoundEngine*) buildSoundEngine;

- (FISound*) loadSoundNamed: (NSString*) soundName;
- (FISound*) loadSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices;

@end
