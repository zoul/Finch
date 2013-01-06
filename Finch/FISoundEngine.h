#import "FISound.h"

@interface FISoundEngine : NSObject

@property(strong) NSBundle *soundBundle;
@property(assign, nonatomic, getter = isSuspended) BOOL suspended;

+ (id) sharedEngine;

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error;
- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error;

@end