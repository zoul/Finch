#import "FIFactory.h"
#import "FIError.h"

@interface FIFactoryTests : SenTestCase
@property(strong) FIFactory *factory;
@end

@implementation FIFactoryTests
@synthesize factory;

- (void) testNonExistentSoundHandling
{
    FISound *sound = nil;
    NSError *error = nil;
    STAssertNoThrow({
        sound = [factory loadSoundNamed:@"none_such" error:&error];
    },  @"Loading a non-existent sound does not throw.");
    STAssertNil(sound, @"Loading a non-existent sound returns nil.");
    STAssertNotNil(error, @"Loading a non-existent sound sets the error object.");
    STAssertEquals([error code], FIErrorFileReadFailed,
        @"Loading a non-existent sound returns appropriate error code.");
}

- (void) setUp
{
    [super setUp];
    [self setFactory:[[FIFactory alloc] init]];
    [factory setSoundBundle:[NSBundle bundleForClass:[self class]]];
}

- (void) tearDown
{
    [self setFactory:nil];
    [super tearDown];
}

@end
