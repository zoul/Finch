#import "FISampleBuffer.h"
#import "FIError.h"

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
    
    // iOS appears to have issues with alBufferDataStatic, we'll avoid using it to be safe
    // http://books.google.ca/books?id=QoxeAqTvevIC&pg=PA509&lpg=PA509&dq=alBufferDataStatic&source=bl&ots=fLRdN_PBe4&sig=S9xFWvwSQVx4Qa1tXTBWw-PRTK0&hl=en&sa=X&ei=Hcf2UZeIO5be4APk5ICADA&ved=0CEEQ6AEwAw#v=onepage&q=alBufferDataStatic&f=false
    // http://benbritten.com/2009/09/20/albufferdatastatic-why-you-should-avoid-it/
    alGenBuffers(1, &_handle);
    alBufferData(_handle, [self OpenALSampleFormat], data, dataSize, sampleRate);
    
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
