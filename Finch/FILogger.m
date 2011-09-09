#import "FILogger.h"

const FILogger FILoggerNull  = ^(NSString *fmt, ...) {};
const FILogger FILoggerNSLog = ^(NSString *fmt, ...) {
    va_list arglist;
    va_start(arglist, fmt);
    NSLogv(fmt, arglist);
    va_end(arglist);
};