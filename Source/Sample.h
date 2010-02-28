enum SampleEndianity
{
    kEndianityUnknown = -1,
    kLittleEndian,
    kBigEndian
};

@interface Sample : NSObject
{
    int channels;
    int bitsPerChannel;
    int sampleRate;
    int endianity;
    float duration;
    NSData *data;
}

@property(assign) int channels;
@property(assign) int bitsPerChannel;
@property(assign) int sampleRate;
@property(assign) int endianity;
@property(assign) float duration;
@property(retain) NSData *data;

@end
