@class Controller;

@interface Application : NSObject <UIApplicationDelegate>

@property(strong, nonatomic) IBOutlet UIWindow *window;
@property(strong, nonatomic) IBOutlet Controller *controller;

@end

