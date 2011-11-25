@class FISample;

@interface FISound : NSObject

@property(readonly) float duration;
@property(readonly) BOOL playing;

@property(assign, nonatomic) BOOL loop;
@property(assign, nonatomic) float gain;
@property(assign, nonatomic) float pitch;

- (id) initWithSample: (FISample*) sample error: (NSError**) error;

- (void) play;
- (void) stop;

@end
