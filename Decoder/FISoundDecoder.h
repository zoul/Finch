@class FISoundSample;

@protocol FISoundDecoder <NSObject>

- (NSSet*) supportedFileExtensions;
- (FISoundSample*) decodeFileAtPath: (NSString*) path error: (NSError**) error;

@end
