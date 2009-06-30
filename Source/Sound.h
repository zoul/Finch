#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface Sound : NSObject
{
    BOOL loop;
    ALuint source, buffer;
}

@property(readonly) BOOL playing;
@property(assign) BOOL loop;

- (void) play;
- (void) stop;

@end
