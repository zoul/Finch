#import "Sample.h"

@implementation Sample
@synthesize channels, bitsPerChannel, sampleRate, endianity, duration, data;

- (id) init
{
    [super init];
    channels = bitsPerChannel = sampleRate = duration = -1;
    endianity = kEndianityUnknown;
    return self;
}

- (void) dealloc
{
    [data release];
    [super dealloc];
}

@end
