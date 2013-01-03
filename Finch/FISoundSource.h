@class FISampleBuffer;

enum {
    FISoundSourceErrorNone,
    FISoundSourceErrorCreate
};

@interface FISoundSource : NSObject

@property(strong, readonly) FISampleBuffer *sampleBuffer;
@property(assign, readonly) BOOL isPlaying;

@property(assign, nonatomic) BOOL loop;
@property(assign, nonatomic) float gain;
@property(assign, nonatomic) float pitch;

- (id) initWithSampleBuffer: (FISampleBuffer*) buffer error: (NSError**) error;

- (void) play;
- (void) stop;

@end
