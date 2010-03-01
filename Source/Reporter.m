#import "Reporter.h"

@implementation Reporter

#pragma mark Initialization

- (id) initWithDomain: (NSString*) errDomain
{
    [super init];
    domain = [errDomain retain];
    return self;
}

+ (id) forDomain: (NSString*) errDomain
{
    return [[[self alloc] initWithDomain:errDomain] autorelease];
}

- (void) dealloc
{
    [domain release];
    [super dealloc];
}

#pragma mark Error Reporting

- (NSError*) errorWithCode: (int) code
{
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

- (NSError*) errorWithCode: (int) code description: (NSString*) msg
{
    return [NSError errorWithDomain:domain code:code
        userInfo:[NSDictionary dictionaryWithObject:msg
            forKey:NSLocalizedDescriptionKey]];
}

@end
