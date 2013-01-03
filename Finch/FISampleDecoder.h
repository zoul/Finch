@class FISampleBuffer;

enum {
    FISampleDecoderErrorNone,
    FISampleDecoderErrorFileRead,
    FISampleDecoderErrorFileFormatInvalid,
    FISampleDecoderErrorMemoryAllocation,
    FISampleDecoderErrorBufferCreate
};

@interface FISampleDecoder : NSObject

- (FISampleBuffer*) decodeSampleAtPath: (NSString*) path error: (NSError**) error;

@end
