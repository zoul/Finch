#import "FISampleDecoder.h"
#import "FISampleBuffer.h"

@interface FISampleDecoderTests : SenTestCase
@end

@implementation FISampleDecoderTests

- (void) testInitializationWithEmptyPath
{
    FISampleBuffer *buffer = nil;
    STAssertNoThrow(
        buffer = [FISampleDecoder decodeSampleAtPath:nil error:NULL],
        @"Do not throw when attempting to decode sample at nil path");
    STAssertNil(buffer, @"Return nil when decoding sample at nil path");
}

@end
