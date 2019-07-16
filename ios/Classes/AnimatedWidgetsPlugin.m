#import "AnimatedWidgetsPlugin.h"
#import <animated_widgets/animated_widgets-Swift.h>

@implementation AnimatedWidgetsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnimatedWidgetsPlugin registerWithRegistrar:registrar];
}
@end
