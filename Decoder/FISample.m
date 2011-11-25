#import "FISample.h"

@implementation FISample
@synthesize duration, hasNativeEndianity, numberOfChannels, bitsPerChannel, sampleRate, data;

- (ALenum) openALFormat
{
    return numberOfChannels == 1 ?
        (bitsPerChannel == 16 ? AL_FORMAT_MONO16 : AL_FORMAT_MONO8) :
        (bitsPerChannel == 16 ? AL_FORMAT_STEREO16 : AL_FORMAT_STEREO8);
}

@end
