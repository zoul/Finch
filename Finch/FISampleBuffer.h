typedef enum {
    FISampleFormatMono8,
    FISampleFormatMono16,
    FISampleFormatStereo8,
    FISampleFormatStereo16
} FISampleFormat;

enum {
    FISampleBufferErrorNone,
    FISampleBufferErrorNoOpenALContext,
    FISampleBufferErrorAllocationFailed,
    FISampleBufferErrorDataUploadFailed
};

@interface FISampleBuffer : NSObject

@property(assign, readonly) NSUInteger sampleRate;
@property(assign, readonly) FISampleFormat sampleFormat;

@property(assign, readonly) NSUInteger numberOfSamples;
@property(assign, readonly) NSUInteger bytesPerSample;
@property(assign, readonly) NSTimeInterval duration;

- (id) initWithData: (NSData*) data sampleRate: (NSUInteger) sampleRate
    sampleFormat: (FISampleFormat) sampleFormat error: (NSError**) error;

@end
