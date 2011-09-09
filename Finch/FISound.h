@class FISoundSample;

@interface FISound : NSObject

// Sound length in seconds.
@property(readonly) float duration;
// Is the sound currently playing?
@property(readonly) BOOL playing;
// Should the sound loop?
@property(assign, nonatomic) BOOL loop;
// Sound gain.
@property(assign, nonatomic) float gain;
// Sound pitch.
@property(assign, nonatomic) float pitch;

- (id) initWithSample: (FISoundSample*) sample error: (NSError**) error;

- (void) play;
- (void) stop;

@end
