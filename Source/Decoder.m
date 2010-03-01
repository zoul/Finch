#import "Decoder.h"
#import "SNDError.h"

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

+ (Sample*) decodeFile: (NSString*) path error: (NSError**) error
{
    NSAssert([self class] == [Decoder class],
        @"Decoder subclasses have to override this method.");
    
    // Find suitable decoder
    for (NSString *extension in [decoders allKeys])
        if ([path hasSuffix:extension])
            return [[decoders objectForKey:extension]
                decodeFile:path error:error];
    
    // No decoder found
    *error = [SNDError errorWithCode:kDENoSuitableDecoderFound description:
        [NSString stringWithFormat:@"No suitable decoder found for %@.", path]];
    return nil;
}

@end
