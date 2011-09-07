#import "Reporter.h"

/*
    The dummyError trick is here to safely initialize
    the NSError** output variable passed to various methods
    that use the Reporter class. Discussion here:
    http://google.com/search?q=should+method+set+nserror
*/
static NSError *dummyError = nil;

@implementation Reporter

#pragma mark Initialization

- (id) initWithDomain: (NSString*) errDomain error: (NSError**) error
{
    [super init];
    domain = [errDomain retain];
    if (error == NULL)
        error = &dummyError;
    return self;
}

+ (id) forDomain: (NSString*) errDomain error: (NSError**) error
{
    return [[[self alloc] initWithDomain:errDomain error:error] autorelease];
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
