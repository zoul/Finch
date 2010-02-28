#import "PCMDecoder.h"
#import "Sample.h"
#import <AudioToolbox/AudioToolbox.h> 

@interface Decoder (Errors)
+ (NSError*) errorWithCode: (int) decoderErrorCode;
+ (NSError*) errorWithCode: (int) decoderErrorCode description: (NSString*) msg;
@end

@implementation PCMDecoder

+ (Sample*) decodeFile: (NSString*) path error: (NSError**) error
{
	OSStatus errcode = noErr;
	UInt32 propertySize;
	AudioFileID fileId = 0;
    
	errcode = AudioFileOpenURL((CFURLRef) path, kAudioFileReadPermission, 0, &fileId);
	if (errcode) {
        *error = [Decoder errorWithCode:kDEFileReadError];
		return nil;
	}
	
	AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
	errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
	if (errcode) {
        *error = [Decoder errorWithCode:kDEFileFormatReadError];
        AudioFileClose(fileId);
		return nil;
	}

	if (fileFormat.mFormatID != kAudioFormatLinearPCM) { 
        *error = [Decoder
            errorWithCode:kDEInvalidFileFormat
            description:@"Sound file not linear PCM."];
        AudioFileClose(fileId);
		return nil;
	}
	
    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
	errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
	if (errcode) {
        *error = [Decoder
            errorWithCode:kDEFileFormatReadError
            description:@"Failed to read sound file size."];
        AudioFileClose(fileId);
        return nil;
	}

    float sampleLength = -1;
    propertySize = sizeof(sampleLength);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &sampleLength);
    if (errcode) {
        *error = [Decoder
            errorWithCode:kDEFileFormatReadError
            description:@"Failed to read sound length."];
        AudioFileClose(fileId);
        return nil;
    }

	UInt32 dataSize = (UInt32) fileSize;
	void *data = malloc(dataSize);
	if (!data) {
        *error = [Decoder errorWithCode:kDEMemoryAllocationError];
        AudioFileClose(fileId);
        return nil;
    }
    
    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, data);
    if (errcode) {
        *error = [Decoder
            errorWithCode:kDEFileFormatReadError
            description:@"Failed to read sound data."];
        free(data);
        AudioFileClose(fileId);
        return nil;
    }

	Sample *sample = [[Sample alloc] init];
    [sample setChannels:fileFormat.mChannelsPerFrame];
    [sample setEndianity:TestAudioFormatNativeEndian(fileFormat) ? kLittleEndian : kBigEndian];
    [sample setBitsPerChannel:fileFormat.mBitsPerChannel];
    [sample setDuration:sampleLength];
    [sample setData:[NSData dataWithBytesNoCopy:data length:dataSize freeWhenDone:YES]];
    
    return [sample autorelease];
}

+ (void) load
{
    [super registerDecoder:[self class] forExtension:@"wav"];
    [super registerDecoder:[self class] forExtension:@"caf"];
}

@end
