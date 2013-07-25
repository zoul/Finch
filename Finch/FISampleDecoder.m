#import "FISampleDecoder.h"
#import "FISampleBuffer.h"
#import "FIError.h"

#import "ExtAudioFileConvert.h"

@implementation FISampleDecoder

+ (FISampleBuffer*) decodeSampleAtPath: (NSString*) path andName: (NSString *) name error: (NSError**) error
{
    FI_INIT_ERROR_IF_NULL(error);

    // Read sample data
    AudioStreamBasicDescription *format = &(struct AudioStreamBasicDescription) {0};
    NSData *sampleData = [self readSampleDataAtPath:path fileFormat:format error:error];
    void *sampleDataRaw = nil;
    UInt32 sampleDataRawSize;
    AudioBufferList *convertedAudio = nil;
    if (!sampleData) {

        if ( [*error code] == FIErrorInvalidSampleFormat) {//then this audio file is not linear pcm, so we need to convert it
            convertedAudio = [self convertAudio:path withFormat:&format];
            sampleDataRaw = convertedAudio->mBuffers[0].mData;
            sampleDataRawSize = convertedAudio->mBuffers[0].mDataByteSize;
        }
        if (!sampleDataRaw)
            return nil;
    }
    else {
        sampleDataRaw = (void *)[sampleData bytes];
        sampleDataRawSize = [sampleData length];
    }

    // Check sample format
    if (![self checkFormatSanity:*format error:error]) {
        return nil;
    }

    // Create sample buffer
    NSError *bufferError = nil;
    FISampleBuffer *buffer = [[FISampleBuffer alloc]
        initWithData:sampleDataRaw ofLength:sampleDataRawSize sampleRate:format->mSampleRate
        sampleFormat:FISampleFormatMake(format->mChannelsPerFrame, format->mBitsPerChannel)
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

+ (void) getFileNameAndType: (NSString *) path outName: (NSString**) name outType: (NSString**) type {
    NSArray *fileNameArray = [path componentsSeparatedByString:@"."];
    
    if ([fileNameArray count] > 0) {
        *name = [fileNameArray objectAtIndex:0];
        //acount for filenames with more than one .
        if ([fileNameArray count] > 2) {
            for (int i = 1; i < [fileNameArray count]-1; i++){
                *name = [NSString stringWithFormat:@"%@.%@", *name, fileNameArray[i]];
            }
        }
    }
    if ([fileNameArray count] > 1) {
        *type = [fileNameArray objectAtIndex:([fileNameArray count]-1)];
    }
}

+ (AudioBufferList *) convertAudio: (NSString *) path withFormat: (AudioStreamBasicDescription**) format {
    
    CFURLRef sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    
    //NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *destinationFilePath = [[NSString alloc] initWithFormat: @"%@/outputt.caf", documentsDirectory];
    
    OSType outputFormat = kAudioFormatLinearPCM;
    AudioBufferList *convertedAudio = GetConvertedData(sourceURL, outputFormat, 0, format);
    
    //*outSize = new UInt32convertedAudio->mBuffers[0].mDataByteSize;
    
    return convertedAudio;
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
