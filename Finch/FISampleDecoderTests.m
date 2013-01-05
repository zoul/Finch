#import "FITestCase.h"
#import "FISampleDecoder.h"
#import "FISampleBuffer.h"

@interface FISampleDecoderTests : FITestCase
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

- (void) test8BitMonoDecoding
{
    NSError *error = nil;
    FISampleBuffer *buffer = [FISampleDecoder decodeSampleAtPath:
        [[self soundBundle] pathForResource:@"mono8bit" ofType:@"wav"] error:&error];
    STAssertNotNil(buffer, @"Load 8-bit mono sample: %@", error);
    STAssertEquals([buffer sampleRate], (NSUInteger)44100, @"Detect sample rate for 8-bit mono files");
    STAssertEquals([buffer sampleFormat], FISampleFormatMono8, @"Detect sample format for 8-bit mono files");
    STAssertEquals([buffer bytesPerSample], (NSUInteger)1, @"Detect bytes per sample for 8-bit mono files");
    STAssertEquals([buffer duration], (NSTimeInterval)1, @"Calculate sample duration for 8-bit mono files");
}

- (void) test8BitStereoDecoding
{
    NSError *error = nil;
    FISampleBuffer *buffer = [FISampleDecoder decodeSampleAtPath:
        [[self soundBundle] pathForResource:@"stereo8bit" ofType:@"wav"] error:&error];
    STAssertNotNil(buffer, @"Load 8-bit stereo sample: %@", error);
    STAssertEquals([buffer sampleRate], (NSUInteger)44100, @"Detect sample rate for 8-bit stereo files");
    STAssertEquals([buffer sampleFormat], FISampleFormatStereo8, @"Detect sample format for 8-bit stereo files");
    STAssertEquals([buffer bytesPerSample], (NSUInteger)2, @"Detect bytes per sample for 8-bit stereo files");
    STAssertEquals([buffer duration], (NSTimeInterval)1, @"Calculate sample duration for 8-bit stereo files");
}

- (void) test16BitMonoDecoding
{
    NSError *error = nil;
    FISampleBuffer *buffer = [FISampleDecoder decodeSampleAtPath:
        [[self soundBundle] pathForResource:@"mono16bit" ofType:@"wav"] error:&error];
    STAssertNotNil(buffer, @"Load 16-bit mono sample: %@", error);
    STAssertEquals([buffer sampleRate], (NSUInteger)44100, @"Detect sample rate for 16-bit mono files");
    STAssertEquals([buffer sampleFormat], FISampleFormatMono16, @"Detect sample format for 16-bit mono files");
    STAssertEquals([buffer bytesPerSample], (NSUInteger)2, @"Detect bytes per sample for 16-bit mono files");
    STAssertEquals([buffer duration], (NSTimeInterval)1, @"Calculate sample duration for 16-bit mono files");
}

- (void) test16BitStereoDecoding
{
    NSError *error = nil;
    FISampleBuffer *buffer = [FISampleDecoder decodeSampleAtPath:
        [[self soundBundle] pathForResource:@"stereo16bit" ofType:@"wav"] error:&error];
    STAssertNotNil(buffer, @"Load 16-bit stereo sample: %@", error);
    STAssertEquals([buffer sampleRate], (NSUInteger)44100, @"Detect sample rate for 16-bit stereo files");
    STAssertEquals([buffer sampleFormat], FISampleFormatStereo16, @"Detect sample format for 16-bit stereo files");
    STAssertEquals([buffer bytesPerSample], (NSUInteger)4, @"Detect bytes per sample for 16-bit stereo files");
    STAssertEquals([buffer duration], (NSTimeInterval)1, @"Calculate sample duration for 16-bit stereo files");
}

@end
