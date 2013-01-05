#import "FITestCase.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

@implementation FITestCase

- (void) setUp
{
    [super setUp];
    _soundContext = [FISoundContext contextForDevice:[FISoundDevice defaultSoundDevice] error:NULL];
    [_soundContext setActive:YES];
}

- (void) tearDown
{
    _soundContext = nil;
    [super tearDown];
}

@end
