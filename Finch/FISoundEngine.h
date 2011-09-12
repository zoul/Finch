#import "FILogger.h"

@interface FISoundEngine : NSObject

@property(copy) FILogger logger;
@property(readonly) BOOL isRunning;

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName;
- (void) deactivateAudioSession;

- (BOOL) openAudioDevice;
- (void) closeAudioDevice;

@end