#import "Decoder.h"

static NSString *const kErrorDomain = @"Sample Decoder";
static NSMutableDictionary *decoders = nil;

@implementation Decoder

#pragma mark Error Handling

+ (NSError*) errorWithCode: (int) decoderErrorCode
{
    return [NSError errorWithDomain:kErrorDomain
        code:decoderErrorCode userInfo:nil];
}

+ (NSError*) errorWithCode: (int) decoderErrorCode description: (NSString*) msg
{
    return [NSError errorWithDomain:kErrorDomain
        code:decoderErrorCode userInfo:[NSDictionary
        dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]];
}

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
    *error = [self errorWithCode:kDENoSuitableDecoderFound description:
        [NSString stringWithFormat:@"No suitable decoder found for %@.", path]];
    return nil;
}

@end
