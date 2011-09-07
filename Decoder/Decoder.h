@class Sample;

enum DecoderError
{
    kDENoSuitableDecoderFound = 1,
    kDEFileReadError,
    kDEFileFormatReadError,
    kDEInvalidFileFormat,
    kDEMemoryAllocationError
};

@interface Decoder : NSObject {}

+ (void) registerDecoder: (Class) c forExtension: (NSString*) ext;
+ (Sample*) decodeFile: (NSURL*) fileURL error: (NSError**) error;

@end
