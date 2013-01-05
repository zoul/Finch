#import "FITestCase.h"
#import "FISound.h"

@interface FISoundTests : FITestCase
@end

@implementation FISoundTests

- (void) testInitializationWithNilPath
{
    FISound *sound = nil;
    STAssertNoThrow(
        sound = [[FISound alloc] initWithPath:nil error:NULL],
        @"Do not throw when trying to load a sound from a nil path");
    STAssertNil(sound, @"Return nil when loading a sound from a nil path");
}

- (void) testBasicLoading
{
    NSString *path = [[self soundBundle] pathForResource:@"mono8bit" ofType:@"wav"];
    FISound *sound = [[FISound alloc] initWithPath:path error:NULL];
    STAssertNotNil(sound, @"Load a basic sound");
}

@end
