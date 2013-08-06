@class FISampleBuffer;

@interface FISampleDecoder : NSObject

+ (FISampleBuffer*) decodeSampleAtPath: (NSString*) path andName: (NSString *) name error: (NSError**) error;

@end
