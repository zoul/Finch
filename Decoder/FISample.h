@interface FISample : NSObject

@property(assign) NSTimeInterval duration;
@property(assign) BOOL hasNativeEndianity;

@property(assign) NSUInteger numberOfChannels;
@property(assign) NSUInteger bitsPerChannel;
@property(assign) NSUInteger sampleRate;

@property(strong) NSData *data;

- (ALenum) openALFormat;

@end
