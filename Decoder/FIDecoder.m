#import "FIDecoder.h"
#import "FISample.h"
#import "FIError.h"

@implementation FIDecoder

- (NSError*) errorWithCode: (NSUInteger) errorCode message: (NSString*) message
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:FIErrorDomain code:errorCode userInfo:userInfo];
}

- (FISample*) decodeSampleAtPath: (NSString*) path error: (NSError**) error
{
    NSParameterAssert(path);

    OSStatus errcode = noErr;
    UInt32 propertySize;
    AudioFileID fileId = 0;
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    error = error ? error : &(NSError*){ nil };

    errcode = AudioFileOpenURL((__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileId);
    if (errcode) {
        *error = [self
            errorWithCode:FIErrorFileReadFailed
            message:@"Can’t open file."];
        return nil;
    }

    AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
    if (errcode) {
        *error = [self
            errorWithCode:FIErrorFileFormatReadFailed
            message:@"Can’t read file format."];
        AudioFileClose(fileId);
        return nil;
    }

    if (fileFormat.mFormatID != kAudioFormatLinearPCM) {
        *error = [self
            errorWithCode:FIErrorInvalidFileFormat
            message:@"Audio format not linear PCM."];
        AudioFileClose(fileId);
        return nil;
    }

    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
    if (errcode) {
        *error = [self
            errorWithCode:FIErrorFileFormatReadFailed
            message:@"Can’t read audio data byte count."];
        AudioFileClose(fileId);
        return nil;
    }

    double sampleLength = -1;
    propertySize = sizeof(sampleLength);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &sampleLength);
    if (errcode) {
        *error = [self
            errorWithCode:FIErrorFileFormatReadFailed
            message:@"Can’t read estimated audio duration."];
        AudioFileClose(fileId);
        return nil;
    }

    UInt32 dataSize = (UInt32) fileSize;
    void *data = malloc(dataSize);
    if (!data) {
        *error = [self
            errorWithCode:FIErrorMemoryAllocationFailed
            message:@"Can’t allocate memory for audio data."];
        AudioFileClose(fileId);
        return nil;
    }

    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [self
            errorWithCode:FIErrorFileFormatReadFailed
            message:@"Can’t read audio data from file."];
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
