#import "Finch.h"
#import <AudioToolbox/AudioToolbox.h> 

@interface Finch (Private)

- (BOOL) openAudioSession;
- (BOOL) initOpenAL;

@property(assign) UInt32 sessionCategory;

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

    // Check if some other sound is already playing.
	UInt32 userPlayback;
	UInt32 propertySize = sizeof(userPlayback);
	AudioSessionGetProperty(
        kAudioSessionProperty_OtherAudioIsPlaying,
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
        self.sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetActive(YES);
    }

    [self setMixWithSystemSound:userMusicPlaying];
        
	errcode = AudioSessionSetActive(YES);
    if (errcode)
    {
        NSLog(@"Error activating the audio session: %x", errcode);
        return NO;
    }
    
    return YES;
}

#pragma mark Audio Category

- (void) setSessionCategory: (UInt32) cat
{
    AudioSessionSetProperty(
        kAudioSessionProperty_AudioCategory,
        sizeof(cat), &cat);
}

- (UInt32) sessionCategory
{
    UInt32 propertySize = sizeof(UInt32), cat;
    AudioSessionGetProperty(
        kAudioSessionProperty_AudioCategory,
        &propertySize, &cat);
    return cat;
}

- (void) setMixWithSystemSound: (BOOL) mix
{
    self.sessionCategory = mix ?
        kAudioSessionCategory_AmbientSound :
        kAudioSessionCategory_SoloAmbientSound;
}

- (BOOL) mixWithSystemSound
{
    return (self.sessionCategory == kAudioSessionCategory_AmbientSound);
}

#pragma mark OpenAL Initialization

- (BOOL) initOpenAL
{
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
