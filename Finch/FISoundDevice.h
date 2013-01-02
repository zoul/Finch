@interface FISoundDevice : NSObject

@property(assign, readonly) ALCdevice *handle;

+ (id) defaultSoundDevice;

@end
