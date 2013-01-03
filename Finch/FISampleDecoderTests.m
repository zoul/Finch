#import "FISampleDecoder.h"
#import "FISampleBuffer.h"

@interface FISampleDecoderTests : SenTestCase
@end

@implementation FISampleDecoderTests

- (void) testInitializationWithEmptyPath
{
    FISampleDecoder *decoder = [[FISampleDecoder alloc] init];
    FISampleBuffer *buffer = nil;
    STAssertNoThrow(
        buffer = [decoder decodeSampleAtPath:nil error:NULL],
        @"Do not throw when attempting to decode sample at nil path");
    STAssertNil(buffer, @"Return nil when decoding sample at nil path");
}

@end
