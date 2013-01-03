#import "FILogger.h"

@interface FISoundEngine : NSObject

@property(copy) FILogger logger;
@property(readonly) BOOL isRunning;
@property(readonly) BOOL isSuspended;
@property(strong) AVAudioSession *audioSession;

- (BOOL) activateAudioSessionWithCategory: (NSString*) categoryName;
- (void) deactivateAudioSession;

- (BOOL) openAudioDevice;
- (void) closeAudioDevice;
- (void) suspendAudioDevice;
- (void) resumeAudioDevice;

@end