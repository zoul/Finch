#import "SNDError.h"

static NSString *const kErrorDomain = @"Sound Engine";

@implementation SNDError

+ (NSError*) errorWithCode: (int) code
{
    return [self errorWithDomain:kErrorDomain
        code:code userInfo:nil];
}

+ (NSError*) errorWithCode: (int) code description: (NSString*) msg
{
    return [NSError errorWithDomain:kErrorDomain
        code:code userInfo:[NSDictionary dictionaryWithObject:msg
        forKey:NSLocalizedDescriptionKey]];
}

@end
