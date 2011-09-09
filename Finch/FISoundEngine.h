#import "FILogger.h"

@interface FISoundEngine : NSObject

@property(copy) FILogger logger;
@property(readonly) BOOL isRunning;

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName;

- (BOOL) openAudioDevice;
- (void) closeAudioDevice;

@end