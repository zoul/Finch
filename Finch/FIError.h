extern NSString *const FIErrorDomain;

enum {
    FIErrorFileReadFailed = 1,
    FIErrorFileFormatReadFailed,
    FIErrorMemoryAllocationFailed,
    FIErrorInvalidFileFormat,
    FIErrorInvalidNumberOfChannels,
    FIErrorInvalidEndianity,
    FIErrorInvalidSampleResolution,
    FIErrorOpenALError
};

@interface FIError : NSObject

+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode;

@end