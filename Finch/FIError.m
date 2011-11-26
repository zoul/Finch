#import "FIError.h"

NSString *const FIErrorDomain = @"FIErrorDomain";

@implementation FIError

+ (id) errorWithMessage: (NSString*) message code: (NSUInteger) errorCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:FIErrorDomain code:errorCode userInfo:userInfo];
}

@end