#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <objc/runtime.h>

%hook SBSearchController

-(void)searchBarSearchButtonClicked:(UISearchBar *)clicked
{
    %orig;
    
    NSString *text = clicked.text;
    NSRange range;
    
    range = [text rangeOfString:@"tel://"];
    
    if (range.location != NSNotFound)
    {
        NSString *tel = [clicked.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
        [[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:tel]];
        
    } else 
    {
        range = [text rangeOfString:@"://"];
        
        if (range.location != NSNotFound)
        {
            [[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:clicked.text]];
        } 
        else 
        {
            NSArray *keys = [[NSArray alloc] initWithObjects:@"www.",@".com",@".net",@".org",@".us",@".me",@".it",@".uk",@".de",nil];
            
            for (NSString *k in keys)
            {
                range = [text rangeOfString:k];
                if (range.location != NSNotFound)
                {
                    NSString *str = [NSString stringWithFormat:@"http://%@",text];
                    [[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:str]];
                    break;
                }
            }
            [keys release];
        }
        
    }
    
}

%end