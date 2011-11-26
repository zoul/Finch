#import "FIDecoder.h"
#import "FISample.h"
#import "FIError.h"

@implementation FIDecoder

- (FISample*) decodeSampleAtPath: (NSString*) path error: (NSError**) error
{
    OSStatus errcode = noErr;
    UInt32 propertySize;
    AudioFileID fileId = 0;
    error = error ? error : &(NSError*){ nil };

    if (!path) {
        *error = [FIError
            errorWithMessage:@"File not found."
            code:FIErrorFileReadFailed];
        return nil;
    }

    NSURL *fileURL = [NSURL fileURLWithPath:path];
    errcode = AudioFileOpenURL((__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileId);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t open file."
            code:FIErrorFileReadFailed];
        return nil;
    }

    AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read file format."
            code:FIErrorFileFormatReadFailed];
        AudioFileClose(fileId);
        return nil;
    }

    if (fileFormat.mFormatID != kAudioFormatLinearPCM) {
        *error = [FIError
            errorWithMessage:@"Audio format not linear PCM."
            code:FIErrorInvalidFileFormat];
        AudioFileClose(fileId);
        return nil;
    }

    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read audio data byte count."
            code:FIErrorFileFormatReadFailed];
        AudioFileClose(fileId);
        return nil;
    }

    double sampleLength = -1;
    propertySize = sizeof(sampleLength);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &sampleLength);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read estimated audio duration."
            code:FIErrorFileFormatReadFailed];
        AudioFileClose(fileId);
        return nil;
    }

    UInt32 dataSize = (UInt32) fileSize;
    void *data = malloc(dataSize);
    if (!data) {
        *error = [FIError
            errorWithMessage:@"Can’t allocate memory for audio data."
            code:FIErrorMemoryAllocationFailed];
        AudioFileClose(fileId);
        return nil;
    }

    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read audio data from file."
            code:FIErrorFileFormatReadFailed];
        AudioFileClose(fileId);
        free(data);
        return nil;
    }

    AudioFileClose(fileId);

    FISample *sample = [[FISample alloc] init];
    [sample setNumberOfChannels:fileFormat.mChannelsPerFrame];
    [sample setHasNativeEndianity:TestAudioFormatNativeEndian(fileFormat)];
    [sample setBitsPerChannel:fileFormat.mBitsPerChannel];
    [sample setSampleRate:fileFormat.mSampleRate];
    [sample setDuration:sampleLength];
    [sample setData:[NSData dataWithBytesNoCopy:data length:dataSize freeWhenDone:YES]];

    return sample;
}

@end
