#import "Sound+IO.h"
#import <AudioToolbox/AudioToolbox.h> 

struct ReadInfo
{
    BOOL success;
    ALsizei bytesRead;
    ALsizei sampleRate;
    ALenum dataFormat;
    ALvoid *data;
};
typedef struct ReadInfo ReadInfo;

@interface Sound (Private)
- (id) initWithData: (ALvoid*) data length: (ALsizei) size
    format: (ALenum) format sampleRate: (ALsizei) frequency;
@end

@implementation Sound (IO)

- (ReadInfo) readPCMDataFrom: (NSURL*) path
{
    ReadInfo result = {NO};
	OSStatus errcode = noErr;
	UInt32 propertySize;
	AudioFileID fileId = 0;
	
	errcode = AudioFileOpenURL((CFURLRef) path, kAudioFileReadPermission, 0, &fileId);
	if (errcode)
    {
		NSLog(@"Failed to read audio file (%x).", errcode);
		goto exit;
	}
	
	AudioStreamBasicDescription fileFormat;
    propertySize = sizeof(fileFormat);
	errcode = AudioFileGetProperty(fileId, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
	if (errcode)
    {
		NSLog(@"Failed to read file format info (%x).", errcode);
		goto exit;
	}
	
	if (fileFormat.mChannelsPerFrame > 2)
    { 
		NSLog(@"More than two channels in sound file.");
		goto exit;
	}
	
	if (fileFormat.mFormatID != kAudioFormatLinearPCM)
    { 
		NSLog(@"Sound file not linear PCM.");
		goto exit;
	}
	
	if ((fileFormat.mBitsPerChannel != 8) && (fileFormat.mBitsPerChannel != 16))
    { 
		NSLog(@"Only files with 8 or 16 bits per channel supported.");
		goto exit;
	}
	
    UInt64 fileSize = 0;
    propertySize = sizeof(fileSize);
	errcode = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &propertySize, &fileSize);
	if (errcode)
    {
		NSLog(@"Failed to read sound file size (%x).", errcode);
		goto exit;
	}
    
    propertySize = sizeof(length);
    errcode = AudioFileGetProperty(fileId, kAudioFilePropertyEstimatedDuration, &propertySize, &length);
    if (errcode)
        NSLog(@"Failed to read sound length: %x.", errcode);
	
	UInt32 dataSize = (UInt32) fileSize;
	result.data = malloc(dataSize);
	if (!result.data)
    {
        NSLog(@"Failed to allocate memory for sound data.");
        goto exit;
    }
    
    errcode = AudioFileReadBytes(fileId, false, 0, &dataSize, result.data);
    if (errcode == noErr)
    {
        result.success = YES;
        result.bytesRead = dataSize;
        result.dataFormat = (fileFormat.mChannelsPerFrame > 1) ?
            AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
        result.sampleRate = fileFormat.mSampleRate;
    }
    else 
    { 
        NSLog(@"Failed to read sound data (%x).", errcode);
        goto exit;
    }	
	
exit:
	if (fileId)
        AudioFileClose(fileId);
    if (!result.success && result.data)
        free(result.data), result.data = 0;
	return result;
}

- (id) initWithFile: (NSString*) path
{
    ReadInfo info = [self readPCMDataFrom:[NSURL fileURLWithPath:path]];
    if (!info.success)
        return nil;
    return [self initWithData:info.data length:info.bytesRead
        format:info.dataFormat sampleRate:info.sampleRate];
}

@end
