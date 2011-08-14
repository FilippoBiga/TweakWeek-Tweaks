#import <UIKit/UIKit.h>

float red, green, blue; 
UIColor *flashColor;

%hook SBScreenFlash

-(void)flashColor:(UIColor *)color
{
    red = ((arc4random() % 255) / 255.0f);
    green = ((arc4random() % 255) / 255.0f);
    blue = ((arc4random() % 255) / 255.0f);
        
    flashColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    %orig(flashColor);
}

%end
