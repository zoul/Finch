@import Foundation;
@import OpenAL;

@class FISampleBuffer;

@interface FISampleDecoder : NSObject

+ (FISampleBuffer*) decodeSampleAtPath: (NSString*) path error: (NSError**) error;

@end
