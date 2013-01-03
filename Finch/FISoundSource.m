#import "FISoundSource.h"
#import "FISampleBuffer.h"
#import "FIError.h"

@interface FISoundSource ()
@property(assign) ALuint handle;
@property(strong) FISampleBuffer *sampleBuffer;
@end

@implementation FISoundSource

#pragma mark Initialization

- (id) initWithSampleBuffer: (FISampleBuffer*) buffer error: (NSError**) error
{
    self = [super init];

    if (!buffer) {
        return nil;
    }

    alClearError();
    alGenSources(1, &_handle);
    alSourcei(_handle, AL_BUFFER, [buffer handle]);
    ALenum status = alGetError();
    if (status) {
        *error = [FIError
            errorWithMessage:@"Failed to create OpenAL source"
            code:FISoundSourceErrorCreate OpenALCode:status];
        return nil;
    }

    _sampleBuffer = buffer;
    _gain = 1;

    return self;
}

- (void) dealloc
{
    if (_handle) {
        alSourcei(_handle, AL_BUFFER, 0 /* detach */);
        alDeleteSources(1, &_handle);
        _handle = 0;
    }
}

#pragma mark Playback

- (void) play
{
    if ([self isPlaying]) {
        [self stop];
    }
    alSourcePlay(_handle);
}

- (void) stop
{
    if ([self isPlaying]) {
        alSourceStop(_handle);
    }
}

- (BOOL) isPlaying
{
    ALint state;
    alGetSourcei(_handle, AL_SOURCE_STATE, &state);
    return (state == AL_PLAYING);
}

#pragma mark Sound Properties

- (void) setGain: (float) value
{
    alSourcef(_handle, AL_GAIN, value);
    _gain = value;
}

- (void) setPitch: (float) value
{
    alSourcef(_handle, AL_PITCH, value);
    _pitch = value;
}

- (void) setLoop: (BOOL) yn
{
    alSourcei(_handle, AL_LOOPING, yn);
    _loop = yn;
}


@end
