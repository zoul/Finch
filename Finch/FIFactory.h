#import "FILogger.h"

@class FISoundEngine, FISound, FIRevolverSound;

@interface FIFactory : NSObject

@property(retain) NSSet *soundDecoders;
@property(retain) NSBundle *soundBundle;
@property(copy) FILogger logger;

- (FISoundEngine*) buildSoundEngine;

- (FIRevolverSound*) buildSoundNamed: (NSString*) soundName rounds: (NSUInteger) rounds;
- (FISound*) buildSoundNamed: (NSString*) soundName;

@end
