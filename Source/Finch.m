#import "Finch.h"
#import <AudioToolbox/AudioToolbox.h> 

@interface Finch (Private)
- (BOOL) openAudioSession;
+ (BOOL) isUserMusicPlaying;
- (BOOL) initOpenAL;
@end

@implementation Finch
@synthesize userMusicPlaying;

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
    
    // Initialize the audio session.
	errcode = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (errcode)
    {
        NSLog(@"Error initializing the audio session: %x", errcode);
        return NO;
    }

    /*
        Check if there is user music playing. We do
        not use this, but the called might be interested.
        The check has to be done AFTER we initialize the
        session and BEFORE we initialize OpenAL.
    */
	UInt32 userPlayback;
	UInt32 propertySize = sizeof(userPlayback);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
		&propertySize, &userPlayback);
    userMusicPlaying = (userPlayback != 0);

    /*
        This is a hack. AVAudioPlayer (or maybe somebody lower
        in the audio stack) sometimes refuses to play music, even
        though the OtherAudioIsPlaying property indicates that no
        other music is currently playing. It can be fixed by
        switching to Media Playback session category temporarily.
    */
    if (!userMusicPlaying)
    {
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
            sizeof(sessionCategory), &sessionCategory);
        AudioSessionSetActive(YES);
    }

    /*
        Set audio session cathegory. We use the Ambient Sound
        category in order to mix game sounds with whatever is
        playing underneath.
    */
	UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
	errcode = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
        sizeof(sessionCategory), &sessionCategory);
    if (errcode)
    {
        NSLog(@"Error setting session category: %x", errcode);
        return NO;
    }    
        
	errcode = AudioSessionSetActive(YES);
    if (errcode)
    {
        NSLog(@"Error activating the audio session: %x", errcode);
        return NO;
    }
    
    return YES;
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
