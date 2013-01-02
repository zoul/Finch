#define alClearError alGetError

extern NSString *const FIErrorDomain;
extern NSString *const FIOpenALErrorCodeKey;

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
+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode OpenALCode: (ALenum) underlyingCode;

@end