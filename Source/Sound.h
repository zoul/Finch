#import <OpenAL/al.h>
#import <OpenAL/alc.h>

enum SoundError {
    kSEInvalidNumberOfChannels = 1,
    kSEInvalidEndianity,
    kSEInvalidSampleResolution
};

@interface Sound : NSObject
{
    BOOL loop;
    ALuint source, buffer;
    float gain, pitch, duration;
}

// Sound length in seconds.
@property(readonly) float duration;
// Is the sound currently playing?
@property(readonly) BOOL playing;
// Should the sound loop?
@property(assign, nonatomic) BOOL loop;
// Sound gain.
@property(assign, nonatomic) float gain;
// Sound pitch.
@property(assign, nonatomic) float pitch;

// Designated initializer. The format
// is AL_FORMAT_{MONO,STEREO}{8,16}.
- (id) initWithData: (const ALvoid*) data size: (ALsizei) size
    format: (ALenum) format sampleRate: (ALsizei) frequency
    duration: (float) seconds;
    
// Convenience initializer, will decode the
// sound for you using the Decoder class.
- (id) initWithFile: (NSURL*) fileURL error: (NSError**) error;

// Just as the one above, logs errors using NSLog
// instead of reporting through NSError.
- (id) initWithFile: (NSURL*) fileURL;

- (void) play;
- (void) stop;

@end
