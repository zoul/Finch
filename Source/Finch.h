@interface Finch : NSObject {}

// Returns YES if there is some other sound playing,
// for example the iPod.
@property(readonly) BOOL userMusicPlaying;

//
// If set to YES, your sound will mix with the system
// sound. The downside is that when the mix is on, MP3
// decoding performance drops significantly:
// 
// http://stackoverflow.com/questions/1009385
// 
// By default we turn the mixing on if there is something
// playing when you initialize Finch.
// 
@property(assign) BOOL mixWithSystemSound;

@end
