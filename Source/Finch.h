#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface Finch : NSObject
{
    ALCdevice *device;
    ALCcontext *context;
}

+ (BOOL) isUserMusicPlaying;

@end
