#import "FISound.h"
#import "FISoundSample.h"
#import "FIErrorReporter.h"
#import "FIError.h"

#define CLEAR_ERROR_FLAG alGetError()
#define DETACH_SOURCE 0

@interface FISound ()
@property(assign) ALuint source, buffer;
@end

@implementation FISound
@synthesize loop, duration, gain, pitch, source, buffer;

// Clears the error flag.
- (BOOL) checkSuccessOrLog: (NSString*) msg
{
    ALenum errcode;
    if ((errcode = alGetError()) != AL_NO_ERROR)
    {
        NSLog(@"%@, error code %x.", msg, errcode);
        return NO;
    }
    return YES;
}

#pragma mark Designated Initializer

- (id) initWithData: (const ALvoid*) data size: (ALsizei) size
    format: (ALenum) format sampleRate: (ALsizei) frequency
    duration: (float) seconds
{
    [super init];
    
    ALCcontext *const currentContext = alcGetCurrentContext();
    if (currentContext == NULL)
    {
        NSLog(@"OpenAL context not set, did you initialize Finch?");
        return nil;
    }
    
    // Allocate buffer.
    CLEAR_ERROR_FLAG;
    alGenBuffers(1, &buffer);
    if (![self checkSuccessOrLog:@"Failed to allocate OpenAL buffer"])
        return nil;

    // Pass sound data to OpenAL.
    CLEAR_ERROR_FLAG;
    alBufferData(buffer, format, data, size, frequency);
    if (![self checkSuccessOrLog:@"Failed to fill OpenAL buffers"])
        return nil;
    
    // Initialize the source.
    CLEAR_ERROR_FLAG;
    alGenSources(1, &source);
    alSourcei(source, AL_BUFFER, buffer);
    if (![self checkSuccessOrLog:@"Failed to create OpenAL source"])
        return nil;

    gain = 1;
    duration = seconds;
    return self;
}

- (void) dealloc
{
    [self stop];
    CLEAR_ERROR_FLAG;
    alSourcei(source, AL_BUFFER, DETACH_SOURCE);
    alDeleteBuffers(1, &buffer), buffer = 0;
    alDeleteSources(1, &source), source = 0;
    [self checkSuccessOrLog:@"Failed to clean up after sound"];
    [super dealloc];
}

- (id) initWithSample: (FISoundSample*) sample error: (NSError**) error
{
    if (!sample)
        return nil;
    
    FIErrorReporter *reporter = [FIErrorReporter forDomain:@"Sound Initialization" error:error];
    
    // Check the number of channels
    if (sample.channels != 1 && sample.channels != 2) {
        *error = [reporter errorWithCode:FIErrorInvalidNumberOfChannels];
        return nil;
    }
    
    // Check sample resolution
    if (sample.bitsPerChannel != 8 && sample.bitsPerChannel != 16) {
        *error = [reporter errorWithCode:FIErrorInvalidSampleResolution];
        return nil;
    }
    
    // Check data endianity
    if (sample.endianity != kLittleEndian) {
        *error = [reporter errorWithCode:FIErrorInvalidEndianity];
        return nil;
    }
    
    const ALenum format = sample.channels == 1 ?
        (sample.bitsPerChannel == 16 ? AL_FORMAT_MONO16 : AL_FORMAT_MONO8) :
        (sample.bitsPerChannel == 16 ? AL_FORMAT_STEREO16 : AL_FORMAT_STEREO8);
    return [self initWithData:sample.data.bytes size:sample.data.length
        format:format sampleRate:sample.sampleRate duration:sample.duration];
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
