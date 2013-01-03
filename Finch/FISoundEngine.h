#import "FISound.h"

@interface FISoundEngine : NSObject

@property(strong) NSBundle *soundBundle;

+ (id) sharedEngine;

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error;
- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error;

@end