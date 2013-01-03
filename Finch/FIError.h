// http://www.mikeash.com/pyblog/friday-qa-2011-02-18-compound-literals.html
#define FI_INIT_ERROR_IF_NULL(error) error = error ? error : &(NSError*){ nil }
#define alClearError alGetError

extern NSString *const FIErrorDomain;
extern NSString *const FIOpenALErrorCodeKey;

@interface FIError : NSObject

+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode;
+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode OpenALCode: (ALenum) underlyingCode;

@end