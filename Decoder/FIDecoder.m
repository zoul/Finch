#import "FIDecoder.h"
#import "FISample.h"
#import "FIError.h"

@implementation FIDecoder

- (FISample*) decodeSampleAtPath: (NSString*) path error: (NSError**) error
{
    NSParameterAssert(path);

    OSStatus errcode = noErr;
    UInt32 propertySize;
    AudioFileID fileId = 0;
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    error = error ? error : &(NSError*){ nil };

    errcode = AudioFileOpenURL((CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileId);
    if (errcode) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorFileReadFailed userInfo:nil];
        return nil;
    }

    AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
    if (errcode) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorFileFormatReadFailed userInfo:nil];
        AudioFileClose(fileId);
        return nil;
    }

    // TODO: Is this needed?
    if (fileFormat.mFormatID != kAudioFormatLinearPCM) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorInvalidFileFormat userInfo:nil];
        AudioFileClose(fileId);
        return nil;
    }

    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
    if (errcode) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorFileFormatReadFailed userInfo:nil];
        AudioFileClose(fileId);
        return nil;
    }

    double sampleLength = -1;
    propertySize = sizeof(sampleLength);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &sampleLength);
    if (errcode) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorFileFormatReadFailed userInfo:nil];
        AudioFileClose(fileId);
        return nil;
    }

    UInt32 dataSize = (UInt32) fileSize;
    void *data = malloc(dataSize);
    if (!data) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorMemoryAllocationFailed userInfo:nil];
        AudioFileClose(fileId);
        return nil;
    }

    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [NSError errorWithDomain:FIErrorDomain code:FIErrorFileFormatReadFailed userInfo:nil];
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

    return [sample autorelease];
}

@end
