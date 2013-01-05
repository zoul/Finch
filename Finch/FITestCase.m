#import "FITestCase.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

@implementation FITestCase

- (void) setUp
{
    [super setUp];
    _soundBundle = [NSBundle bundleForClass:[self class]];
    _soundContext = [FISoundContext contextForDevice:[FISoundDevice defaultSoundDevice] error:NULL];
    [_soundContext setActive:YES];
}

- (void) tearDown
{
    _soundBundle = nil;
    _soundContext = nil;
    [super tearDown];
}

@end
