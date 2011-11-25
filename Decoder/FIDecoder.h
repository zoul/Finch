@class FISample;

@interface FIDecoder : NSObject

- (FISample*) decodeSampleAtPath: (NSString*) path error: (NSError**) error;

@end
