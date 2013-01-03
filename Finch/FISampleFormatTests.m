#import "FISampleFormat.h"

@interface FISampleFormatTests : SenTestCase
@end

@implementation FISampleFormatTests

- (void) testConvenienceConversion
{
    NSString *description = @"Convenience conversion from channels and resolution";
    STAssertTrue(FISampleFormatMake(1,  8) == FISampleFormatMono8, description);
    STAssertTrue(FISampleFormatMake(1, 16) == FISampleFormatMono16, description);
    STAssertTrue(FISampleFormatMake(2,  8) == FISampleFormatStereo8, description);
    STAssertTrue(FISampleFormatMake(2, 16) == FISampleFormatStereo16, description);
}

@end
