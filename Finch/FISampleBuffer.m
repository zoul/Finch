#import "FISampleBuffer.h"
#import "FIError.h"

typedef ALvoid AL_APIENTRY (*alBufferDataStaticProcPtr) (const ALint bid,
ALenum format,
const ALvoid* data,
ALsizei size,
ALsizei freq);

static alBufferDataStaticProcPtr alBufferDataStatic = NULL;

@implementation FISampleBuffer

#pragma mark Initialization

- (id) initWithData: (void *) data ofLength: (NSUInteger) dataSize sampleRate: (NSUInteger) sampleRate
    sampleFormat: (FISampleFormat) sampleFormat error: (NSError**) error
{
    self = [super init];

    if (data != nil) {
        _sampleFormat = sampleFormat;
        _sampleRate = sampleRate;
        _numberOfSamples = dataSize / [self bytesPerSample];
        //theData = data;
    } else {
        return nil;
    }

    FI_INIT_ERROR_IF_NULL(error);
    ALenum status = ALC_NO_ERROR;

    if (!alcGetCurrentContext()) {
        *error = [FIError errorWithMessage:@"No OpenAL context"
            code:FIErrorNoActiveContext];
        return nil;
    }

    alClearError();
    alGenBuffers(1, &_handle);
    
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to create OpenAL buffer"
            code:FIErrorCannotCreateBuffer OpenALCode:status];
        return nil;
    }

    alClearError();
    
    theData = data;
    //alBufferDataStatic (as opposed to alBufferData) points to the passed in data, rather than copy it.
    alBufferDataStatic = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
    alBufferDataStatic(_handle, [self OpenALSampleFormat], data, dataSize, sampleRate);
    //free(data); //only needed on alBufferData, on alBufferDataStatic, we call free(data) in the dealloc.
    
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to pass sample data to OpenAL"
            code:FIErrorCannotUploadData OpenALCode:status];
        return nil;
    }

    return self;
}

- (void) dealloc
{
    if (_handle) {
        alDeleteBuffers(1, &_handle);
        _handle = 0;
        free(theData);
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
