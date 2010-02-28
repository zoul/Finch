#import "NSError+Finch.h"

static NSString *const kErrorDomain = @"Finch";

@implementation NSError (Finch)

+ (id) finchError: (int) code
{
    return [self errorWithDomain:kErrorDomain code:code userInfo:nil];
}

+ (id) finchError: (int) code withDescription: (NSString*) msg
{
    return [self errorWithDomain:kErrorDomain code:code userInfo:
        [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]];
}

@end
