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
@property(assign) BOOL loop;
// Sound gain.
@property(assign) float gain;
// Sound pitch.
@property(assign) float pitch;

- (id) initWithFile: (NSString*) name;
- (id) initWithFile: (NSString*) name error: (NSError**) error;

- (void) play;
- (void) stop;

@end
