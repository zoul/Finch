typedef enum {
    FISampleFormatMono8,
    FISampleFormatMono16,
    FISampleFormatStereo8,
    FISampleFormatStereo16
} FISampleFormat;

FISampleFormat FISampleFormatMake(NSUInteger numberOfChannels, NSUInteger sampleResolution);