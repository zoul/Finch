#import "FISound.h"
#import "FISampleDecoder.h"
#import "FISampleBuffer.h"
#import "FISoundSource.h"

@interface FISound ()
@property(strong) NSArray *voices;
@property(assign) NSUInteger currentVoiceIndex;
@end

@implementation FISound
@dynamic isPlaying, loop, gain, pitch, duration;

#pragma mark Initialization

- (id) initWithPath: (NSString*) path andName: (NSString *) name maxPolyphony: (NSUInteger) maxPolyphony error: (NSError**) error
{
    self = [super init];
    _voices = @[];

    FISampleBuffer *buffer = [FISampleDecoder decodeSampleAtPath:path andName:name error:error];
    if (!buffer || !maxPolyphony) {
        return nil;
    }
    
    for (int i=0; i<maxPolyphony; i++) {
        FISoundSource *voice = [[FISoundSource alloc] initWithSampleBuffer:buffer error:error];
        if (voice) {
            _voices = [_voices arrayByAddingObject:voice];
        } else {
            return nil;
        }
    }

    return self;
}

- (id) initWithPath: (NSString*) path andName: (NSString *) name error: (NSError**) error
{
    return [self initWithPath:path andName:name maxPolyphony:1 error:error];
}

#pragma mark Playback

- (void) play
{
    _currentVoiceIndex = (_currentVoiceIndex + 1) % [_voices count];
    [(FISoundSource*) [_voices objectAtIndex:_currentVoiceIndex] play];
}

- (void) stop
{
    for (FISound *voice in _voices) {
        [voice stop];
    }
}

#pragma mark Sound Properties

- (NSTimeInterval) duration
{
    return [[[_voices lastObject] sampleBuffer] duration];
}

- (void) forwardInvocation: (NSInvocation*) invocation
{
    for (FISoundSource *voice in _voices)
        [invocation invokeWithTarget:voice];
}

- (NSMethodSignature*) methodSignatureForSelector: (SEL) selector
{
    NSMethodSignature *our = [super methodSignatureForSelector:selector];
    NSMethodSignature *voiced = [[_voices lastObject] methodSignatureForSelector:selector];
    return our ? our : voiced;
}

@end
