#import "FISampleFormat.h"

FISampleFormat FISampleFormatMake(NSUInteger numberOfChannels, NSUInteger sampleResolution)
{
    assert(numberOfChannels == 1 || numberOfChannels ==  2);
    assert(sampleResolution == 8 || sampleResolution == 16);

    if (numberOfChannels == 1) {
        return (sampleResolution == 8) ?
            FISampleFormatMono8 : FISampleFormatMono16;
    } else {
        return (sampleResolution == 8) ?
            FISampleFormatStereo8 : FISampleFormatStereo16;
    }
}