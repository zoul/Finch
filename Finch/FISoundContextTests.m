#import "FISoundContext.h"
#import "FISoundDevice.h"

@interface FISoundContextTests : SenTestCase
@end

@implementation FISoundContextTests

- (void) testContextCreation
{
    FISoundDevice *device = [FISoundDevice defaultSoundDevice];
    FISoundContext *context = [[FISoundContext alloc] initWithDevice:device error:NULL];
    STAssertNotNil(context, @"Create a context");
}

@end
