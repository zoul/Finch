@import AudioToolbox;

#import "FISampleDecoder.h"
#import "FISampleBuffer.h"
#import "FIError.h"

@implementation FISampleDecoder

+ (FISampleBuffer*) decodeSampleAtPath: (NSString*) path error: (NSError**) error
{
    FI_INIT_ERROR_IF_NULL(error);

    // Read sample data
    AudioStreamBasicDescription format = {0};
    NSData *sampleData = [self readSampleDataAtPath:path fileFormat:&format error:error];
    if (!sampleData) {
        return nil;
    }

    // Check sample format
    if (![self checkFormatSanity:format error:error]) {
        return nil;
    }

    // Create sample buffer
    NSError *bufferError = nil;
    FISampleBuffer *buffer = [[FISampleBuffer alloc]
        initWithData:sampleData sampleRate:format.mSampleRate
        sampleFormat:FISampleFormatMake(format.mChannelsPerFrame, format.mBitsPerChannel)
        error:&bufferError];

    if (!buffer) {
        *error = [NSError errorWithDomain:FIErrorDomain
            code:FIErrorCannotCreateBuffer userInfo:@{
            NSLocalizedDescriptionKey : @"Cannot create sound buffer",
            NSUnderlyingErrorKey : bufferError
        }];
        return nil;
    }

    return buffer;
}

+ (BOOL) checkFormatSanity: (AudioStreamBasicDescription) format error: (NSError**) error
{
    NSParameterAssert(error);

    if (!TestAudioFormatNativeEndian(format)) {
        *error = [FIError
            errorWithMessage:@"Invalid sample endianity, only native endianity supported"
            code:FIErrorInvalidSampleFormat];
        return NO;
    }

    if (format.mChannelsPerFrame != 1 && format.mChannelsPerFrame != 2) {
        *error = [FIError
            errorWithMessage:@"Invalid number of sound channels, only mono and stereo supported"
            code:FIErrorInvalidSampleFormat];
        return NO;
    }

    if (format.mBitsPerChannel != 8 && format.mBitsPerChannel != 16) {
        *error = [FIError
            errorWithMessage:@"Invalid sample resolution, only 8-bit and 16-bit supported"
            code:FIErrorInvalidSampleFormat];
        return NO;
    }

    return YES;
}

+ (NSData*) readSampleDataAtPath: (NSString*) path fileFormat: (AudioStreamBasicDescription*) fileFormat error: (NSError**) error
{
    NSParameterAssert(fileFormat);
    NSParameterAssert(error);

    if (!path) {
        return nil;
    }

    OSStatus errcode = noErr;
    UInt32 propertySize;
    AudioFileID fileId = 0;

    NSURL *fileURL = [NSURL fileURLWithPath:path];
    errcode = AudioFileOpenURL((__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileId);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read file"
            code:FIErrorCannotReadFile];
        return nil;
    }

    propertySize = sizeof(*fileFormat);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, fileFormat);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read file format"
            code:FIErrorInvalidSampleFormat];
        AudioFileClose(fileId);
        return nil;
    }

    if (fileFormat->mFormatID != kAudioFormatLinearPCM) {
        *error = [FIError
            errorWithMessage:@"Audio format not linear PCM"
            code:FIErrorInvalidSampleFormat];
        AudioFileClose(fileId);
        return nil;
    }

    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read audio data byte count"
            code:FIErrorInvalidSampleFormat];
        AudioFileClose(fileId);
        return nil;
    }

    UInt32 dataSize = (UInt32) fileSize;
    void *data = malloc(dataSize);
    if (!data) {
        *error = [FIError
            errorWithMessage:@"Can’t allocate memory for audio data"
            code:FIErrorCannotAllocateMemory];
        AudioFileClose(fileId);
        return nil;
    }

    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [FIError
            errorWithMessage:@"Can’t read audio data from file"
            code:FIErrorInvalidSampleFormat];
        AudioFileClose(fileId);
        free(data);
        return nil;
    }

    AudioFileClose(fileId);
    return [NSData dataWithBytesNoCopy:data length:dataSize freeWhenDone:YES];
}

@end
