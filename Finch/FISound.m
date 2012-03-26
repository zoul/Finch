#import "FISound.h"
#import "FISample.h"
#import "FIError.h"

#define CLEAR_ERROR_FLAG alGetError()
#define DETACH_SOURCE 0

@interface FISound ()
@property(assign) ALuint source, buffer;
@end

@implementation FISound
@synthesize loop, duration, gain, pitch, source, buffer;

#pragma mark Initialization

- (id) initWithSample: (FISample*) sample error: (NSError**) error
{
    self = [super init];
    error = error ? error : &(NSError*){ nil };

    if (!sample) {
        return nil;
    }

    // Check the number of channels
    if ([sample numberOfChannels] != 1 && [sample numberOfChannels] != 2) {
        *error = [FIError
            errorWithMessage:@"Invalid number of channels, only mono and stereo supported."
            code:FIErrorInvalidNumberOfChannels];
        return nil;
    }

    // Check sample resolution
    if ([sample bitsPerChannel] != 8 && [sample bitsPerChannel] != 16) {
        *error = [FIError
            errorWithMessage:@"Invalid sample resolution, only 8-bit and 16-bit samples supported."
            code:FIErrorInvalidSampleResolution];
        return nil;
    }

    // Check data endianity
    if (![sample hasNativeEndianity]) {
        *error = [FIError
            errorWithMessage:@"Wrong endianity in audio data."
            code:FIErrorInvalidEndianity];
        return nil;
    }

    // We need valid OpenAL context to continue
    if (!alcGetCurrentContext()) {
        *error = [FIError
            errorWithMessage:@"OpenAL context not set, did you initialize Finch?"
            code:FIErrorOpenALError];
        return nil;
    }

    // Allocate OpenAL buffer
    CLEAR_ERROR_FLAG;
    alGenBuffers(1, &buffer);
    if (alGetError()) {
        *error = [FIError
            errorWithMessage:@"Failed to allocate OpenAL buffer."
            code:FIErrorOpenALError];
        return nil;
    }

    // Pass sound data to OpenAL
    CLEAR_ERROR_FLAG;
    alBufferData(buffer, [sample openALFormat], [[sample data] bytes], [[sample data] length], [sample sampleRate]);
    if (alGetError()) {
        *error = [FIError
            errorWithMessage:@"Failed to fill OpenAL buffers."
            code:FIErrorOpenALError];
        return nil;
    }

    // Initialize the OpenAL source
    CLEAR_ERROR_FLAG;
    alGenSources(1, &source);
    alSourcei(source, AL_BUFFER, buffer);
    if (alGetError()) {
        *error = [FIError
            errorWithMessage:@"Failed to create OpenAL source."
            code:FIErrorOpenALError];
        return nil;
    }

    gain = 1;
    duration = [sample duration];
    return self;
}

// Clears the error flag.
- (BOOL) checkSuccessOrLog: (NSString*) msg
{
    ALenum errcode;
    if ((errcode = alGetError()) != AL_NO_ERROR) {
        NSLog(@"%@, error code %x.", msg, errcode);
        return NO;
    }
    return YES;
}

- (void) dealloc
{
    [self stop];
    CLEAR_ERROR_FLAG;
    if (source) {
        alSourcei(source, AL_BUFFER, DETACH_SOURCE);
    }
    if (buffer) {
        alDeleteBuffers(1, &buffer);
        buffer = 0;
    }
    if (source) {
        alDeleteSources(1, &source);
        source = 0;
    }
    [self checkSuccessOrLog:@"Failed to clean up after sound"];
}

#pragma mark Playback Controls

- (void) setGain: (float) val
{
    gain = val;
    alSourcef(source, AL_GAIN, gain);
}

- (void) setPitch: (float) val
{
    pitch = val;
    alSourcef(source, AL_PITCH, pitch);
}

- (BOOL) playing
{
    ALint state;
    alGetSourcei(source, AL_SOURCE_STATE, &state);
    return (state == AL_PLAYING);
}

- (void) setLoop: (BOOL) yn
{
    loop = yn;
    alSourcei(source, AL_LOOPING, yn);
}

- (void) play
{
    if (self.playing)
        [self stop];
    CLEAR_ERROR_FLAG;
    alSourcePlay(source);
    [self checkSuccessOrLog:@"Failed to start sound"];
}

- (void) stop
{
    if (!self.playing)
        return;
    CLEAR_ERROR_FLAG;
    alSourceStop(source);
    [self checkSuccessOrLog:@"Failed to stop sound"];
}

@end
