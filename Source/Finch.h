#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface Finch : NSObject
{
    ALCdevice *device;
    ALCcontext *context;
    BOOL userMusicPlaying;
}

@property(readonly) BOOL userMusicPlaying;

@end
