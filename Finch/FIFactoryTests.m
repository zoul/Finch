#import "FIFactory.h"

@interface FIFactoryTests : SenTestCase
@property(retain) FIFactory *factory;
@end

@implementation FIFactoryTests
@synthesize factory;

- (void) testNonExistentSoundHandling
{
    FISound *soundA = nil, *soundB = nil;
    STAssertNoThrow({
        soundA = [factory loadSoundNamed:@"none_such"];
        soundB = [factory loadSoundNamed:@"none_such" maxPolyphony:2];
    },  @"Loading a non-existent sound does not throw.");
    STAssertNil(soundA, @"Loading a non-existent sound returns nil.");
    STAssertNil(soundB, @"Loading a non-existent revolver sound returns nil.");
}

- (void) setUp
{
    [super setUp];
    factory = [[FIFactory alloc] init];
    [factory setSoundBundle:[NSBundle bundleForClass:[self class]]];
}

- (void) tearDown
{
    [factory release];
    [super tearDown];
}

@end
