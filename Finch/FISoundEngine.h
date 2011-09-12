#import "FILogger.h"

@interface FISoundEngine : NSObject

@property(copy) FILogger logger;
@property(readonly) BOOL isRunning;
@property(retain) AVAudioSession *audioSession;

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName;
- (void) deactivateAudioSession;

- (BOOL) openAudioDevice;
- (void) closeAudioDevice;

@end