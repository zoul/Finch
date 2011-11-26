#import "FILogger.h"

@class FISoundEngine, FISound;

@interface FIFactory : NSObject

@property(strong) NSBundle *soundBundle;
@property(copy) FILogger logger;

- (FISoundEngine*) buildSoundEngine;

- (FISound*) loadSoundNamed: (NSString*) soundName error: (NSError**) error;
- (FISound*) loadSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error;

@end
