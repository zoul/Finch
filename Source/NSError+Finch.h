enum FinchErrorCode
{
    kFinchErrorNoError,
    kFinchErrorNoDecoderFound,
};

@interface NSError (Finch)

+ (id) finchError: (int) code;
+ (id) finchError: (int) code withDescription: (NSString*) msg;

@end
