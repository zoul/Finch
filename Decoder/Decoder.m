#import "Decoder.h"
#import "FIErrorReporter.h"

static NSMutableDictionary *decoders = nil;

@implementation Decoder

#pragma mark Decoders

+ (void) registerDecoder: (Class) c forExtension: (NSString*) ext
{
    if (!decoders)
        decoders = [[NSMutableDictionary alloc] init];
    NSAssert2(![decoders objectForKey:ext],
        @"There is already a decoder for ”%@“: %@.",
        ext, [decoders objectForKey:ext]);
    [decoders setObject:c forKey:ext];
}

+ (FISoundSample*) decodeFile: (NSURL*) fileURL error: (NSError**) error
{
    NSAssert([self class] == [Decoder class],
        @"Decoder subclasses have to override this method.");
    
    // Find suitable decoder
    for (NSString *extension in [decoders allKeys])
        if ([fileURL.path hasSuffix:extension])
            return [[decoders objectForKey:extension]
                decodeFile:fileURL error:error];
    
    // No decoder found
    FIErrorReporter *reporter = [FIErrorReporter forDomain:@"Sample Decoder" error:error];
    *error = [reporter errorWithCode:kDENoSuitableDecoderFound description:
        [NSString stringWithFormat:@"No suitable decoder found for %@.", fileURL.path]];
    return nil;
}

@end
