#import "FISampleBuffer.h"
#import "FIError.h"

@implementation FISampleBuffer {
    ALuint _buffer;
}

#pragma mark Initialization

- (id) initWithData: (NSData*) data sampleRate: (NSUInteger) sampleRate
    sampleFormat: (FISampleFormat) sampleFormat error: (NSError**) error
{
    self = [super init];

    if (data != nil) {
        _sampleFormat = sampleFormat;
        _sampleRate = sampleRate;
        _numberOfSamples = [data length] / [self bytesPerSample];
    } else {
        return nil;
    }

    FI_INIT_ERROR_IF_NULL(error);
    ALenum status = ALC_NO_ERROR;

    if (!alcGetCurrentContext()) {
        *error = [FIError errorWithMessage:@"No OpenAL context"
            code:FISampleBufferErrorNoOpenALContext];
        return nil;
    }

    alClearError();
    alGenBuffers(1, &_buffer);
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to create OpenAL buffer"
            code:FISampleBufferErrorAllocationFailed OpenALCode:status];
        return nil;
    }

    alClearError();
    alBufferData(_buffer, [self OpenALSampleFormat], [data bytes], [data length], sampleRate);
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to pass sample data to OpenAL"
            code:FISampleBufferErrorDataUploadFailed OpenALCode:status];
        return nil;
    }

    return self;
}

- (void) dealloc
{
    if (_buffer) {
        alDeleteBuffers(1, &_buffer);
        _buffer = 0;
    }
}

#pragma mark Calculations

- (ALenum) OpenALSampleFormat
{
    switch (_sampleFormat) {
        case FISampleFormatMono8:
            return AL_FORMAT_MONO8;
        case FISampleFormatMono16:
            return AL_FORMAT_MONO16;
        case FISampleFormatStereo8:
            return AL_FORMAT_STEREO8;
        case FISampleFormatStereo16:
            return AL_FORMAT_STEREO16;
    }
}

- (NSUInteger) bytesPerSample
{
    switch (_sampleFormat) {
        case FISampleFormatMono8:
            return 1;
        case FISampleFormatMono16:
            return 2;
        case FISampleFormatStereo8:
            return 2;
        case FISampleFormatStereo16:
            return 4;
    }
}

- (NSTimeInterval) duration
{
    return (NSTimeInterval) _numberOfSamples / _sampleRate;
}

@end
