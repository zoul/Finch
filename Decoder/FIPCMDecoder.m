#import "FIPCMDecoder.h"
#import "FISoundSample.h"
#import "FIErrorReporter.h"
#import "FIError.h"

@implementation FIPCMDecoder

- (NSSet*) supportedFileExtensions
{
    return [NSSet setWithObjects:@"wav", @"caf", nil];
}

- (FISoundSample*) decodeFileAtPath: (NSString*) path error: (NSError**) error
{
    OSStatus errcode = noErr;
    UInt32 propertySize;
    AudioFileID fileId = 0;
    FIErrorReporter *reporter = [FIErrorReporter forDomain:@"Sample Decoder" error:error];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    errcode = AudioFileOpenURL((CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileId);
    if (errcode) {
        *error = [reporter errorWithCode:FIErrorFileReadFailed];
        return nil;
    }
    
    AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
    if (errcode) {
        *error = [reporter errorWithCode:FIErrorFileFormatReadFailed];
        AudioFileClose(fileId);
        return nil;
    }

    if (fileFormat.mFormatID != kAudioFormatLinearPCM) { 
        *error = [reporter
            errorWithCode:FIErrorInvalidFileFormat
            description:@"Sound file not linear PCM."];
        AudioFileClose(fileId);
        return nil;
    }
    
    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
    if (errcode) {
        *error = [reporter
            errorWithCode:FIErrorFileFormatReadFailed
            description:@"Failed to read sound file size."];
        AudioFileClose(fileId);
        return nil;
    }

    double sampleLength = -1;
    propertySize = sizeof(sampleLength);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &sampleLength);
    if (errcode) {
        *error = [reporter
            errorWithCode:FIErrorFileFormatReadFailed
            description:@"Failed to read sound length."];
        AudioFileClose(fileId);
        return nil;
    }

    UInt32 dataSize = (UInt32) fileSize;
    void *data = malloc(dataSize);
    if (!data) {
        *error = [reporter errorWithCode:FIErrorMemoryAllocationFailed];
        AudioFileClose(fileId);
        return nil;
    }
    
    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [reporter
            errorWithCode:FIErrorFileFormatReadFailed
            description:@"Failed to read sound data."];
        free(data);
        AudioFileClose(fileId);
        return nil;
    }

    FISoundSample *sample = [[FISoundSample alloc] init];
    [sample setChannels:fileFormat.mChannelsPerFrame];
    [sample setEndianity:TestAudioFormatNativeEndian(fileFormat) ? kLittleEndian : kBigEndian];
    [sample setBitsPerChannel:fileFormat.mBitsPerChannel];
    [sample setSampleRate:fileFormat.mSampleRate];
    [sample setDuration:sampleLength];
    [sample setData:[NSData dataWithBytesNoCopy:data length:dataSize freeWhenDone:YES]];
    
    AudioFileClose(fileId);
    return [sample autorelease];
}

@end
