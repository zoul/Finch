#import "Sound.h"
#import <AudioToolbox/AudioToolbox.h> 

#define CLEAR_ERROR_FLAG alGetError()
#define DETACH_SOURCE 0

@implementation Sound
@synthesize loop;

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

- (id) initWithData: (ALvoid*) data length: (ALsizei) size
    format: (ALenum) format sampleRate: (ALsizei) frequency 
{
    [super init];
    
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
