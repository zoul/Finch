@class Sample;

enum DecoderError
{
    kDENoSuitableDecoderFound,
    kDEFileReadError,
    kDEFileFormatReadError,
    kDEInvalidFileFormat,
    kDEMemoryAllocationError
};

@interface Decoder : NSObject {}

+ (void) registerDecoder: (Class) c forExtension: (NSString*) ext;
+ (Sample*) decodeFile: (NSString*) name error: (NSError**) error;

@end
