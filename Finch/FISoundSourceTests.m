#import "FITestCase.h"
#import "FISoundSource.h"
#import "FISampleBuffer.h"

@interface FISoundSourceTests : FITestCase
@end

@implementation FISoundSourceTests

- (void) testInitializationWithNilBuffer
{
    FISoundSource *source = nil;
    STAssertNoThrow(source = [[FISoundSource alloc] initWithSampleBuffer:nil error:NULL],
        @"Do not throw when creating a sound source with nil buffer");
    STAssertNil(source, @"Return a nil source for nil buffer");
}

- (void) testSoundProperties
{
    NSData *sampleData = [NSData dataWithContentsOfFile:[[self soundBundle] pathForResource:@"mono8bit" ofType:@"wav"]];
    FISampleBuffer *buffer = [[FISampleBuffer alloc] initWithData:sampleData sampleRate:44100 sampleFormat:FISampleFormatMono8 error:NULL];
    FISoundSource *source = [[FISoundSource alloc] initWithSampleBuffer:buffer error:NULL];

    STAssertEquals([source gain], 1.0f, @"Initial gain set to 1");
    STAssertEquals([source pitch], 1.0f, @"Initial pitch set to 1");
    STAssertEquals([source loop], NO, @"Do not loop by default");
    STAssertEquals([source isPlaying], NO, @"Not playing after init");

    [source play];
    STAssertEquals([source isPlaying], YES, @"Playing after calling -play");

    [source stop];
    STAssertEquals([source isPlaying], NO, @"Not playing after -stop");
}

@end
