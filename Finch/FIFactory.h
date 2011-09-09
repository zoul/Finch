#import "FILogger.h"

@class FISoundEngine;

@interface FIFactory : NSObject

@property(copy) FILogger logger;

- (FISoundEngine*) buildSoundEngine;

@end
