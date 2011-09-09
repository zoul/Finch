#import "FIFactory.h"
#import "FISoundEngine.h"

@implementation FIFactory
@synthesize logger;

#pragma mark Initalization

- (id) init
{
    self = [super init];
    [self setLogger:FILoggerNull];
    return self;
}

- (void) dealloc
{
    [logger release];
    [super dealloc];
}

#pragma mark Public Components

- (FISoundEngine*) buildSoundEngine
{
    FISoundEngine *engine = [[FISoundEngine alloc] init];
    [engine setLogger:logger];
    return [engine autorelease];
}

@end
