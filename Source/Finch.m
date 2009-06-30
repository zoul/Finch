#import "Finch.h"
#import <AudioToolbox/AudioToolbox.h> 

@interface Finch (Private)
- (BOOL) openAudioSession;
+ (BOOL) isUserMusicPlaying;
- (BOOL) initOpenAL;
@end

@implementation Finch

- (id) init
{
    [super init];
    if (![self openAudioSession])
        return nil;
    if (![self initOpenAL])
        return nil;
    return self;
}

- (void) dealloc
{
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);
    [super dealloc];
}

#pragma mark Audio Session

- (BOOL) openAudioSession
{
    OSStatus errcode;
	errcode = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (errcode)
    {
        NSLog(@"Error initializing the audio session: %x", errcode);
        return NO;
    }
    
    // Mix user music with our sound.
	UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
	errcode = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
		sizeof(sessionCategory), &sessionCategory);
    if (errcode)
    {
        NSLog(@"Error setting session category: %x", errcode);
        return NO;
    }    
        
	errcode = AudioSessionSetActive(true);
    if (errcode)
    {
        NSLog(@"Error activating the audio session: %x", errcode);
        return NO;
    }
    
    return YES;
}

+ (BOOL) isUserMusicPlaying
{
	UInt32 userMusicPlaying;
	UInt32 propertySize = sizeof(userMusicPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
		&propertySize, &userMusicPlaying);
	return userMusicPlaying != 0;
}

#pragma mark OpenAL Initialization

- (BOOL) initOpenAL
{
    #if TARGET_IPHONE_SIMULATOR
    NSLog(@"Running on simulator, OpenAL might not work.");
    #endif
    
	device = alcOpenDevice(NULL);
    if (!device)
    {
        NSLog(@"Could not open default OpenAL device.");
        return NO;
    }
    
    context = alcCreateContext(device, 0);
    if (!context)
    {
        NSLog(@"Failed to create OpenAL context for default device.");
        return NO;
    }
    
    BOOL success = alcMakeContextCurrent(context);
    if (!success)
    {
        NSLog(@"Failed to set current OpenAL context.");
        return NO;
    }
    
    return YES;
}

@end
