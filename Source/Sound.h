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
    double length;
    float gain;
}

// Sound length in seconds.
@property(readonly) double length;
// Is the sound currently playing?
@property(readonly) BOOL playing;
// Should the sound loop?
@property(assign) BOOL loop;
// Sound gain.
@property(assign) float gain;

- (id) initWithFile: (NSString*) name;
- (id) initWithFile: (NSString*) name error: (NSError**) error;

- (void) play;
- (void) stop;

@end
