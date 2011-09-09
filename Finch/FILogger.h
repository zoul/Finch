typedef void (^FILogger)(NSString *fmt, ...);

extern const FILogger FILoggerNull;
extern const FILogger FILoggerNSLog;