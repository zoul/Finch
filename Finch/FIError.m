#import "FIError.h"

NSString *const FIErrorDomain = @"FIErrorDomain";
NSString *const FIOpenALErrorCodeKey = @"FIOpenALErrorCodeKey";

@implementation FIError

+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode
{
    return [NSError errorWithDomain:FIErrorDomain code:errorCode userInfo:@{
        NSLocalizedDescriptionKey : message
    }];
}

+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode OpenALCode: (ALenum) underlyingCode
{
    return [NSError errorWithDomain:FIErrorDomain code:errorCode userInfo:@{
        NSLocalizedDescriptionKey : message,
        FIOpenALErrorCodeKey : @(underlyingCode)
    }];
}

@end