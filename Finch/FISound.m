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

#pragma mark Initialization

- (BOOL) checkFormatConstaintsForSample: (FISample*) sample error: (NSError**) error
{
    error = error ? error : &(NSError*){ nil };

    // Check the number of channels
    if ([sample numberOfChannels] != 1 && [sample numberOfChannels] != 2) {
        *error = [NSError errorWithDomain:FIErrorDomain
            code:FIErrorInvalidNumberOfChannels userInfo:nil];
        return NO;
    }

    // Check sample resolution
    if ([sample bitsPerChannel] != 8 && [sample bitsPerChannel] != 16) {
        *error = [NSError errorWithDomain:FIErrorDomain
            code:FIErrorInvalidSampleResolution userInfo:nil];
        return NO;
    }

    // Check data endianity
    if (![sample hasNativeEndianity]) {
        *error = [NSError errorWithDomain:FIErrorDomain
            code:FIErrorInvalidEndianity userInfo:nil];
        return NO;
    }

    return YES;
}

- (id) initWithSample: (FISample*) sample error: (NSError**) error
{
    self = [super init];
    
    if (![self checkFormatConstaintsForSample:sample error:error]) {
        [self release];
        return nil;
    }

    if (!alcGetCurrentContext()) {
        NSLog(@"OpenAL context not set, did you initialize Finch?");
        [self release];
        return nil;
    }
    
    // Allocate OpenAL buffer
    CLEAR_ERROR_FLAG;
    alGenBuffers(1, &buffer);
    if (![self checkSuccessOrLog:@"Failed to allocate OpenAL buffer"]) {
        [self release];
        return nil;
    }

    // Pass sound data to OpenAL
    CLEAR_ERROR_FLAG;
    alBufferData(buffer, [sample openALFormat], [[sample data] bytes],
        [[sample data] length], [sample sampleRate]);
    if (![self checkSuccessOrLog:@"Failed to fill OpenAL buffers"]) {
        [self release];
        return nil;
    }
    
    // Initialize the OpenAL source
    CLEAR_ERROR_FLAG;
    alGenSources(1, &source);
    alSourcei(source, AL_BUFFER, buffer);
    if (![self checkSuccessOrLog:@"Failed to create OpenAL source"]) {
        [self release];
        return nil;
    }

    gain = 1;
    duration = [sample duration];
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
