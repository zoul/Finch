#import "FILogger.h"

@class FISoundEngine, FISound, FIRevolverSound;

@interface FIFactory : NSObject

@property(retain) NSSet *soundDecoders;
@property(retain) NSBundle *soundBundle;
@property(copy) FILogger logger;

- (FISoundEngine*) buildSoundEngine;

- (FISound*) buildSoundNamed: (NSString*) soundName;
- (FISound*) buildSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices;

@end
