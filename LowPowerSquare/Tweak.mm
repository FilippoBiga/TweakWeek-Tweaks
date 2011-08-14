#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface SBStatusBarDataManager : NSObject
+(id)sharedDataManager;
-(void)setThermalColor:(int)arg1 sunlightMode:(BOOL)arg2;
@end

%hook SBStatusBarDataManager

-(void)_updateBatteryPercentItem
{
    UIDevice *dev = [UIDevice currentDevice]; 
    
    [dev setBatteryMonitoringEnabled:YES]; 
    
    int batLeft = (int)([dev batteryLevel]*100); 
    
    [self setThermalColor:((batLeft<20)?2:0) sunlightMode:NO]
    
    %orig;
}


%end
