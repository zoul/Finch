#import "FISoundDevice.h"

@interface FISoundDeviceTests : SenTestCase
@end

@implementation FISoundDeviceTests

- (void) testDefaultDeviceInitialization
{
    STAssertNotNil([FISoundDevice defaultSoundDevice], @"Get default sound device");
}

@end
